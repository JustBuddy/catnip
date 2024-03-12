<br />
<div align="center">
  <a href="https://github.com/iinsertNameHere/Catnip">
    <img src="image/logo.png" alt="Logo" width="200" height="200">
  </a>

<h1 align="center"><code>Catnip🌿</code> Systemfetch</h3>
  <p align="center">
    <a href="#-demo-image">View Demo</a>
    ·
    <a href="#-installationbuild">Installation</a>
    ·
    <a href="#-usage">Basic Usage</a>
    ·
    <a href="#-configuration">Configuration</a>
    ·
    <a href="#thanks-to-all-contributors-">Contributors</a>
  </p>
</div>
<br>

## 🌿 What is Catnip
I created `Catnip🌿` as a playful, simple system-information **concatenation** tool using `nim👑`. It is quite **customizable** and has possibilities to alter the names and colors of the statistics. In the future, I also intend to add more distribution logos. Feel free to contribute to the project at any time.

> #### ⏱️ Execution Time 
> *Around **0.006** seconds on my laptop*

#### 📊 Displayed Statistics
<details>
  <summary style="font-size: 18px; font-weight: 600;">View Statistics</summary>
  <ul>
    <li>username</li>
    <li>hostname</li>
    <li>uptime</li>
    <li>os</li>
    <li>kernel</li>
    <li>desktop</li>
    <li>shell</li>
    <li>terminal colors</li>
  </ul>
</details>

#### ❤ Shoutout to:
- [NimParsers/parsetoml](https://github.com/NimParsers/parsetoml) for the toml parsing
- [ssleert/Nitch](https://github.com/ssleert/nitch) for the inspiration
- [All contributors](#thanks-to-all-contributors-)

<br>

## 📷 Demo Image
> <img width=500 src="image/demo.png">

<br>

## 🪡 Installation/Build
**1.** Install <a href="https://nim-lang.org/install.html">`nim👑`</a> and all dependencies
```
Dependencies (Linux only):
- pcre
- figlet
```

**2.** Clone the repo:
```shell
git clone https://github.com/iinsertNameHere/catnip.git
```
**3.** Change dir to repo
```shell
cd ./catnip
```

**4.** Run setup using `nim👑`:
```shell
nim setup
```

**5.** Your compiled executable can be found in ./bin:
```shell
./bin/catnip
```

> **NOTE:** For the icons to work, make sure you set a [NerdFont](https://www.nerdfonts.com/) as you terminal font.

<br>

## 💻 Usage
Run catnip in you terminal:
```bash
$ catnip
```

Change the distro icon using:
```bash
$ catnip -d <distro>
```

To get a full list of arguments use:
```bash
$ catnip --help
```

<br>

## 📒 Configuration
> **The config file is located at:**
> -  `~/.config/catnip/config.toml`: Linux
> -  `C:\Users\%USERNAME%\catnip\config.toml`: Windows

<br>

You can change the names, colors, and icons for the various stats inside the `stats` section.

*Example `stats` section that dose not use NerdFont icons:* 
```toml
##############################################
##          FetchInfo stats Config          ##
##############################################
[stats]
username = {icon = ">", name = "user", color = "(RD)"}
hostname = {icon = ">", name = "hname", color = "(YW)"}
uptime   = {icon = ">", name = "uptime", color = "(BE)"}
distro   = {icon = ">", name = "distro", color = "(GN)"}
kernel   = {icon = ">", name = "kernel", color = "(MA)"}
desktop  = {icon = ">", name = "desktp", color = "(CN)"}
shell    = {icon = ">", name = "shell", color = "(RD)"}
colors   = {icon = ">", name = "colors", color = "!DT!", symbol = "#"}
```

### 🎨 Colors:
Catnip's color system uses a ColorId, witch is made up of the colors first and last letter, enclosed in characters that indicate the type of color.

**Color Types:**
- Forground Normal  -> `(#)`
- Forground Bright  -> `{#}`
- Background Normal -> `[#]`
- Background Bright -> `<#>`

>**NOTE:** `#` Should be replaced by the color id.

**Color IDs:**
- BLACK   -> `BK`
- RED     -> `RD`
- GREEN   -> `GN`
- YELLOW  -> `YW`
- BLUE    -> `BE`
- MAGENTA -> `MA`
- CYAN    -> `CN`
- WHITE   -> `WE`

So `{GN}` translates to: Forground-Bright-Green.
To set the color to Default, use `!DT!`.

### 🚩 Misc
In the `misc` section you can find 2 keys.
1. `layout`
2. `figletLogos`

#### Layout
In the layout you can define how the logo and stats will be arranged.
- Use `Inline` to place the logo and stats next to each other.
- Use `ArtOnTop` to place the logo on top of the stats.
- Use `StatsOnTop` to place the stats on top of the logo.

#### Figlet Logos
> **WARNING:** FigletLogos are not supported on windows yet.

In the `figletLogos` section you can find 3 keys:
1. `enable`
2. `color`
3. `margin`

- Set `enable` to `true`/`false` to enable or disable *figlet* generated logos.
- Use `color` to set the color the *figlet* logos should have.
- Use `margin` to define the margins of the *figlet* logos.

### 🖌️ Distro Art
To create a new DistroArt object, add a new section to the config file (replace `distroname` with the name of your distro):
```
[distroart.distroname]
```
> **NOTE:** Make sure to add the `distroart.` prefix!

Catnip's DistroArt Objects have three posible keys.
1. `margin`
2. `art`
3. `alias`

#### Margin
The `margin` key is used to define the top, left and right margins of the art. For example:

> *Art with `margin = [0, 0, 0]`*
<img src="image/no_margin.png" width="400px">

> *Art with `margin = [3, 3, 3]`*
<img src="image/margin.png" width="400px">

#### Art
The `art` key is used to define the ascii-art for your distro.
For example:
```
art = [
  "Test",
  "Test",
  "Test"
]
```

#### Alias
The `alias` key can be used to reference an already existing DistroArt object.
```
alias = "arch"
```
This is also used in the `default` DistroArt object to set which art should be displayed by default.

> **NOTE:** If you use the `alias` key, all other keys will have no effect.

---

*Example DistroArt object:*
```
[distroart.test]
margin = [3, 3 ,3]
art = [
  "Test",
  "Test",
  "Test"
]
```

<br>
<br>

# Thanks to all contributors ❤

<a href = "https://github.com/iinsertNameHere/catnip/graphs/contributors">
   <img src = "https://contrib.rocks/image?repo=iinsertNameHere/catnip">
</a>
