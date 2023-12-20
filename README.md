<br />
<div align="center">
  <a href="https://github.com/iinsertNameHere/Catnip">
    <img src="image/logo.png" alt="Logo" width="200" height="200">
  </a>

<h3 align="center"><code>Catnip🌿</code> Systemfetch</h3>
  <p align="center">
    <a href="#-demo-image">View Demo</a>
    ·
    <a href="#-compilationinstallation-linux">Linux Installation</a>
    ·
    <a href="#-compilationinstallation-windows">Windows Installation</a>
  </p>
</div>
<br>

## 🌿 What is Catnip
I created Catnip as a playful, simple system-information **concatenation** tool using `nim👑`. It is quite **customizable** and has possibilities to alter the names and colors of the statistics. In the future, I also intend to add more distribution logos. Feel free to contribute to the project at any time.

> #### ⏱️ Execution Time 
> *Around **0.0008** seconds on my laptop*

### 📊 Displayed Statistics
- username
- hostname
- system uptime
- running os
- running kernel
- desktop env
- used shell
- terminal colors

## 📷 Demo Image
>**NOTE:** Design was inspired by <code><a href="https://github.com/ssleert/nitch">Nitch👑</a></code>

> <img width=500 src="image/demo.png">

## 💻 Usage
Run catnip in you terminal:
```bash
./catnip
```

Change the distro icon using:
```bash
./catnip [distroname]
```


## 🪡 Compilation/Installation (LINUX)
**1.** Install <a href="https://nim-lang.org/install.html">`nim👑`</a>

**2.** Clone the repo:
```bash
git clone https://github.com/iinsertNameHere/Catnip.git
```
**3.** Change dir into the repo
```bash
cd ./Catnip/src
```

**4.** Run `nim👑` compilation:
```bash
nim c -d:release catnip.nim
```

**5.** Copy config to ~/.config:
```bash
cp ../catnip.json ~/catnip.json
```
## 🪡 Compilation/Installation (WINDOWS)
**1.** Install <a href="https://nim-lang.org/install.html">`nim👑`</a>

**2.** Clone the repo:
```powershell
wget "https://codeload.github.com/iinsertNameHere/Catnip/zip/refs/heads/main" -outfile "Catnip.zip" 
```

**3.** Expand zipfile
```powershell
Expand-Archive -Path "Catnip.zip"
```

**4.** Change dir into the repo
```powershell
cd ".\Catnip\Catnip-main\src"
```

**5.** Run `nim👑` compilation:
```powershell
nim c -d:release catnip.nim
```

**6.** Copy config to home dir:
```powershell
cp "..\catnip.json" "C:\Users\$env:username\catnip.json"
```

> **NOTE:** For the icons to work, make sure you set a [NerdFont](https://www.nerdfonts.com/) as you terminal font.

## 🗃️ Todos
- [ ] Add more Distro logos
- [X] Add config options for icons
- [X] Add more config options for colors
- [X] Make Catnip crossplatform
- [ ] Add config options for layout
