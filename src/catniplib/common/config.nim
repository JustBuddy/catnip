import "toml"
import "logging"
from "defs" import Config, STATNAMES, STATKEYS, Logo
from os import fileExists
import strformat
import strutils

# Chars that a alias can contain
const ALLOWED_NAME_CHARS = {'A' .. 'Z', 'a' .. 'z', '0' .. '9', '_'}

proc LoadConfig*(path: string): Config =
    ## Lads a config file and validates it

    ### Validate the config file ###
    if not fileExists(path):
        logError(&"{path} - file not found!")

    let tcfg = toml.parseFile(path)
    
    if not tcfg.contains("stats"):
        logError(&"{path} - missing 'stats'!")

    for statname in STATNAMES:
        if tcfg["stats"].contains(statname):
            for statkey in STATKEYS:
                if not tcfg["stats"][statname].contains(statkey):
                    logError(&"{path}:stats:{statname} - missing '{statkey}'!")
    if tcfg["stats"].contains("colors"):
        for statkey in STATKEYS & @["symbol"]:
            if not tcfg["stats"]["colors"].contains(statkey):
                logError(&"{path}:stats:colors - missing '{statkey}'!")

    if not tcfg.contains("distroart"):
        logError(&"{path} - missing 'distroart'!")
    if not tcfg.contains("misc"):
        logError(&"{path} - missing 'stats'!")
    if not tcfg["misc"].contains("layout"):
        logError(&"{path}:misc - missing 'layout'!")
    if not tcfg["misc"].contains("figletLogos"):
        logError(&"{path}:misc - missing 'figletLogos'!")
    if not tcfg["misc"]["figletLogos"].contains("enable"):
        logError(&"{path}:misc:figletLogos - missing 'enable'!")
    if not tcfg["misc"]["figletLogos"].contains("color"):
        logError(&"{path}:misc:figletLogos - missing 'color'!")
    if not tcfg["misc"]["figletLogos"].contains("font"):
        logError(&"{path}:misc:figletLogos - missing 'font'!")
    if not tcfg["misc"]["figletLogos"].contains("margin"):
        logError(&"{path}:misc:figletLogos - missing 'margin'!")
    
    ### Fill out the result object ###
    result.file = path

    for distro in tcfg["distroart"].getTable().keys:
        # Validate distroart objects
        if not tcfg["distroart"][distro].contains("margin"):
            logError(&"{path}:distroart:{distro} - missing 'margin'!")
        if not tcfg["distroart"][distro].contains("art"):
            logError(&"{path}:distroart:{distro} - missing 'art'!")
        
        # Generate Logo Objects
        var newLogo: Logo 
        var tmargin = tcfg["distroart"][distro]["margin"]
        newLogo.margin = [tmargin[0].getInt(), tmargin[1].getInt(), tmargin[2].getInt()]
        for line in tcfg["distroart"][distro]["art"].getElems:
            newLogo.art.add(line.getStr())

        # Inflate distroart table with alias if exists
        if tcfg["distroart"][distro].contains("alias"):
            let raw_alias_list = tcfg["distroart"][distro]["alias"].getStr().split(",")
            var alias_list: seq[string]
            for alias in raw_alias_list:
                alias_list.add(alias.strip())
            
            newLogo.isAlias = true

            for name in alias_list:
                if result.distroart.hasKey(name) or name == distro:
                    logError(&"{path}:distroart:{distro} - alias '{name}' is already taken!")
                
                for c in name: # Check if name is a valid alias
                    if not (c in ALLOWED_NAME_CHARS):
                        logError(&"{path}:distroart:{distro} - '{name}' is not a valid alias!")

                result.distroart[name] = newLogo # Add alias to result

        newLogo.isAlias = false

        result.distroart[distro] = newLogo # Add distroart obj to result

    if not result.distroart.contains("default"): # Validate that default alias exists
        logError(&"{path}:distroart - missing 'default'!")

    result.stats = tcfg["stats"]
    result.misc = tcfg["misc"]

proc getAllDistros*(cfg: Config): seq[string] =
    ## Function that returns all keys of distroart Table
    let distroart = cfg.distroart
    for k in distroart.keys:
        if not distroart[k].isAlias:
            result.add(k)