# DataStructure_Algorithm

数据结构与算法学习：记录实现、题解、复杂度分析和复盘。

## 每天的操作

1. 用 VS Code 打开 **本仓库文件夹**，不要只打开上一级 `D:\VSC_Code`。
2. 编写代码或笔记，保存；建议先编译、运行并检查答案。
3. 按 **Ctrl+Shift+B**，执行 `Git: One-click commit and push`。
4. 等待终端出现绿色 `[OK] Push completed`，表示 Git 推送成功。

这里特意把默认构建快捷键用于同步 Git，**不会编译、测试或判断算法正确性**。
VS Code 任务会先保存编辑器文件；双击运行仓库中的 `sync.cmd` 也能同步，但需要自己提前保存。

## C++ 编辑体验

本机 VS Code 的 C++ 用户设置及本仓库配置使用微软 C/C++ 扩展内置的 Visual C++ 格式引擎，
尽量贴近 Visual Studio：输入 `;` 时格式化代码行、保存时格式化，使用四空格缩进、Allman 大括号，
并整理赋值与二元运算符周围的空格。`Ctrl+Shift+B` 仍用于一键同步。

VS Code 自带的 C++ 自动配对包括 `()`, `[]`, `{}` 和引号；`<`、`>` 可用于包围所选文本，
但默认 C++ 语言配置不会在每次输入 `<` 时自动插入 `>`。
这是为了避免把普通比较 `a < b` 错误改成 `a <> b`；模板尖括号配对需依据语法判断，
当前配置不强行启用无条件补全。

脚本会提交仓库内所有未忽略的新增、修改和删除内容，使用当前真实时间生成提交说明。
没有文件变化时不创建空提交，但仍会推送之前未上传的提交。不强制推送，不自动合并冲突。
断网、认证失效、远程有新提交时会报错，请查看终端；本地内容不会因此丢失。
提交前还会检查敏感文件名和常见密钥格式；检查失败时可能已暂存，但不会继续提交或推送。

自定义提交说明（在项目根目录的 PowerShell 运行）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync.ps1 -Message "study: implement binary search"
```

## 目录约定

```text
data_structures/   数据结构实现：链表、栈、队列、树等
algorithms/        算法实现：排序、搜索、动态规划等
problems/          平台练习题，建议按平台/题号命名
notes/             知识点、错题、复杂度分析
scripts/           项目辅助脚本
.vscode/           本项目的 VS Code 配置
```

推荐命名：`algorithms/binary_search.cpp`、`problems/leetcode/0001_two_sum.cpp`。
每道独立可执行练习可以有自己的 `main()`，不要一次把所有练习链接成一个程序。
Git 跟踪文件，空目录内的 `.gitkeep` 只是占位文件，加入代码后可以删除。

## 编译环境

本仓库先完成 GitHub 同步工作流。当前机器原有 GCC 6.3.0，升级 MSYS2 UCRT64、
配置 CMake 和断点调试属于开发环境搭建步骤，不能把推送成功当作编译环境已经验收。
编译生成物放在 `build/`，该目录已被忽略。

## 贡献记录

提交使用与 GitHub 账号关联的邮箱，推送到默认分支 `main` 后才满足常规提交贡献条件。
本仓库为公开仓库，任何人都能读取已推送的文件和提交历史。
GitHub 贡献图可能需要最多 24 小时更新；一天多次 push 并不等于多次新提交。
请记录真实学习改动，不需要空提交或修改日期。

官方说明：https://docs.github.com/en/account-and-profile/how-tos/contribution-settings/troubleshooting-missing-contributions

## 常见问题

- **快捷键没有运行本任务**：确认打开的是本项目；在命令面板选择 `Tasks: Run Task`，再选一键任务。
- **终端一直等待**：检查 Git Credential Manager 是否弹出浏览器登录窗口。
- **远程有新提交**：先保存本地工作，在理解差异后手动整合；不要强推覆盖远程。
- **出现 `[FAILED]`**：查看上方原因，解决后重复运行。若之前已提交但没上传，会重试上传，不重复提交。
- **不想上传某文件**：提交前加入 `.gitignore`。已经被 Git 跟踪的文件不能仅靠新增忽略规则取消跟踪。

不要在代码、笔记或配置中保存密码、访问令牌等凭据。
`.env`、`private/`、常见密钥文件等已被忽略；认证凭据由本机 Git Credential Manager 管理。
推送脚本会拦截部分常见令牌、私钥和敏感文件名，但不能识别所有密码、个人信息和自定义密钥，
也不替代 GitHub 的安全功能。手动 `git push` 不会运行这个脚本的检查。
最好把真实秘密放在仓库之外。公开仓库不会自动隐藏隐私内容；删除文件也不会删除历史中的秘密。
如曾误传密钥，首先撤销或轮换密钥，再处理历史。
