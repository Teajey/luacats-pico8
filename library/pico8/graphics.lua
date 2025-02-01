---@meta

--- ----------------------------------------------------------------------------------------------------
---     Graphics
--- ----------------------------------------------------------------------------------------------------
---
---     PICO-8 has a fixed capacity of 128 8x8 sprites, plus another 128 that overlap with the bottom
---     half of the map data ("shared data"). These 256 sprites are collectively called the sprite
---     sheet, and can be thought of as a 128x128 pixel image.
---
---     All of PICO-8's drawing operations are subject to the current draw state. The draw state
---     includes a camera position (for adding an offset to all coordinates), palette mapping  (for
---     recolouring sprites), clipping rectangle, a drawing colour, and a fill pattern.
---
---     The draw state is reset each time a program is run, or by calling @RESET().
---
---     Colour indexes:
---
---          0  black   1  dark_blue   2  dark_purple   3  dark_green
---          4  brown   5  dark_gray   6  light_gray    7  white
---          8  red     9  orange     10  yellow       11  green
---         12  blue   13  indigo     14  pink         15  peach
---
---

--- CLIP(X, Y, W, H, [CLIP_PREVIOUS])
---
---         Sets the clipping rectangle in pixels. All drawing operations will be clipped to the
---         rectangle at x, y with a width and height of w,h.
---
---         CLIP() to reset.
---
---         When CLIP_PREVIOUS is true, clip the new clipping region by the old one.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CLIP)
---
---@overload fun(x: unknown, y: unknown, w: unknown, h: unknown, clip_previous: unknown): unknown
---@param x unknown
---@param y unknown
---@param w unknown
---@param h unknown
---@return unknown
function clip(x, y, w, h) end

--- PSET(X, Y, [COL])
---
---         Sets the pixel at x, y to colour index COL (0..15).
---
---         When COL is not specified, the current draw colour is used.
---
---         FOR Y=0,127 DO
---             FOR X=0,127 DO
---                 PSET(X, Y, X*Y/8)
---             END
---         END
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PSET)
---
---@overload fun(x: unknown, y: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@return unknown
function pset(x, y) end

--- PGET(X, Y)
---
---         Returns the colour of a pixel on the screen at (X, Y).
---
---         WHILE (TRUE) DO
---             X, Y = RND(128), RND(128)
---             DX, DY = RND(4)-2, RND(4)-2
---             PSET(X, Y, PGET(DX+X, DY+Y))
---         END
---
---         When X and Y are out of bounds, PGET returns 0. A custom return value can be specified
---         with:
---
---         POKE(0x5f36, 0x10)
---         POKE(0x5f5B, NEWVAL)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PGET)
---
---@param x unknown
---@param y unknown
---@return unknown
function pget(x, y) end

--- SGET(X, Y)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SGET)
---
---@param x unknown
---@param y unknown
---@return unknown
function sget(x, y) end

--- SSET(X, Y, [COL])
---
---         Get or set the colour (COL) of a sprite sheet pixel.
---
---         When X and Y are out of bounds, SGET returns 0. A custom value can be specified with:
---
---         POKE(0x5f36, 0x10)
---         POKE(0x5f59, NEWVAL)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SSET)
---
---@overload fun(x: unknown, y: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@return unknown
function sset(x, y) end

--- FGET(N, [F])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FGET)
---
---@overload fun(n: unknown, f: unknown): unknown
---@param n unknown
---@return unknown
function fget(n) end

--- FSET(N, [F], VAL)
---
---         Get or set the value (VAL) of sprite N's flag F.
---
---         F is the flag index 0..7.
---
---         VAL is TRUE or FALSE.
---
---         The initial state of flags 0..7 are settable in the sprite editor, so can be used to create
---         custom sprite attributes. It is also possible to draw only a subset of map tiles by
---         providing a mask in @MAP().
---
---         When F is omitted, all flags are retrieved/set as a single bitfield.
---
---         FSET(2, 1 | 2 | 8)   -- SETS BITS 0,1 AND 3
---         FSET(2, 4, TRUE)     -- SETS BIT 4
---         PRINT(FGET(2))       -- 27 (1 | 2 | 8 | 16)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FSET)
---
---@overload fun(n: unknown, f: unknown, val: unknown): unknown
---@param n unknown
---@param val unknown
---@return unknown
function fset(n, val) end

