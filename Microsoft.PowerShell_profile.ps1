oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
Import-Module posh-git
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete