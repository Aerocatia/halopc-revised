# Halo CE - Restored Edition (Gearbox Halo PC)
The "Restored" tagset provides bug fixes and quality improvements for the tags and data
provided with the Halo Custom Edition Halo Editing Kit, including a complete restoration of Xbox shaders.

This project does not set out to make changes that affect the playstyle or atmosphere of the game.
Instead the goal is to fix bugs that occurred during the Halo PC porting process.

By default Xbox shader tags are used, however if the downgraded Gearbox shaders are still needed they are available in the `gearbox-shaders` branch.

## Engine support
Cache files (maps) can be compiled for the following engines from these tags, provided the below requirements are met:

- Halo PC (2003 retail)
- Halo Trial
- Halo Custom Edition

## Requirements
No engine bug workarounds are used in these tags. A mod like [Chimera](https://github.com/SnowyMouse/chimera) is required for the tags to work correctly.
The following non-stock features are needed for full support:

- Support for monochrome bitmaps
- Support for the `0.5 hud scale` bitmap flag that was added to MCC
- Support for the custom `force hud use highres scale` bitmap flag
- Support for shader_model `use xbox multipurpose channel order` flag (by default only so using the diffuse as a multi does the same thing it did on Xbox)
- Support for `shader_transparent_generic` tags

Note that due to `tool.exe` bugs there can be issues when building against resource maps made using tags other than the ones included in this tagset.
This includes the stock resource maps that come with the game.
It is recommended to either use custom resource maps with matching tags, or use a modified `tool.exe` executable that does not have such bugs.

If `tool.exe` is used to build maps from this tagset, [tool-squisher](https://github.com/Aerocatia/tool-squisher) 1.4 or higher **MUST** be run on them
to further procces new fields used by these tags. If this is not done some fields will be corrupt.
Feel free to ask [@Aerocatia](https://github.com/Aerocatia) (same name on discord) for more info.

## Differences compared to MCC
This tagset does some things differently compared to MCC that is important to know when porting custom content between games.
#### Multipurpose bitmaps are in Gearbox order
Unlike MCC, multipurpose bitmaps are kept in Gearbox order so existing Halo Custom Edition tags keep working as intended.
MCC `shader_model` tags that reference stock bitmaps will need the `use xbox multipurpose channel order` flag unchecked to work.
A copy of all multipurpose bitmaps in Xbox channel order are also provided in `extra`. If these are used, be aware of Custom Edition resource map conflicts.
#### Conflicting Xbox bitmaps were reintroduced with a different name
When Gearbox downgraded the shaders they changed some bitmaps without renaming them. One such example is `scenery\c_field_generator\bitmaps\shield mask.bitmap`.
When MCC restored the Xbox shaders these bitmaps were changed back to the Xbox version. Here we keep these tags as the gearbox version for compatibility
and use a different name for the Xbox version, such as `scenery\c_field_generator\bitmaps\shield mask generic.bitmap`.
Tags ported from MCC (or Xbox) will need to be updated to use the correct `generic` version of these bitmaps.
#### HUD scale is still 480p
MCC uses a boosted "hud canvas" of 960p (2x) with a bitmap flag to apply and extra 0.5 scale to provide 4x resolution HUD bitmaps.
Here, we keep the original 480p anchor offsets and rely solely on bitmap flags to provide 4x HUD resolution.
To port HUD tags from MCC, anchor offsets will need halved and the custom `force hud use highres scale` flag will need checked in the bitmap tags where needed.
#### HUD meters still use Gearbox channel order
Custom MCC HUD tags and meter bitmaps will need changed to use Gearbox channel order again.

## Directory Layout
### `/archive`
Stuff we do not use anymore, but useful to keep.
### `/data`
HSC script source for Halo PC.
### `/tags`
The base English Halo PC tagset with numerous bugfixes. This is a standalone tagset in which the other below variants can be optionally applied to.
### `/loc/{de,es,fr,it,jp,kr,tw}/tags`
The translated game data for Halo PC.
### `/extra/classic_480p_hud/tags`
Version of the original Xbox HUD for Halo PC with Chimera.
### `/extra/gearbox_shader_bitmaps/tags`
Tags needed to make backwards-compatible resource maps for Halo Custom Edition.
### `/extra/highres_bitmaps/tags`
Faithful custom high resolution versions of certain transparency bitmaps, like doors, control panels, and the KOTH Hill.
### `/extra/retail_demo_compatibility/tags`
Tags needed for correct netcode sync when building for Retail Halo PC or Halo Trial. Invader will apply these changes automatically, but tool.exe does not.
### `/extra/skip_update_check/tags`
Tags that change ui.map to bypass the Halo PC update check.
### `/extra/xbox_order_hud_meters/tags`
HD HUD meter bitmaps in Xbox order with HUD the interface tags set to use them.
These are incompatible with stock Halo resource maps, so take care that there are no accidental dependencies due to tool bugs.
### `/extra/xbox_order_multipurpose_bitmaps/tags`
Multipurpose bitmaps in Xbox channel order with shader_model tags that have the `xbox multipurpose channel order` flag enabled.
Note that these are incompatible with stock Halo resource maps, so take care that there are no accidental dependencies due to tool bugs.
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