--- PRINT(STR, X, Y, [COL])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PRINT)
---
---@overload fun(str: unknown, x: unknown, y: unknown, col: unknown): unknown
---@param str unknown
---@param x unknown
---@param y unknown
---@return unknown
function print(str, x, y) end

--- PRINT(STR, [COL])
---
---         Print a string STR and optionally set the draw colour to COL.
---
---         Shortcut: written on a single line, ? can be used to call print without brackets:
---
---             ?"HI"
---
---         When X, Y are not specified, a newline is automatically appended. This can be omitted by
---         ending the string with an explicit termination control character:
---
---             ?"THE QUICK BROWN FOX\0"
---
---         Additionally, when X, Y are not specified, printing text below 122 causes  the console to
---         scroll. This can be disabled during runtime with POKE(0x5f36,0x40).
---
---         PRINT returns the right-most x position that occurred while printing. This can be used to
---         find out the width of some text by printing it off-screen:
---
---             W = PRINT("HOGE", 0, -20) -- returns 16
---
---         See @{Appendix A} (P8SCII) for information about control codes and custom fonts.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PRINT)
---
---@overload fun(str: unknown, col: unknown): unknown
---@param str unknown
---@return unknown
function print(str) end

--- CURSOR(X, Y, [COL])
---
---         Set the cursor position.
---
---         If COL is specified, also set the current colour.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CURSOR)
---
---@overload fun(x: unknown, y: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@return unknown
function cursor(x, y) end

--- COLOR([COL])
---
---         Set the current colour to be used by drawing functions.
---
---         If COL is not specified, the current colour is set to 6
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#COLOR)
---
---@overload fun(col: unknown): unknown
---@return unknown
function color() end

--- CLS([COL])
---
---         Clear the screen and reset the clipping rectangle.
---
---         COL defaults to 0 (black)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CLS)
---
---@overload fun(col: unknown): unknown
---@return unknown
function cls() end

--- CAMERA([X, Y])
---
---         Set a screen offset of -x, -y for all drawing operations
---
---         CAMERA() to reset
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CAMERA)
---
---@overload fun(x: unknown, y: unknown): unknown
---@return unknown
function camera() end

--- CIRC(X, Y, R, [COL])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CIRC)
---
---@overload fun(x: unknown, y: unknown, r: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@param r unknown
---@return unknown
function circ(x, y, r) end

--- CIRCFILL(X, Y, R, [COL])
---
---         Draw a circle or filled circle at x,y with radius r
---
---         If r is negative, the circle is not drawn.
---
---         When bits 0x1800.0000 are set in COL, and @0x5F34 & 2 == 2, the circle is drawn inverted.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CIRCFILL)
---
---@overload fun(x: unknown, y: unknown, r: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@param r unknown
---@return unknown
function circfill(x, y, r) end

--- OVAL(X0, Y0, X1, Y1, [COL])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#OVAL)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@param x1 unknown
---@param y1 unknown
---@return unknown
function oval(x0, y0, x1, y1) end

--- OVALFILL(X0, Y0, X1, Y1, [COL])
---
---         Draw an oval that is symmetrical in x and y (an ellipse), with the given bounding
---         rectangle.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#OVALFILL)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@param x1 unknown
---@param y1 unknown
---@return unknown
function ovalfill(x0, y0, x1, y1) end

--- LINE(X0, Y0, [X1, Y1, [COL]])
---
---         Draw a line from (X0, Y0) to (X1, Y1)
---
---         If (X1, Y1) are not given, the end of the last drawn line is used.
---
---         LINE() with no parameters means that the next call to LINE(X1, Y1) will only set the end
---         points without drawing.
---
---         CLS()
---         LINE()
---         FOR I=0,6 DO
---             LINE(64+COS(I/6)*20, 64+SIN(I/6)*20, 8+I)
---         END
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#LINE)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown): unknown
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@return unknown
function line(x0, y0) end

--- RECT(X0, Y0, X1, Y1, [COL])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RECT)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@param x1 unknown
---@param y1 unknown
---@return unknown
function rect(x0, y0, x1, y1) end

--- RECTFILL(X0, Y0, X1, Y1, [COL])
---
---         Draw a rectangle or filled rectangle with corners at (X0, Y0), (X1, Y1).
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RECTFILL)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@param x1 unknown
---@param y1 unknown
---@return unknown
function rectfill(x0, y0, x1, y1) end

