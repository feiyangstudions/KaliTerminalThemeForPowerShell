<#
    Feiyang的仿kali终端美化安装程序
    Made by FeiyangStudios
#>
$enc = if ($PSVersionTable.PSVersion.Major -ge 7) { "utf8BOM" } else { "UTF8" }
$content = @'
function su {
    $elevated = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if ($elevated) { Write-Host '当前已经是管理员窗口。' -ForegroundColor Yellow; return }

    $pkg = Get-AppxPackage -Name 'Microsoft.WindowsTerminal' | Sort-Object Version -Descending | Select-Object -First 1
    if (-not $pkg) { Write-Host '未找到 Windows Terminal，请先安装。' -ForegroundColor Red; return }

    Start-Process -FilePath (Join-Path $pkg.InstallLocation 'wt.exe') -Verb RunAs -ArgumentList @('-d', "`"$($PWD.Path)`"")

    exit
}

function prompt {
	$isAdmin  = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) #判断是否是管理员权限运行
    $user     = if (!$isAdmin) {$env:USERNAME} else {'root'}
    $computer = $env:COMPUTERNAME
    $drive    = $PWD.Drive.Name
    $path     = $PWD.Path.Replace($HOME, '~').Replace($drive+':', '/mnt/'+$drive.ToLower()).Replace('\','/')

	if (!$isAdmin) {
    	Write-Host ""
    	Write-Host "┌──(" -NoNewline -ForegroundColor Green
    	Write-Host "$user㉿$computer" -NoNewline -ForegroundColor Blue
    	Write-Host ")-[" -NoNewline -ForegroundColor Green
    	Write-Host $path -NoNewline
    	Write-Host "]" -ForegroundColor Green
    	Write-Host "└─" -NoNewline -ForegroundColor Green
    	Write-Host "$" -NoNewline -ForegroundColor Blue
    	return " "
    } else {
    	Write-Host ""
    	Write-Host "┌──(" -NoNewline -ForegroundColor Blue
    	Write-Host "$user㉿$computer" -NoNewline -ForegroundColor Red
    	Write-Host ")-[" -NoNewline -ForegroundColor Blue
    	Write-Host $path -NoNewline
    	Write-Host "]" -ForegroundColor Blue
    	Write-Host "└─" -NoNewline -ForegroundColor Blue
    	Write-Host "#" -NoNewline -ForegroundColor Red
    	return " "
    }
}
clear
Write-Host "Windows PowerShell"
Write-Host "版权所有（C） Microsoft Corporation。保留所有权利。"
Write-Host ""
Write-Host "终端美化脚本 by " -NoNewline -ForegroundColor Green
Write-Host "FeiyangStudios" -NoNewline -ForegroundColor Yellow
Write-Host "; 灵感基于 " -NoNewline -ForegroundColor Green
Write-Host "Kali Linux" -ForegroundColor Blue
Write-Host "本脚本已添加su提权功能！（无需使用sudo）" -ForegroundColor Red
Write-Host "请注意，本脚本中管理员窗口会显示为root用户，实际上并不具有真正root权限" -BackgroundColor Red
Write-Host ""
Write-Host "安装最新的 PowerShell，了解新功能和改进！https://aka.ms/PSWindows"
'@
$profileDir = Split-Path -Parent $profile
$bakName    = (Split-Path -Leaf $profile) + '.bak'
$bakPath    = Join-Path $profileDir $bakName
$skipBackup = $false

if (-not (Test-Path $profileDir -PathType Container)) {
    Write-Host '[+] 检测到配置文件目录不存在，正在创建...' -ForegroundColor Green
    New-Item -Path $profileDir -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $profile -PathType Leaf)) {
    Write-Host '[+] 检测到配置文件不存在，正在创建...' -ForegroundColor Green
    New-Item -Path $profile -ItemType File -Force | Out-Null
} else {
    Write-Host '[+] 检测到配置文件已存在，正在尝试备份...' -ForegroundColor Green
    if (Test-Path $bakPath -PathType Leaf) {
        Write-Host '[+] 检测到备份文件已存在，是否覆盖原有备份？[y/n] ' -ForegroundColor Blue -NoNewline
        $answer = Read-Host ''
        if ($answer -notmatch '^y') {
            Write-Host '[+] 您是否要退出安装？如果您要不备份直接安装，请输入全大写的"YES"（您的原配置将会被永久删除） ' -ForegroundColor Blue -NoNewline
            $answer = Read-Host ''
            if ($answer -cmatch '^YES$') {
                Remove-Item $profile -Force
                $skipBackup = $true
            } else {
                Write-Host '[!] 已取消安装，脚本停止执行。' -ForegroundColor Red
                exit
            }
        } else {
            Remove-Item $bakPath -Force
        }
    }
    if (-not $skipBackup) {
        Rename-Item -Path $profile -NewName $bakName
    }
}

Write-Host '[*] 正在将脚本注入配置...' -ForegroundColor Blue
Set-Content -Path $profile -Value $content -Encoding $enc
Write-Host '[+] Feiyang的仿kali终端美化脚本已安装完成!'