# Feiyang 的仿 Kali 终端美化

> 一个让 Windows PowerShell 拥有 Kali Linux 风格提示符的轻量美化脚本  
> by **FeiyangStudios** · 灵感基于 **Kali Linux**

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%20%7C%207%2B-blue.svg)](https://learn.microsoft.com/powershell/)

---

## ✨ 特性

- 🐧 **Kali 风格提示符**：`┌──(user㉿host)-[path]` / `└─$` 的经典双行布局
- 🎨 **权限感知配色**：普通用户为绿色系，管理员窗口自动切换为蓝色系并显示 `root` 与 `#`
- 🔐 **内置 `su` 提权**：在终端内直接打开管理员窗口，无需手动右键“以管理员身份运行”
- 📦 **自动备份**：安装前自动备份原 `$PROFILE` 为 `.bak`，避免误覆盖
- 🪶 **零依赖**：纯 PowerShell 实现，不依赖任何第三方模块

---

## 📸 预览
```
┌──(feiyang㉿DESKTOP)-[~]
└─$ ls
```

```
┌──(root㉿DESKTOP)-[/mnt/c/Windows/System32]
└─# net session
列表是空的。
```
> 管理员窗口中的 `root` 仅为视觉显示，实际身份是 **Windows 管理员**，并非真正的 Linux root。  
> 并注意：只有**以管理员身份运行PowerShell**才会显示root，管理员用户直接执行不会显示root
> `net session` 是 Windows 中验证管理员权限的经典命令：只有在管理员窗口中才能成功执行，普通窗口会报“发生系统错误 5。拒绝访问。”

---

## 🚀 安装

### 方式一：远程安装（推荐）

在 **Windows PowerShell 5.1** 或 **PowerShell 7+** 中执行：

```powershell
irm https://feiyangstudions.github.io/KaliTerminalThemeForPowerShell/install/ | iex
```

脚本会自动完成备份与写入，无需手动下载文件。

### 方式二：本地安装

1. 从仓库下载[安装脚本](https://raw.githubusercontent.com/feiyangstudions/KaliTerminalThemeForPowerShell/main/install/install.ps1)
2. 在脚本所在目录右键选择 **“在终端中打开”**
3. 执行：

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

> `install.ps1` 采用 **UTF-8 with BOM** 编码，在 Windows PowerShell 5.1 下可直接运行并正确显示中文。

安装完成后，**重新打开终端** 即可看到新的提示符。

---

## 🛠 使用

### `su` —— 打开管理员窗口

在普通终端中执行：

```powershell
su
```

脚本会通过 Windows Terminal 以管理员身份打开一个新窗口，并自动切换到当前目录。若当前已经是管理员窗口，则会提示无需重复提权。

> ⚠️ `su` 依赖 **Windows Terminal**（`Microsoft.WindowsTerminal`）。若未安装，请先从 [Microsoft Store](https://aka.ms/terminal) 安装。

### 路径显示规则

| 实际路径                | 提示符中的显示            |
| :---------------------- | :------------------------ |
| `C:\Users\<你>`         | `~`                       |
| `C:\Users\<你>\Desktop` | `~/Desktop`               |
| `D:\Projects`           | `/mnt/d/Projects`         |
| `C:\Windows\System32`   | `/mnt/c/Windows/System32` |

## ⚠️ 注意事项

- 脚本会修改 **当前用户、当前宿主** 的 PowerShell 配置文件 `$PROFILE`，不会影响其他用户或 `AllUsersAllHosts` 配置。
- 安装前会自动备份为 `.bak`；若备份已存在，脚本会询问是覆盖、无备份安装还是取消。
- 若提示 **“无法加载文件，因为在此系统上禁止运行脚本”**，可先执行：

```powershell
Set-ExecutionPolicy -Scope Process Bypass
```

- 再重新运行安装命令。

- 管理员窗口中的 `root` 为视觉模拟，**不具备真正的 Linux root 权限**，请以 Windows 管理员权限的实际能力为准。
- 卸载方法：删除或还原 `$PROFILE`，或直接删除 `$PROFILE` 中的相关函数定义即可。

---

## 📄 许可证

本项目基于 [MIT License](https://license/) 开源。

你可以自由使用、修改、分发本项目，包括用于商业用途，只需保留原始版权声明与许可证文本。

------

## 🙏 致谢

- 灵感来源：[Kali Linux](https://www.kali.org/) 的经典终端提示符
- 感谢所有提出建议与反馈的使用者

------

<p align="center"> <sub>Made in China ❤️ by FeiyangStudios</sub> </p>