--- PAL(C0, C1, [P])
---
---         PAL() swaps colour c0 for c1 for one of three palette re-mappings (p defaults to 0):
---
---         0: Draw Palette
---
---             The draw palette re-maps colours when they are drawn. For example, an orange flower
---             sprite can be drawn as a red flower by setting the 9th palette value to 8:
---
---             PAL(9,8)     -- draw subsequent orange (colour 9) pixels as red (colour 8)
---             SPR(1,70,60) -- any orange pixels in the sprite will be drawn with red instead
---
---             Changing the draw palette does not affect anything that was already drawn to the
---             screen.
---
---         1: Display Palette
---
---             The display palette re-maps the whole screen when it is displayed at the end of a
---             frame. For example, if you boot PICO-8 and then type PAL(6,14,1), you can see all of
---             the gray (colour 6) text immediate change to pink (colour 14) even though it has
---             already been drawn. This is useful for screen-wide effects such as fading in/out.
---
---         2: Secondary Palette
---
---             Used by @FILLP() for drawing sprites. This provides a mapping from a single 4-bit
---             colour index to two 4-bit colour indexes.
---
---         PAL()  resets all palettes to system defaults (including transparency values)
---         PAL(P) resets a particular palette (0..2) to system defaults
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PAL)
---
---@overload fun(c0: unknown, c1: unknown, p: unknown): unknown
---@param c0 unknown
---@param c1 unknown
---@return unknown
function pal(c0, c1) end

--- PAL(TBL, [P])
---
---         When the first parameter of pal is a table, colours are assigned for each entry. For
---         example, to re-map colour 12 and 14 to red:
---
---             PAL({[12]=9, [14]=8})
---
---         Or to re-colour the whole screen shades of gray (including everything that is already
---         drawn):
---
---             PAL({1,1,5,5,5,6,7,13,6,7,7,6,13,6,7,1}, 1)
---
---         Because table indexes start at 1, colour 0 is given at the end in this case.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PAL)
---
---@overload fun(tbl: unknown, p: unknown): unknown
---@param tbl unknown
---@return unknown
function pal(tbl) end

--- PALT(C, [T])
---
---         Set transparency for colour index to T (boolean) Transparency is observed by @SPR(),
---         @SSPR(), @MAP() AND @TLINE()
---
---         PALT(8, TRUE) -- RED PIXELS NOT DRAWN IN SUBSEQUENT SPRITE/TLINE DRAW CALLS
---
---         PALT() resets to default: all colours opaque except colour 0
---
---         When C is the only parameter, it is treated as a bitfield used to set all 16 values. For
---         example: to set colours 0 and 1 as transparent:
---
---         PALT(0B1100000000000000)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PALT)
---
---@overload fun(c: unknown, t: unknown): unknown
---@param c unknown
---@return unknown
function palt(c) end

--- SPR(N, X, Y, [W, H], [FLIP_X], [FLIP_Y])
---
---         Draw sprite N (0..255) at position X,Y
---
---         W (width) and H (height) are 1, 1 by default and specify how many sprites wide to blit.
---
---         Colour 0 drawn as transparent by default (see @PALT())
---
---         When FLIP_X is TRUE, flip horizontally.
---
---         When FLIP_Y is TRUE, flip vertically.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SPR)
---
---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown): unknown
---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown, flip_x: unknown): unknown
---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown, flip_x: unknown, flip_y: unknown): unknown
---@param n unknown
---@param x unknown
---@param y unknown
---@return unknown
function spr(n, x, y) end

--- SSPR(SX, SY, SW, SH, DX, DY, [DW, DH], [FLIP_X], [FLIP_Y])
---
---         Stretch a rectangle of the sprite sheet (sx, sy, sw, sh) to a destination rectangle on the
---         screen (dx, dy, dw, dh). In both cases, the x and y values are coordinates (in pixels) of
---         the rectangle's top left corner, with a width of w, h.
---
---         Colour 0 drawn as transparent by default (see @PALT())
---
---         dw, dh defaults to sw, sh
---
---         When FLIP_X is TRUE, flip horizontally.
---
---         When FLIP_Y is TRUE, flip vertically.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SSPR)
---
---@overload fun(sx: unknown, sy: unknown, sw: unknown, sh: unknown, dx: unknown, dy: unknown, dw: unknown, dh: unknown): unknown
---@overload fun(sx: unknown, sy: unknown, sw: unknown, sh: unknown, dx: unknown, dy: unknown, dw: unknown, dh: unknown, flip_x: unknown): unknown
---@overload fun(sx: unknown, sy: unknown, sw: unknown, sh: unknown, dx: unknown, dy: unknown, dw: unknown, dh: unknown, flip_x: unknown, flip_y: unknown): unknown
---@param sx unknown
---@param sy unknown
---@param sw unknown
---@param sh unknown
---@param dx unknown
---@param dy unknown
---@return unknown
function sspr(sx, sy, sw, sh, dx, dy) end

