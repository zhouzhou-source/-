# === 这是给系统独立终端定制的极简 ~ 前缀 ===
function prompt {
    # 获取当前真实的系统路径
    $realPath = (Get-Location).Path
    
    # 视觉欺骗：把长长的用户目录直接替换成 ~
    $displayPath = $realPath.Replace("C:\Users\WJD", "~")

    # 打印伪装后的路径（颜色我保留了白色，你可以按喜好改）
    Write-Host $displayPath -NoNewline -ForegroundColor White
    
    return "> "
}


# === 以下是之前配置的，专门给 VS Code 用的炫酷主题 ===
# 判断当前是否在 VS Code 的终端里
if ($env:TERM_PROGRAM -eq "vscode") {
    # 只有在 VS Code 里才执行下面这三行美化和补全代码
    oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
    Import-Module posh-git
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}
