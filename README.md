# -
环境配置
配置步骤：
1. VS Code 自身的配置同步
VS Code 自带了非常好用的 Settings Sync（设置同步） 功能（左下角的齿轮图标里可以登录微软或 GitHub 账号开启）。自动把 VS Code 里的：

安装的插件（比如 C/C++ 插件、PowerShell 插件）

快捷键设置

界面主题和字体
全部同步到新电脑上。但是，它不会帮你同步那个 PowerShell 的配置文件。

2. PowerShell 环境的“复刻” (你需要做的事)
如果想在另一台电脑上也拥有今天配置的这套完美的 Git 提示和补全功能，仅仅把刚才那个记事本里的三行代码粘贴过去是会报错的。因为新电脑上还没有安装这些“超能力”模块。

在新电脑上，你需要按顺序重新配置一次：

第一步：重新安装核心模块（在终端里运行）
安装 Oh My Posh（如果需要美化）：winget install JanDeDobbeleer.OhMyPosh -s winget
安装 posh-git：Install-Module posh-git -Scope CurrentUser -Force

第二步：重新写入配置文件
在新电脑的终端里输入 notepad $PROFILE 创建并打开文件。

第三步：粘贴那三行代码
这时候，你就可以把你刚才截图里的那三行完美配置代码，原封不动地粘贴进去并保存了。



# -
//notepad $PROFILE文件的路径更改//
严格来说，$PROFILE 这个变量本身的路径是系统写死的，不能直接更改。 它默认固定在 C 盘的“文档 (Documents)”文件夹下（比如 C:\Users\你的用户名\Documents\PowerShell\）。

但是，很多开发者并不想把配置留在 C 盘，尤其是当你的主开发环境、工具和项目都已经集中在 D 盘的自定义文件夹时。为了方便统一管理，或者以后打包带走，我们可以用一个极其常用的“指针引用”法（Dot-Sourcing）来完美绕过这个限制。

简单来说：我们保留 C 盘那个系统认准的默认文件，但清空里面的内容，只写一行“跳转代码”，让它去加载你存放在 D 盘的真实配置文件。

具体操作如下：

第一步：在 D 盘建立你真正的配置文件
在你觉得方便的任意位置（比如你的 D 盘开发文件夹里），新建一个文本文件，命名为 my_profile.ps1。
把之前那三行配置代码写进这个文件里并保存：

PowerShell
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\paradox.omp.json" | Invoke-Expression
Import-Module posh-git
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
假设你把它存在了 D:\DevTools\my_profile.ps1。

第二步：把 C 盘的默认配置变成“指针”
在 PowerShell 里再次运行 notepad $PROFILE，打开 C 盘那个默认的配置文件。

删掉里面所有的代码，只写下面这一行（注意最前面有个英文句号和一个空格，这在 PowerShell 里叫作“点呼叫”，意思是把后面的脚本拿过来直接在当前环境执行）：

PowerShell
. "D:\DevTools\my_profile.ps1"
保存并关闭记事本。

这样做的好处：
彻底解耦： PowerShell 启动时，还是会乖乖去读 C 盘那个 $PROFILE，但一读就会立刻顺藤摸瓜，去执行你 D 盘里真正的配置。

方便迁移： 以后无论你怎么重装系统，或者换电脑，你在 D 盘自定义文件夹里的 my_profile.ps1 核心资产都不会丢。重装后，只需在新电脑的 $PROFILE 里重新把这行“指针”指过去就全通了。
