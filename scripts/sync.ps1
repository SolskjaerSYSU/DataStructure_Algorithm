param([string]$Message = '')

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$expectedRemote = 'https://github.com/SolskjaerSYSU/DataStructure_Algorithm.git'
$previousLocation = Get-Location
$syncLock = $null

function Invoke-Git {
    param([string[]]$GitArgs)
    & git @GitArgs
    if ($LASTEXITCODE -ne 0) {
        throw ('Git command failed: git ' + ($GitArgs -join ' '))
    }
}

try {
    Set-Location -LiteralPath $repoRoot
    $actualRoot = (Invoke-Git -GitArgs @('rev-parse', '--show-toplevel')).Trim()
    if ([IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($repoRoot)) {
        throw 'This folder must be its own Git repository.'
    }

    $gitDir = (Invoke-Git -GitArgs @('rev-parse', '--absolute-git-dir')).Trim()
    $syncLock = [IO.File]::Open((Join-Path $gitDir 'study-sync.lock'), 'OpenOrCreate', 'ReadWrite', 'None')

    foreach ($marker in @('MERGE_HEAD', 'CHERRY_PICK_HEAD', 'REVERT_HEAD', 'rebase-merge', 'rebase-apply')) {
        if (Test-Path -LiteralPath (Join-Path $gitDir $marker)) {
            throw 'Finish the current merge/rebase/cherry-pick/revert before syncing.'
        }
    }

    $branch = (Invoke-Git -GitArgs @('branch', '--show-current')).Trim()
    if ($branch -ne 'main') { throw 'One-click sync is configured for main. Switch to main first.' }
    $remote = (Invoke-Git -GitArgs @('remote', 'get-url', 'origin')).Trim()
    $pushRemotes = @(Invoke-Git -GitArgs @('remote', 'get-url', '--push', '--all', 'origin'))
    if ($remote -ne $expectedRemote -or $pushRemotes.Count -ne 1 -or $pushRemotes[0] -ne $expectedRemote) {
        throw 'The origin URL does not match the configured learning repository.'
    }

    Write-Host 'Checking GitHub connection and remote history...'
    Invoke-Git -GitArgs @('fetch', 'origin', '--prune')
    & git show-ref --verify --quiet refs/remotes/origin/main
    $remoteRefStatus = $LASTEXITCODE
    if ($remoteRefStatus -eq 0) {
        $behind = Invoke-Git -GitArgs @('rev-list', '--count', 'HEAD..origin/main')
        if ([int]$behind -gt 0) {
            throw 'Remote main has new commits. Integrate them manually before syncing; no files were staged by this run.'
        }
    } elseif ($remoteRefStatus -ne 1) {
        throw 'Unable to inspect origin/main.'
    }

    Invoke-Git -GitArgs @('add', '--all', '--', '.')

    # Inspect the complete staged snapshot, including accidentally force-added files.
    # Print filenames only: never echo matching secret values into terminal logs.
    $trackedFiles = @(Invoke-Git -GitArgs @('-c', 'core.quotepath=false', 'ls-files'))
    $blockedFiles = @($trackedFiles | Where-Object {
        $_ -match '(^|/)(private|\.ssh|\.aws)/' -or
        ($_ -match '(^|/)\.env($|\.)' -and $_ -notmatch '(^|/)\.env\.example$') -or
        $_ -match '(?i)(\.(pem|key|pfx|p12|keystore)$|(^|/)(id_rsa|id_ed25519|credentials\.json|secrets\.json)$)'
    })
    if ($blockedFiles.Count -gt 0) {
        throw ('Sensitive filenames are staged. Remove them from Git tracking: ' + ($blockedFiles -join ', '))
    }
    $secretPatterns = @(
        'gh[pousr]_[A-Za-z0-9]{30,}',
        'github_pat_[A-Za-z0-9_]{40,}',
        '(AKIA|ASIA)[A-Z0-9]{16}',
        'sk-(proj-|svcacct-)?[A-Za-z0-9_-]{32,}',
        'xox[baprs]-[A-Za-z0-9-]{20,}',
        '-----BEGIN ([A-Z0-9]+ )*PRIVATE KEY-----'
    )
    $secretFiles = @(& git -c core.quotepath=false grep --cached -I -l -E -e ($secretPatterns -join '|') -- .)
    $scanStatus = $LASTEXITCODE
    if ($scanStatus -eq 0) {
        throw ('Possible credential detected. Nothing was committed or pushed. Inspect these files locally: ' + ($secretFiles -join ', '))
    } elseif ($scanStatus -ne 1) {
        throw 'Credential scan failed; sync stopped.'
    }

    & git diff --cached --quiet --exit-code
    $diffStatus = $LASTEXITCODE
    if ($diffStatus -eq 1) {
        Invoke-Git -GitArgs @('diff', '--cached', '--stat')
        if ([string]::IsNullOrWhiteSpace($Message)) {
            $Message = 'study: update ' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss zzz')
        }
        Invoke-Git -GitArgs @('commit', '-m', $Message)
    } elseif ($diffStatus -eq 0) {
        Write-Host 'No file changes. Checking for unpublished commits without creating an empty commit.'
    } else {
        throw 'Unable to inspect staged changes.'
    }

    Invoke-Git -GitArgs @('push', '--set-upstream', 'origin', 'main')
    Write-Host '[OK] Push completed: https://github.com/SolskjaerSYSU/DataStructure_Algorithm' -ForegroundColor Green
} catch {
    Write-Host ('[FAILED] ' + $_.Exception.Message) -ForegroundColor Red
    Write-Host 'Local files and commits are retained. Fix the reported issue and run again.'
    exit 1
} finally {
    if ($null -ne $syncLock) { $syncLock.Dispose() }
    Set-Location -LiteralPath $previousLocation.Path
}
