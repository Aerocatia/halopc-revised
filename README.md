# Halo CE - Revised (Gearbox Halo PC)
The "Revised" tagset provides bug fixes and quality improvements for the tags and data
provided with the Halo Custom Edition Halo Editing Kit.

This project aims to provide an updated drop-in replacement for the official HEK tagset release.

This project does not set out to make changes that affect the playstyle or atmosphere of the game.
Instead the goal is to fix bugs that occurred during the Halo PC porting process.

## Difference from Halo CE "Refined"
Unlike the Refined tagset, by default this asset release does not use workarounds or hacks to try and
imitate the visuals of the Xbox version on Halo PC's buggy engine, instead this release
fixes bugs with the Halo PC content while keeping within the intended tag features of Halo PC.

The benefit to this is the tags will still work as intended when run on an engine that fixes
the core engine issues, be it [MCC](https://store.steampowered.com/app/976730/Halo_The_Master_Chief_Collection/) or Halo Custom Edition with [CEnshine](https://github.com/Sledmine/censhine) and [Chimera](https://github.com/SnowyMouse/chimera) Installed.

As a result this tagset keeps the Halo PC `shader_transparent_chicago` shaders that stand-in for the lack of `shader_transparent_generic` support.

## Engine support
Cache files (maps) can be compiled for the following engines from these tags:

- Halo PC (2003 retail)
- Halo Trial
- Halo Custom Edition
- Halo: The Master Chief Collection

## Directory Layout
### `/data`
HSC script source for Halo PC.
### `/tags`
The base English Halo PC tagset with numerous bugfixes. This is a standalone tagset in which the other below variants can be optionally applied to.
### `/loc/tags{de,es,fr,it,jp,kr,tw}`
The translated game data for Halo PC.
### `/extra/tags_highres_bitmaps`
Faithful high resolution versions of certain transparency bitmaps, like doors, control panels, and the KOTH Hill.
### `/extra/tags_highres_hud`
A high resolution version of the classic Halo HUD. This version is based on content originally made by Jesse (Holy Crust).
Note that not all elements of the HUD can be high resolution due to limitations in Halo PC/Halo Custom Edition.
### `/extra/tags_mcc_compatibility`
Tags that account for the differences in how MCC interprets HUD scale. This makes it possible to build fully functioning maps for MCC using the base tagset.
This is useful for comparing differences in engine behavior. For a proper bugfixed MCC tagset [mcc-ce-revised](https://github.com/Aerocatia/mcc-ce-revised) should be used instead.
### `/extra/workarounds/tags_engine_workarounds`
These tags work around engine bugs in the Gearbox version of the game in order to force things to work closer to as intended.
Maps built with these tags will not work correctly on less broken engines like MCC or if the bugs can be fixed through engine mods.
Because of this it is not recommended to use these tags in maps that will not receive updates, and they will be removed from this repo
when the related bugs can be fixed at the engine level. The workarounds in here are similar to the ones used in the "refined" tagset.
### `/extra/workarounds/tags_highres_hud_workarounds`
Workarounds for the high resolution HUD tags. This includes 2X resolution HUD numbers (needs Chimera for waypoints to not look broken) and a workaround for the sniper ticks.

## Notice
This tagset does not use any tags directly copied from the Halo MCC CE editing tools. Instead all data is derived
from the Gearbox version, and is assumed to remain under the Halo Custom Edition EULA.
