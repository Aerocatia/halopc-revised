# Known rendering bugs with Halo PC

This is a list of known engine bugs related to the renderer, and are not caused by incorrect tag data.

## bitmap

- The `monochrome` bitmap format is not supported.
- Bitmaps encoded as `p8 bump` are not supported.

## decal

- If the `framebuffer blend function` is set to `multiply` the decal will not render.

## fog

- atmospheric fog does not render correctly.

## lens_flare

- render size is tied to game resolution.

## shader_environment

- Bumpmap lighting is broken.
- Objects are rendered after fog (Custom Edition only).

## shader_model

- The render ordering seems incorrect, causing the `detail over reflection` flag to appear inverted (it is not though).
- Objects can sometimes render overly bright (need to find out why)

## shader_transparent_chicago, shader_transparent_chicago_extended

- This shader will fail to render if the `framebuffer blend function` is set to `multiply` while the `framebuffer fade mode` is set to `none`.

## shader_transparent_generic

- This tag group is not implemented.

## shader_transparent_water

- Mipmaps are handled incorrectly, causing water bump effects to fail.

## unit_hud_interface, weapon_hud_interface

- Meters do not fade to another color.
- Meter state blending is imprecise, causing pixels to be enabled when they should not be (and vice versa).
- Multitexture overlays do not blend correctly.
