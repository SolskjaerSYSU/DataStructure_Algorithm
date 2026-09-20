[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Source
)

$ErrorActionPreference = 'Stop'

$projectRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..')).TrimEnd('\')
$projectRootWithSeparator = $projectRoot + [System.IO.Path]::DirectorySeparatorChar
$sourceItem = Get-Item -LiteralPath $Source
$sourcePath = [System.IO.Path]::GetFullPath($sourceItem.FullName)
$sourceExtension = [System.IO.Path]::GetExtension($sourcePath).ToLowerInvariant()

if ($sourceExtension -notin @('.cpp', '.cc', '.cxx', '.c++')) {
    Write-Error "Expected a C++ source file, received: $sourcePath"
    exit 2
}

if (-not $sourcePath.StartsWith($projectRootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
    Write-Error "The source file must be inside this workspace: $projectRoot"
    exit 2
}

$compiler = Get-Command 'g++' -CommandType Application -ErrorAction Stop
$outputDirectory = Join-Path $env:TEMP ('dsa-run-' + [guid]::NewGuid().ToString('N'))
$outputPath = Join-Path $outputDirectory ($sourceItem.BaseName + '.exe')

New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null

$compilerArguments = @(
    '-std=c++17',
    '-Wall',
    '-Wextra',
    '-Wpedantic',
    '-g',
    $sourcePath,
    '-o',
    $outputPath
)

Push-Location -LiteralPath $sourceItem.DirectoryName
try {
    & $compiler.Source @compilerArguments
    $compileExitCode = $LASTEXITCODE
    if ($compileExitCode -ne 0) {
        exit $compileExitCode
    }

    & $outputPath
    $programExitCode = $LASTEXITCODE
}
finally {
    Pop-Location
    Remove-Item -LiteralPath $outputPath -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $outputDirectory -Force -ErrorAction SilentlyContinue
}

exit $programExitCode
