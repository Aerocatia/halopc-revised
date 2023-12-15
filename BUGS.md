# Known rendering bugs with Halo PC

This is a list of known engine bugs related to the renderer, and are not caused by incorrect tag data.

## bitmap

- The `monochrome` bitmap format is not supported.
    - No fix.
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
    - No fix. This can be worked around in tag data by setting the `framebuffer fade mode` to `fade when perpendicular` and having a second copy of the shader referenced as an extra layer that is set to `fade when parallel`.

## shader_transparent_generic

- This tag group is not implemented.

## shader_transparent_water

- Mipmaps are handled incorrectly, causing water bump effects to fail.
    - No fix.

## unit_hud_interface, weapon_hud_interface

- Meters do not fade to another color.
    - No fix. Can be faked with color meter bitmaps. These only work on the Gearbox engines.
- Meter state blending is imprecise, causing pixels to be enabled when they should not be (and vice versa).
    - No fix. Exact meter values should still be used, however you need 1px of padding around all meter elements, including the edge. This requirement is why the Xbox HUD can not be directly used, as the elements are too small to include the padding.
- Multitexture overlays do not blend correctly.
    - No fix. The sniper ticks can be made to render by changing the bitmaps and blending settings, however this configuration will not work on a Xbox-matching rendering engine.
