# Halo CE - Revised (Gearbox Halo PC)
The "Revised" tagset provides bug fixes and quality improvements for the tags and data
provided with the Halo Custom Edition Halo Editing Kit.

This project aims to provide an updated drop-in replacement for the official HEK tagset release.

This project does not set out to make changes that affect the playstyle or atmosphere of the game.
Instead the goal is to fix bugs that occurred during the Halo PC porting process.

## Difference from Halo CE "Refined"
Unlike the Refined tagset, this tagset release does not use workarounds or hacks to try and
imitate the visuals of the Xbox version on Halo PC's buggy engine, instead this release
fixes bugs with the Halo PC content while mostly keeping within the intended tag features of Halo PC (see requirements below).

This allows these tags to be a drop-in replacment for other tags that expect the original tags released by Gearbox.
As a result this tagset keeps the Halo PC `shader_transparent_chicago` shaders that stand-in for the lack of `shader_transparent_generic` support.

## Requirements
This tagset requires a mod like [Chimera](https://github.com/SnowyMouse/chimera) to work correctly.
The following non-stock features are needed for full support:

- Support for monochrome bitmaps in A8Y8 or Y8 format.
- Support for the `0.5 hud scale` flag that was added to MCC
- Support for the custom `force hud use highres scale` flag
- Support for shader_model `use xbox multipurpose channel order` flag (by default only so using the diffuse as a multi does the same thing it did on Xbox)

It is possible to build maps using this tagset that can also run on an unmodded stock game, provided all included bitmaps are only loaded from `bitmaps.map`.
In this case the client can use the original versions that do not need extra features provided by mods as long as the original `bitmaps.map` is used.

Note that due to `tool.exe` bugs there can be issues when building against resource maps made using tags other than the ones included in this tagset.
This includes the stock resource maps that come with the game.
It is recommended to either use custom resource maps with matching tags, or use a modified `tool.exe` executable that does not have such bugs.
If any version `tool.exe` is used to build maps from this tagset, please run [tool-squisher](https://github.com/Aerocatia/tool-squisher) on them to ensure data correctness.
Feel free to ask [@Aerocatia](https://github.com/Aerocatia) (same name on discord) for more info.

## Engine support
Cache files (maps) can be compiled for the following engines from these tags:

- Halo PC (2003 retail)
- Halo Trial
- Halo Custom Edition

## Directory Layout
### `/archive`
Stuff we do not use anymore, but useful to keep.
### `/data`
HSC script source for Halo PC.
### `/tags`
The base English Halo PC tagset with numerous bugfixes. This is a standalone tagset in which the other below variants can be optionally applied to.
### `/loc/{de,es,fr,it,jp,kr,tw}/tags`
The translated game data for Halo PC.
### `/extra/highres_bitmaps/tags`
Faithful custom high resolution versions of certain transparency bitmaps, like doors, control panels, and the KOTH Hill.
Also contains slightly higher resolution versions of bitmaps made by bungie that were used elsewhere (Xbox 1749, other parts of the final tagset).
### `/extra/skip_update_check/tags`
Tags that change ui.map to bypass the Halo PC update check.
### `/extra/xbox_order_multipurpose_bitmaps/tags
Multipurpose bitmaps in Xbox channel order with shader_model tags that have the `xbox multipurpose channel order` flag enabled.
Note that these are incompatible with stock Halo resource maps, so take care that there are no accidental depedencies due to tool bugs.
Many custom tags made for Halo Custom Edition expect stock tags in Gearbox order, however more modern custom tags for MCC expect them in Xbox order.
### `/extra/xbox_weapon_stats/tags`
Restore Xbox weapon stats. This will break netcode compatibility with stock maps, and should only be used in campaign or custom MP maps.

## Credits
- Aerocatia
- Holy Crust (Jesse)
- Mortis
- Snowy
- Storm Lester
- Yeonggille

## Notice
This tagset does not use any tags directly copied from the Halo MCC CE editing tools. Instead all data is derived
from the Gearbox version or custom made, and is assumed to remain under the Halo Custom Edition EULA.
