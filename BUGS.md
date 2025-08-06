# Known rendering bugs with Halo PC

This is a list of known engine bugs related to the renderer, and are not caused by incorrect tag data.

## bitmap

- The `monochrome` bitmap format is not supported.
    - No full fix, but ringworld can enable some monochrome formats.
- Bitmaps encoded as `p8 bump` are not supported.
    - No fix.

## decal

- If the `framebuffer blend function` is set to `multiply` the decal will not render.
    - Fixed with Chimera.

## fog

- atmospheric fog does not render correctly.
    - Worked around with Chimera, fixed properly with CEnshine.

## lens_flare

- render size is tied to game resolution.
    - Fixed with Chimera.

## shader_environment

- Bumpmap lighting is broken.
    - Fixed with CEnshine.
- Objects are rendered after fog (Custom Edition only).
    - Fixed with CEnshine.

## shader_model

- The render ordering seems incorrect, causing the `detail over reflection` flag to appear inverted (it is not though).
    - No fix. Chimera has a workaround, but these shaders still render incorrectly.
- Objects can sometimes render overly bright (need to find out why).
    - No fix. Setting a dark color in the animation color bounds can force it to look correct on stock Gearbox engines.

## shader_transparent_chicago, shader_transparent_chicago_extended

- This shader will fail to render if the `framebuffer blend function` is set to `multiply` while the `framebuffer fade mode` is set to `none`.
    - Fixed with Chimera.

## shader_transparent_generic

- Implemented in ringworld.

## shader_transparent_water

- Mipmaps are handled incorrectly, causing water bump effects to fail.
    - No fix.

## unit_hud_interface, weapon_hud_interface

- Meters do not fade to another color.
    - Fixed in ringworld. Can also be faked with color meter bitmaps. These only work with the Gearbox meter channel order.
- Meter state blending is imprecise, causing pixels to be enabled when they should not be (and vice versa).
    - No fix. Exact meter values should still be used, however you need 1px of padding around all meter elements, including the edge. This requirement is why the Xbox HUD can not be directly used, as the elements are too small to include the padding.
- Multitexture overlays do not blend correctly.
    - Fixed with Chimera.