--- FILLP(P)
---
---         The PICO-8 fill pattern is a 4x4 2-colour tiled pattern observed by: @CIRC() @CIRCFILL()
---         @RECT() @RECTFILL() @OVAL() @OVALFILL() @PSET() @LINE()
---
---         P is a bitfield in reading order starting from the highest bit. To calculate the value of P
---         for a desired pattern, add the bit values together:
---
---             .-----------------------.
---             |32768|16384| 8192| 4096|
---             |-----|-----|-----|-----|
---             | 2048| 1024| 512 | 256 |
---             |-----|-----|-----|-----|
---             | 128 |  64 |  32 |  16 |
---             |-----|-----|-----|-----|
---             |  8  |  4  |  2  |  1  |
---             '-----------------------'
---
---         For example, FILLP(4+8+64+128+  256+512+4096+8192) would create a checkerboard pattern.
---
---         This can be more neatly expressed in binary: FILLP(0b0011001111001100).
---
---         The default fill pattern is 0, which means a single solid colour is drawn.
---
---         To specify a second colour for the pattern, use the high bits of any colour parameter:
---
---             FILLP(0b0011010101101000)
---             CIRCFILL(64,64,20, 0x4E) -- brown and pink
---
---         Additional settings are given in bits 0b0.111:
---
---             0b0.100 Transparency
---
---                 When this bit is set, the second colour is not drawn
---
---                 -- checkboard with transparent squares
---                 FILLP(0b0011001111001100.1)
---
---             0b0.010 Apply to Sprites
---
---                 When set, the fill pattern is applied to sprites (spr, sspr, map, tline), using a
---                 colour mapping provided by the secondary palette.
---
---                 Each pixel value in the sprite (after applying the draw palette as usual) is taken
---                 to be an index into the secondary palette. Each entry in the secondary palette
---                 contains the two colours used to render the fill pattern. For example, to draw a
---                 white and red (7 and 8) checkerboard pattern for only blue pixels (colour 12) in a
---                 sprite:
---
---                 FOR I=0,15 DO PAL(I, I+I*16, 2) END  --  all other colours map to themselves
---                 PAL(12, 0x87, 2)                     --  remap colour 12 in the secondary palette
---
---                 FILLP(0b0011001111001100.01)         --  checkerboard palette, applied to sprites
---                 SPR(1, 64,64)                        --  draw the sprite
---
---             0b0.001 Apply Secondary Palette Globally
---
---                 When set, the secondary palette mapping is also applied by all draw functions that
---                 respect fill patterns (circfill, line etc). This can be useful when used in
---                 conjunction with sprite drawing functions, so that the colour index of each sprite
---                 pixel means the same thing as the colour index supplied to the drawing functions.
---
---                 FILLP(0b0011001111001100.001)
---                 PAL(12, 0x87, 2)
---                 CIRCFILL(64,64,20,12)                -- red and white checkerboard circle
---
---                 The secondary palette mapping is applied after the regular draw palette mapping. So
---                 the following would also draw a red and white checkered circle:
---
---                 PAL(3,12)
---                 CIRCFILL(64,64,20,3)
---
---         The fill pattern can also be set by setting bits in any colour parameter (for example, the
---         parameter to @COLOR(), or the last parameter to @LINE(), @RECT() etc.
---
---             POKE(0x5F34, 0x3) -- 0x1 enable fillpattern in high bits  0x2 enable inversion mode
---             CIRCFILL(64,64,20, 0x114E.ABCD) -- sets fill pattern to ABCD
---
---             When using the colour parameter to set the fill pattern, the following bits are used:
---
---             bit  0x1000.0000 this needs to be set: it means "observe bits 0xf00.ffff"
---             bit  0x0100.0000 transparency
---             bit  0x0200.0000 apply to sprites
---             bit  0x0400.0000 apply secondary palette globally
---             bit  0x0800.0000 invert the drawing operation (circfill/ovalfill/rectfill)
---             bits 0x00FF.0000 are the usual colour bits
---             bits 0x0000.FFFF are interpreted as the fill pattern
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FILLP)
---
---@param p unknown
---@return unknown
function fillp(p) end
