# Known rendering bugs with Halo PC

This is an imcomplete list of known engine bugs related to the renderer, and are not caused by incorrect tag data.

## bitmap

- The `monochrome` bitmap format is not supported.
    - Fixed with Chimera.
- Bitmaps encoded as `p8 bump` are not supported.
    - Fixed with Chimera.

## decal

- If the `framebuffer blend function` is set to `multiply` the decal will not render.
    - Fixed with Chimera.

## fog

- atmospheric fog does not render correctly.
    - Fixed with Chimera or CEnshine.

## lens_flare

- render size is tied to game resolution.
    - Fixed with Chimera.

## shader_environment

- Bumpmap lighting is broken.
    - Fixed with Chimera or CEnshine.
- Objects are rendered after fog (Custom Edition only).
    - Fixed with Chimera or CEnshine.

## shader_model

- The render ordering seems incorrect, causing the `detail over reflection` flag to appear inverted.
    - Fixed with Chimera.
- Objects can sometimes render overly bright.
    - Fixed with Chimera.

## shader_transparent_chicago, shader_transparent_chicago_extended

- This shader will fail to render if the `framebuffer blend function` is set to `multiply` while the `framebuffer fade mode` is set to `none`.
    - Fixed with Chimera.

## shader_transparent_generic

- Implemented in Chimera and ringworld.

## shader_transparent_water

- Mipmaps are handled incorrectly, causing water bump effects to fail.
    - Fixed with Chimera or Ringworld.

## unit_hud_interface, weapon_hud_interface

- Meters do not fade to another color.
    - Fixed in Chimera or Ringworld.
- Meter state blending is imprecise, causing pixels to be enabled when they should not be (and vice versa).
    - Fixed with Chimera.
- Multitexture overlays do not blend correctly.
    - Fixed with Chimera.
