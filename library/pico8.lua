---@meta

--- ====================================================================================================
---     API Reference
--- ====================================================================================================
---
---     PICO-8 is built on the Lua programming language, but does not include the Lua standard library.
---     Instead, a small api is offered in keeping with PICO-8's minimal design and limited screen
---     space. For an example program that uses most of the api functions, see /DEMOS/API.P8
---
---     Functions are written here as:
---
---     FUNCTION_NAME(PARAMETER, [OPTIONAL_PARAMETER])
---
---     Note that PICO-8 does not have upper or lower case characters -- if you are editing a .p8 or
---     .lua file directly, function names should all be in lower case.

---     Called once per update at 30fps.
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _update() end

---     Called once per visible frame.
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _draw() end

---     Called once on program startup.
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _init() end

---     When _UPDATE60() Is defined instead of _UPDATE(), PICO-8 will run in 60fps mode:
---
---     - both _UPDATE60() and _DRAW() are called at 60fps
---     - half the PICO-8 CPU is available per frame before dropping down to 30fps
---
---     Note that not all host machines are capable of running at 60fps. Older machines, and / or web
---     versions might also request PICO-8 to run at 30 fps (or 15 fps), even when the PICO-8 CPU is
---     not over capacity. In this case, multiple _UPDATE60 calls are made for every _DRAW call in the
---     same way.
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#_UPDATE60)
function _update60() end
