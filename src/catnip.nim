import "catniplib/platform/fetch"
import "catniplib/drawing/render"
from "catniplib/common/defs" import CONFIGPATH, Config
import "catniplib/common/config"
import "catniplib/common/logging"
import "catniplib/common/toml"
import os
from unicode import toLower
import strutils
import strformat
import std/wordwrap

# Debug code for execution time
when not defined release:
    import times
    let t0 = epochTime()

proc printHelp(cfg: Config) =
    echo "Usage:"
    echo "    catnip [options...]"
    echo ""
    echo "Options:"
    echo "    -h  --help                               Show help list"
    echo "    -d  --distroid             <DistroId>    Set which DistroId to use"
    echo "    -g  --grep                 <StatName>    Get the stats value"
    echo "    -c  --config               <ConfigDir>   Uses a custom location for the config file"
    echo ""
    echo "    -l  --layout               <Layout>      Overwrite layout config value [Inline,LogoOnTop,ArtOnTop]"
    echo ""
    echo "    -fe --figletLogos.enable   <on/off>      Overwrite figletLogos enable"
    echo "    -fm --figletLogos.margin   <Margin>      Overwrite figletLogos margin (Example: 1,2,3)"
    echo "    -ff --figletLogos.font     <Font>        Overwrite figletLogos font"
    echo ""
    echo "StatNames:"
    echo "    username, hostname, uptime, distro, kernel, desktop, shell"
    echo ""
    echo "DistroIds:"
    echo "    " &  cfg.getAllDistros().join(", ").wrapWords(80).replace("\n", "\n    ")
    echo ""
    quit()

# Handle commandline args
var distroid = "nil"
var statname = "nil"
var figletLogos_enabled = "nil"
var figletLogos_margin: seq[int]
var figletLogos_font = "nil"
var layout = "nil"
var cfgPath = CONFIGPATH
var help = false
var error = false

if paramCount() > 0:
    var idx = 1
    while paramCount() > (idx - 1):
        var param = paramStr(idx)

        # Config Argument
        if param == "-c" or param == "--config":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            idx += 1
            cfgPath = paramStr(idx)

        # Help Argument
        elif param == "-h" or param == "--help":
            help = true

        # DistroId Argument
        elif param == "-d" or param == "--distroid":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif distroid != "nil":
                logError(&"{param} - Can only be used once!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"{param} - Can't be used together with: -g/--grep", false)
                error = true
                idx += 1
                continue
            idx += 1
            distroid = paramStr(idx).toLower()

        # Grep Argument
        elif param == "-g" or param == "--grep":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"{param} - Can only be used once!", false)
                error = true
                idx += 1
                continue
            elif distroid != "nil":
                logError(&"{param} - Can't be used together with: -d/--distroid", false)
                error = true
                idx += 1
                continue
            idx += 1
            statname = paramStr(idx).toLower()

        # Layout Argument
        elif param == "-l" or param == "--layout":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"{param} - Can't be used together with: -g/--grep", false)
                error = true
                idx += 1
                continue
            elif layout != "nil":
                logError(&"{param} - Can only be used once!", false)
                error = true
                idx += 1
                continue
            
            idx += 1
            layout = paramStr(idx)
        
        # FigletLogos enabled Argument
        elif param == "-fe" or param == "--figletLogos.enabled":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"{param} - Can't be used together with: -g/--grep", false)
                error = true
                idx += 1
                continue
            elif figletLogos_enabled != "nil":
                logError(&"{param} - Can only be used once!", false)
                error = true
                idx += 1
                continue
            
            idx += 1
            figletLogos_enabled = paramStr(idx).toLower()
            if figletLogos_enabled != "on" and figletLogos_enabled != "off":
                logError(&"{param} - Value is not 'on' or 'off'!", false)
                error = true
                idx += 1
                continue

        # FigletLogos margin Argument
        elif param == "-fm" or param == "--figletLogos.margin":
            if paramCount() - idx < 1:
                logError(&"{param} - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"'{param}' - Can't be used together with: -g/--grep", false)
                error = true
                idx += 1
                continue
            elif figletLogos_margin.len > 0:
                logError(&"'{param}' - Can only be used once!", false)
                error = true
                idx += 1
                continue
            
            idx += 1
            let margin_list = paramStr(idx).split(",")
            if margin_list.len < 3:
                logError(&"'{param}' - Value dose not match format!", false)
                error = true
                idx += 1
                continue
            
            for idx in countup(0, 2):
                let num = margin_list[idx].strip()
                var parsed_num: int

                try:
                    parsed_num = parseInt(num)
                except:
                    logError(&"'{param}' - Value[{idx}] is not a number!", false)
                    error = true
                    break

                figletLogos_margin.add(parsed_num)


        # FigletLogos font Argument
        elif param == "-ff" or param == "--figletLogos.font":
            if paramCount() - idx < 1:
                logError(&"'{param}' - No Value was specified!", false)
                error = true
                idx += 1
                continue
            elif statname != "nil":
                logError(&"'{param}' - Can't be used together with: -g/--grep", false)
                error = true
                idx += 1
                continue
            elif figletLogos_font != "nil":
                logError(&"'{param}' - Can only be used once!", false)
                error = true
                idx += 1
                continue
            
            idx += 1
            figletLogos_font = paramStr(idx)

        # Unknown Argument
        else:
            logError(&"Unknown option '{param}'!", false)
            error = true
            idx += 1
            continue

        idx += 1

var cfg = LoadConfig(cfgPath)

# Handle argument errors and help
if help: printHelp(cfg)
if error: quit(1)
elif help: quit(0)

if statname == "nil":
    # Handle layout overwrite
    if layout != "nil":
        cfg.misc["layout"] = parseString(&"val = '{layout}'")["val"]

    # Handle figletLogos overwrites
    if figletLogos_enabled != "nil":
        let onoff = if figletLogos_enabled == "on": "true" else: "false" 
        cfg.misc["figletLogos"]["enable"] = parseString(&"val = {onoff}")["val"]
    if figletLogos_margin.len == 3:
        let fmargin = &"[{figletLogos_margin[0]},{figletLogos_margin[1]},{figletLogos_margin[2]},]"
        cfg.misc["figletLogos"]["margin"] = parseString(&"val = {fmargin}")["val"]
    if figletLogos_font != "nil":
        cfg.misc["figletLogos"]["font"] = parseString(&"val = '{figletLogos_font}'")["val"]

    # Get system info
    let fetchinfo = fetchSystemInfo(cfg, distroid)

    # Render system info
    echo ""
    Render(cfg, fetchinfo)
    echo ""

    # Debug code for execution time
    when not defined release:
        let time = (epochTime() - t0).formatFloat(format = ffDecimal, precision = 3)
        echo &"Execution finished in {time}s"

else:
    let fetchinfo = fetchSystemInfo(cfg)
    case statname:
        of "username":
            echo fetchinfo.username
        of "hostname":
            echo fetchinfo.hostname
        of "uptime":
            echo fetchinfo.uptime
        of "distro":
            echo fetchinfo.distro
        of "kernel":
            echo fetchinfo.kernel
        of "desktop":
            echo fetchinfo.desktop
        of "shell":
            echo fetchinfo.shell
        else:
            logError(&"Unknown StatName '{statname}'!")
