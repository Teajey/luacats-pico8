--- LOAD(FILENAME, [BREADCRUMB], [PARAM_STR])
---
---@overload fun(filename: unknown, breadcrumb: unknown): unknown
---@overload fun(filename: unknown, breadcrumb: unknown, param_str: unknown): unknown
---@param filename unknown
---@return unknown
function load(filename) end

--- SAVE(FILENAME)
---
---         Load or save a cartridge
---
---         When loading from a running cartridge, the loaded cartridge is immediately run with
---         parameter string PARAM_STR (accessible with STAT(6)), and a menu item is inserted and named
---         BREADCRUMB, that returns the user to the previous cartridge.
---
---         Filenames that start with '#' are taken to be a BBS cart id, that is immediately downloaded
---         and run:
---
---         > LOAD("#MYGAME_LEVEL2", "BACK TO MAP", "LIVES="..LIVES)
---
---         If the id is the cart's parent post, or a revision number is not specified, then the latest
---         version is fetched. BBS carts can be loaded from other BBS carts or local carts, but not
---         from  exported carts.
---
---@param filename unknown
---@return unknown
function save(filename) end

--- LS([DIRECTORY])
---
---         List .p8 and .p8.png files in given directory (folder), relative to the current directory.
---         Items that are directories end in a slash (e.g. "foo/").
---
---         When called from a running cartridge, LS can only be used locally and returns a table of
---         the results. When called from a BBS cart, LS returns nil.
---
---         Directories can only resolve inside of PICO-8's virtual drive; LS("..") from the root
---         directory will resolve to the root directory.
---
---@overload fun(directory: unknown): unknown
---@return unknown
function ls() end

--- RUN([PARAM_STR])
---
---         Run from the start of the program.
---
---         RUN() Can be called from inside a running program to reset.
---
---         When PARAM_STR is supplied, it can be accessed during runtime with STAT(6)
---
---@overload fun(param_str: unknown): unknown
---@return unknown
function run() end

--- STOP([MESSAGE])
---
---         Stop the cart and optionally print a message.
---
---@overload fun(message: unknown): unknown
---@return unknown
function stop() end

--- ASSERT(CONDITION, [MESSAGE])
---
---         If CONDITION is false, stop the program and print MESSAGE if it is given. This can be
---         useful for debugging cartridges, by ASSERT()'ing that things that you expect to be true are
---         indeed true.
---
---         ASSERT(ADDR >= 0 AND ADDR <= 0x7FFF, "OUT OF RANGE")
---         POKE(ADDR, 42) -- THE MEMORY ADDRESS IS OK, FOR SURE!
---
---@overload fun(condition: unknown, message: unknown): unknown
---@param condition unknown
---@return unknown
function assert(condition) end

--- RESET()
---
---         Reset the values in RAM from 0x5f00..0x5f7f to their default values.  This includes the
---         palette, camera position, clipping and fill pattern. If you get lost at the command prompt
---         because the draw state makes viewing text  impossible, try typing RESET! It can also be
---         called from a running program.
---
---@return unknown
function reset() end

--- INFO()
---
---         Print out some information about the cartridge: Code size, tokens, compressed size
---
---         Also displayed:
---
---             UNSAVED CHANGES   When the cartridge in memory differs to the one on disk
---             EXTERNAL CHANGES  When the cartridge on disk has changed since it was loaded
---                 (e.g. by editing the program using a separate text editor)
---
---@return unknown
function info() end

--- FLIP()
---
---         Flip the back buffer to screen and wait for next frame. This call is not needed when there
---         is a @_DRAW() or @_UPDATE() callback defined, as the flip is performed automatically. But
---         when using a custom main loop, a call to FLIP is normally needed:
---
---@return unknown
function flip() end

--- PRINTH(STR, [FILENAME], [OVERWRITE], [SAVE_TO_DESKTOP])
---
---         Print a string to the host operating system's console for debugging.
---
---         If filename is set, append the string to a file on the host operating system (in the
---         current directory by default -- use FOLDER to view).
---
---         Setting OVERWRITE to true causes that file to be overwritten rather than appended.
---
---         Setting SAVE_TO_DESKTOP to true saves to the desktop instead of the current path.
---
---         Use a filename of "@clip" to write to the host's clipboard.
---
---         Use stat(4) to read the clipboard, but the contents of the clipboard are only available
---         after pressing CTRL-V during runtime (for security).
---
---@overload fun(str: unknown, filename: unknown): unknown
---@overload fun(str: unknown, filename: unknown, overwrite: unknown): unknown
---@overload fun(str: unknown, filename: unknown, overwrite: unknown, save_to_desktop: unknown): unknown
---@param str unknown
---@return unknown
function printh(str) end

--- TIME()
---
---@return unknown
function time() end

--- T()
---
---         Returns the number of seconds elapsed since the cartridge was run.
---
---         This is not the real-world time, but is calculated by counting the number of times
---
---@return unknown
function t() end

--- STAT(X)
---
---         Get system status where X is:
---
---         0  Memory usage (0..2048)
---         1  CPU used since last flip (1.0 == 100% CPU)
---         4  Clipboard contents (after user has pressed CTRL-V)
---         6  Parameter string
---         7  Current framerate
---
---         46..49  Index of currently playing SFX on channels 0..3
---         50..53  Note number (0..31) on channel 0..3
---         54      Currently playing pattern index
---         55      Total patterns played
---         56      Ticks played on current pattern
---         57      (Boolean) TRUE when music is playing
---
---         80..85  UTC time: year, month, day, hour, minute, second
---         90..95  Local time
---
---         100     Current breadcrumb label, or nil
---         110     Returns true when in frame-by-frame mode
---
---     Audio values 16..26 are the legacy version of audio state queries 46..56. They only report on
---     the current state of the audio mixer, which changes only ~20 times a second (depending on the
---     host sound driver and other factors). 46..56 instead stores a history of mixer state at each
---     tick to give a higher resolution estimate of the currently audible state.
---
---@param x unknown
---@return unknown
function stat(x) end

--- EXTCMD(CMD_STR, [P1, P2])
---
---         Special system command, where CMD_STR is a string:
---
---             "pause"         request the pause menu be opened
---             "reset"         request a cart reset
---             "go_back"       return to the previous cart if there is one
---             "label"         set cart label
---             "screen"        save a screenshot
---             "rec"           set video start point
---             "rec_frames"    set video start point in frames mode
---             "video"         save a .gif to desktop
---             "audio_rec"     start recording audio
---             "audio_end"     save recorded audio to desktop (no supported from web)
---             "shutdown"      quit cartridge (from exported binary)
---             "folder"        open current working folder on the host operating system
---             "set_filename"  set the filename for screenshots / gifs / audio recordings
---             "set_title"     set the host window title
---
---         Some commands have optional number parameters:
---
---             "video" and "screen": P1: an integer scaling factor that overrides the system setting.
---             P2: when > 0, save to the current folder instead of to desktop
---
---             "audio_end" P1: when > 0, save to the current folder instead of to desktop
---
---@overload fun(cmd_str: unknown, p1: unknown, p2: unknown): unknown
---@param cmd_str unknown
---@return unknown
function extcmd(cmd_str) end

--- CLIP(X, Y, W, H, [CLIP_PREVIOUS])
---
---         Sets the clipping rectangle in pixels. All drawing operations will be clipped to the
---         rectangle at x, y with a width and height of w,h.
---
---         CLIP() to reset.
---
---         When CLIP_PREVIOUS is true, clip the new clipping region by the old one.
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
---@param x unknown
---@param y unknown
---@return unknown
function pget(x, y) end

--- SGET(X, Y)
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
---@overload fun(x: unknown, y: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@return unknown
function sset(x, y) end

--- FGET(N, [F])
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
---@overload fun(n: unknown, f: unknown, val: unknown): unknown
---@param n unknown
---@param val unknown
---@return unknown
function fset(n, val) end

--- PRINT(STR, X, Y, [COL])
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
---@overload fun(col: unknown): unknown
---@return unknown
function color() end

--- CLS([COL])
---
---         Clear the screen and reset the clipping rectangle.
---
---         COL defaults to 0 (black)
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
---@overload fun(x: unknown, y: unknown): unknown
---@return unknown
function camera() end

--- CIRC(X, Y, R, [COL])
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
---@overload fun(x: unknown, y: unknown, r: unknown, col: unknown): unknown
---@param x unknown
---@param y unknown
---@param r unknown
---@return unknown
function circfill(x, y, r) end

--- OVAL(X0, Y0, X1, Y1, [COL])
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
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown): unknown
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@return unknown
function line(x0, y0) end

--- RECT(X0, Y0, X1, Y1, [COL])
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
---@param p unknown
---@return unknown
function fillp(p) end

--- ADD(TBL, VAL, [INDEX])
---
---         Add value VAL to the end of table TBL. Equivalent to:
---
---         TBL[#TBL + 1] = VAL
---
---         If index is given then the element is inserted at that position:
---
---             FOO={}        -- CREATE EMPTY TABLE
---             ADD(FOO, 11)
---             ADD(FOO, 22)
---             PRINT(FOO[2]) -- 22
---
---@overload fun(tbl: unknown, val: unknown, index: unknown): unknown
---@param tbl unknown
---@param val unknown
---@return unknown
function add(tbl, val) end

--- DEL(TBL, VAL)
---
---         Delete the first instance of value VAL in table TBL. The remaining entries are shifted left
---         one index to avoid holes.
---
---         Note that VAL is the value of the item to be deleted, not the index into the table. (To
---         remove an item at a particular index, use DELI instead). DEL returns the deleted item, or
---         returns no value when nothing was deleted.
---
---             A={1,10,2,11,3,12}
---             FOR ITEM IN ALL(A) DO
---                 IF (ITEM < 10) THEN DEL(A, ITEM) END
---             END
---             FOREACH(A, PRINT) -- 10,11,12
---             PRINT(A[3])       -- 12
---
---@param tbl unknown
---@param val unknown
---@return unknown
function del(tbl, val) end

--- DELI(TBL, [I])
---
---         Like @DEL(), but remove the item from table TBL at index I When I is not given, the last
---         element of the table is removed and returned.
---
---@overload fun(tbl: unknown, i: unknown): unknown
---@param tbl unknown
---@return unknown
function deli(tbl) end

--- COUNT(TBL, [VAL])
---
---         Returns the length of table t (same as #TBL) When VAL is given, returns the number of
---         instances of VAL in that table.
---
---@overload fun(tbl: unknown, val: unknown): unknown
---@param tbl unknown
---@return unknown
function count(tbl) end

--- ALL(TBL)
---
---         Used in FOR loops to iterate over all items in a table (that have a 1-based integer index),
---         in the order they were added.
---
---             T = {11,12,13}
---             ADD(T,14)
---             ADD(T,"HI")
---             FOR V IN ALL(T) DO PRINT(V) END -- 11 12 13 14 HI
---             PRINT(#T) -- 5
---
---@param tbl unknown
---@return unknown
function all(tbl) end

--- FOREACH(TBL, FUNC)
---
---         For each item in table TBL, call function FUNC with the item as a single parameter.
---
---             > FOREACH({1,2,3}, PRINT)
---
---@param tbl unknown
---@param func unknown
---@return unknown
function foreach(tbl, func) end

--- PAIRS(TBL)
---
---         Used in FOR loops to iterate over table TBL, providing both the key and value for each
---         item. Unlike @ALL(), PAIRS() iterates over every item regardless of indexing scheme. Order
---         is not guaranteed.
---
---             T = {["HELLO"]=3, [10]="BLAH"}
---             T.BLUE = 5;
---             FOR K,V IN PAIRS(T) DO
---                 PRINT("K: "..K.."  V:"..V)
---             END
---
---         Output:
---
---             K: 10  v:BLAH
---             K: HELLO  v:3
---             K: BLUE  v:5
---
---@param tbl unknown
---@return unknown
function pairs(tbl) end

--- BTN([B], [PL])
---
---         Get button B state for player PL (default 0)
---
---         B: 0..5: left right up down button_o button_x<br> PL: player index 0..7
---
---         Instead of using a number for B, it is also possible to use a button glyph. (In the coded
---         editor, use Shift-L R U D O X)
---
---         If no parameters supplied, returns a bitfield of all 12 button states for player 0 & 1 //
---         P0: bits 0..5  P1: bits 8..13
---
---         Default keyboard mappings to player buttons:
---
---             player 0: [DPAD]: cursors, [O]: Z C N   [X]: X V M
---             player 1: [DPAD]: SFED,    [O]: LSHIFT  [X]: TAB W  Q A
---
---         Although PICO-8 accepts all button combinations, note that it is generally impossible to
---         press both LEFT and RIGHT at the same time on a physical game controller. On some
---         controllers, UP + LEFT/RIGHT is also awkward if [X] or [O] could be used instead of UP
---         (e.g. to jump / accelerate).
---
---@overload fun(b: unknown): unknown
---@overload fun(b: unknown, pl: unknown): unknown
---@return unknown
function btn() end

--- BTNP(B, [PL])
---
---         BTNP is short for "Button Pressed"; Instead of being true when a button is held down,  BTNP
---         returns true when a button is down AND it was not down the last frame. It also repeats
---         after 15 frames, returning true every 4 frames after that (at 30fps -- double that at
---         60fps). This can be used for things like menu navigation or grid-wise player  movement.
---
---         The state that BTNP reads is reset at the start of each call to @_UPDATE or @_UPDATE60, so
---         it is preferable to use BTNP from inside one of those functions.
---
---         Custom delays (in frames @ 30fps) can be set by poking the following memory addresses:
---
---         POKE(0X5F5C, DELAY) -- SET THE INITIAL DELAY BEFORE REPEATING. 255 MEANS NEVER REPEAT.
---         POKE(0X5F5D, DELAY) -- SET THE REPEATING DELAY.
---
---         In both cases, 0 can be used for the default behaviour (delays 15 and 4)
---
---@overload fun(b: unknown, pl: unknown): unknown
---@param b unknown
---@return unknown
function btnp(b) end

--- SFX(N, [CHANNEL], [OFFSET], [LENGTH])
---
---         Play sfx N (0..63) on CHANNEL (0..3) from note OFFSET (0..31 in notes) for LENGTH notes.
---
---         Using negative CHANNEL values have special meanings:
---
---         CHANNEL -1: (default) to automatically choose a channel that is not being used
---         CHANNEL -2: to stop the given sound from playing on any channel
---
---         N can be a command for the given CHANNEL (or all channels when CHANNEL < 0):
---
---         N -1: to stop sound on that channel
---         N -2: to release sound on that channel from looping
---
---         SFX(3)    --  PLAY SFX 3
---         SFX(3,2)  --  PLAY SFX 3 ON CHANNEL 2
---         SFX(3,-2) --  STOP SFX 3 FROM PLAYING ON ANY CHANNEL
---         SFX(-1,2) --  STOP WHATEVER IS PLAYING ON CHANNEL 2
---         SFX(-2,2) --  RELEASE LOOPING ON CHANNEL 2
---         SFX(-1)   --  STOP ALL SOUNDS ON ALL CHANNELS
---         SFX(-2)   --  RELEASE LOOPING ON ALL CHANNELS
---
---@overload fun(n: unknown, channel: unknown): unknown
---@overload fun(n: unknown, channel: unknown, offset: unknown): unknown
---@overload fun(n: unknown, channel: unknown, offset: unknown, length: unknown): unknown
---@param n unknown
---@return unknown
function sfx(n) end

--- MUSIC(N, [FADE_LEN], [CHANNEL_MASK])
---
---         Play music starting from pattern N (0..63)
---         N -1 to stop music
---
---         FADE_LEN is in ms (default: 0). So to fade pattern 0 in over 1 second:
---
---         MUSIC(0, 1000)
---
---         CHANNEL_MASK specifies which channels to reserve for music only. For example, to play only
---         on channels 0..2:
---
---         MUSIC(0, NIL, 7) -- 1 | 2 | 4
---
---         Reserved channels can still be used to play sound effects on, but only when that channel
---         index is explicitly requested by @SFX().
---
---@overload fun(n: unknown, fade_len: unknown): unknown
---@overload fun(n: unknown, fade_len: unknown, channel_mask: unknown): unknown
---@param n unknown
---@return unknown
function music(n) end

--- MGET(X, Y)
---
---@param x unknown
---@param y unknown
---@return unknown
function mget(x, y) end

--- MSET(X, Y, VAL)
---
---         Get or set map value (VAL) at X,Y
---
---         When X and Y are out of bounds, MGET returns 0, or a custom return value that can be
---         specified with:
---
---         POKE(0x5f36, 0x10)
---         POKE(0x5f5a, NEWVAL)
---
---@param x unknown
---@param y unknown
---@param val unknown
---@return unknown
function mset(x, y, val) end

--- MAP(TILE_X, TILE_Y, [SX, SY], [TILE_W, TILE_H], [LAYERS])
---
---         Draw section of map (starting from TILE_X, TILE_Y) at screen position SX, SY (pixels).
---
---         To draw a 4x2 blocks of tiles starting from 0,0 in the map, to the screen at 20,20:
---
---         MAP(0, 0, 20, 20, 4, 2)
---
---         TILE_W and TILE_H default to the entire map (including shared space when applicable).
---
---         MAP() is often used in conjunction with CAMERA(). To draw the map so that a player object
---         (at PL.X in PL.Y in pixels) is centered:
---
---         CAMERA(PL.X - 64, PL.Y - 64)
---         MAP()
---
---         LAYERS is a bitfield. When given, only sprites with matching sprite flags are drawn. For
---         example, when LAYERS is 0x5, only sprites with flag 0 and 2 are drawn.
---
---         Sprite 0 is taken to mean "empty" and is not drawn. To disable this behaviour, use:
---         POKE(0x5F36, 0x8)
---
---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown): unknown
---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown, tile_w: unknown, tile_h: unknown): unknown
---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown, tile_w: unknown, tile_h: unknown, layers: unknown): unknown
---@param tile_x unknown
---@param tile_y unknown
---@return unknown
function map(tile_x, tile_y) end

--- TLINE(X0, Y0, X1, Y1, MX, MY, [MDX, MDY], [LAYERS])
---
---         Draw a textured line from (X0,Y0) to (X1,Y1), sampling colour values from the map. When
---         LAYERS is specified, only sprites with matching flags are drawn (similar to MAP())
---
---         MX, MY are map coordinates to sample from, given in tiles. Colour values are sampled from
---         the 8x8 sprite present at each map tile. For example:
---
---             2.0, 1.0  means the top left corner of the sprite at position 2,1 on the map
---             2.5, 1.5  means pixel (4,4) of the same sprite
---
---         MDX, MDY are deltas added to mx, my after each pixel is drawn. (Defaults to 0.125, 0)
---
---         The map coordinates (MX, MY) are masked by values calculated by subtracting 0x0.0001 from
---         the values at address 0x5F38 and 0x5F39. In simpler terms, this means you can loop a
---         section of the map by poking the width and height you want to loop within, as  long as they
---         are powers of 2 (2,4,8,16..)
---
---         For example, to loop every 8 tiles horizontally, and every 4 tiles vertically:
---
---             POKE(0x5F38, 8)
---             POKE(0x5F39, 4)
---             TLINE(...)
---
---         The default values (0,0) gives a masks of 0xff.ffff, which means that the samples will loop
---         every 256 tiles.
---
---         An offset to sample from (also in tiles) can also be specified at addresses 0x5f3a, 0x5f3b:
---
---             POKE(0x5F3A, OFFSET_X)
---             POKE(0x5F3B, OFFSET_Y)
---
---         Sprite 0 is taken to mean "empty" and not drawn. To disable this behaviour, use:
---         POKE(0x5F36, 0x8)
---
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, mx: unknown, my: unknown, mdx: unknown, mdy: unknown): unknown
---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, mx: unknown, my: unknown, mdx: unknown, mdy: unknown, layers: unknown): unknown
---@param x0 unknown
---@param y0 unknown
---@param x1 unknown
---@param y1 unknown
---@param mx unknown
---@param my unknown
---@return unknown
function tline(x0, y0, x1, y1, mx, my) end

--- PEEK(ADDR, [N])
---
---         Read a byte from an address in base ram. If N is specified, PEEK() returns that number of
---         results (max: 8192). For example, to read the first 2 bytes of video memory:
---
---             A, B = PEEK(0x6000, 2)
---
---@overload fun(addr: unknown, n: unknown): unknown
---@param addr unknown
---@return unknown
function peek(addr) end

--- POKE(ADDR, VAL1, VAL2, ...)
---
---         Write one or more bytes to an address in base ram. If more than one parameter is provided,
---         they are written sequentially (max: 8192).
---
---@param addr unknown
---@param val1 unknown
---@param val2 unknown
---@return unknown
function poke(addr, val1, val2, ...) end

--- MEMCPY(DEST_ADDR, SOURCE_ADDR, LEN)
---
---         Copy LEN bytes of base ram from source to dest. Sections can be overlapping
---
---@param dest_addr unknown
---@param source_addr unknown
---@param len unknown
---@return unknown
function memcpy(dest_addr, source_addr, len) end

--- RELOAD(DEST_ADDR, SOURCE_ADDR, LEN, [FILENAME])
---
---         Same as MEMCPY, but copies from cart rom.
---
---         The code section ( >= 0x4300) is protected and can not be read.
---
---         If filename specified, load data from a separate cartridge. In this case, the cartridge
---         must be local (BBS carts can not be read in this way).
---
---@overload fun(dest_addr: unknown, source_addr: unknown, len: unknown, filename: unknown): unknown
---@param dest_addr unknown
---@param source_addr unknown
---@param len unknown
---@return unknown
function reload(dest_addr, source_addr, len) end

--- CSTORE(DEST_ADDR, SOURCE_ADDR, LEN, [FILENAME])
---
---         Same as memcpy, but copies from base ram to cart rom.
---
---         CSTORE() is equivalent to CSTORE(0, 0, 0x4300)
---
---         The code section ( >= 0x4300) is protected and can not be written to.
---
---         If FILENAME is specified, the data is written directly to that cartridge on disk. Up to 64
---         cartridges can be written in one session. See @{Cartridge Data} for more information.
---
---@overload fun(dest_addr: unknown, source_addr: unknown, len: unknown, filename: unknown): unknown
---@param dest_addr unknown
---@param source_addr unknown
---@param len unknown
---@return unknown
function cstore(dest_addr, source_addr, len) end

--- MEMSET(DEST_ADDR, VAL, LEN)
---
---         Write the 8-bit value VAL into memory starting at DEST_ADDR, for LEN bytes.
---
---         For example, to fill half of video memory with 0xC8:
---
---         > MEMSET(0x6000, 0xC8, 0x1000)
---
---@param dest_addr unknown
---@param val unknown
---@param len unknown
---@return unknown
function memset(dest_addr, val, len) end

--- MAX(X, Y)
---
---@param x unknown
---@param y unknown
---@return unknown
function max(x, y) end

--- MIN(X, Y)
---
---@param x unknown
---@param y unknown
---@return unknown
function min(x, y) end

--- MID(X, Y, Z)
---
---         Returns the maximum, minimum, or middle value of parameters
---
---         > ?MID(7,5,10) -- 7
---
---@param x unknown
---@param y unknown
---@param z unknown
---@return unknown
function mid(x, y, z) end

--- FLR(X)
---
---         > ?FLR ( 4.1) -->  4
---         > ?FLR (-2.3) --> -3
---
---@param x unknown
---@return unknown
function flr(x) end

--- CEIL(X)
---
---         Returns the closest integer that is equal to or below x
---
---         > ?CEIL( 4.1) -->  5
---         > ?CEIL(-2.3) --> -2
---
---@param x unknown
---@return unknown
function ceil(x) end

--- COS(X)
---
---@param x unknown
---@return unknown
function cos(x) end

--- SIN(X)
---
---         Returns the cosine or sine of x, where 1.0 means a full turn. For example, to animate a
---         dial that turns once every second:
---
---         FUNCTION _DRAW()
---             CLS()
---             CIRC(64, 64, 20, 7)
---             X = 64 + COS(T()) * 20
---             Y = 64 + SIN(T()) * 20
---             LINE(64, 64, X, Y)
---         END
---
---         PICO-8's SIN() returns an inverted result to suit screenspace (where Y means "DOWN", as
---         opposed  to mathematical diagrams where Y typically means "UP").
---
---         > SIN(0.25) -- RETURNS -1
---
---         To get conventional radian-based trig functions without the y inversion,  paste the
---         following snippet near the start of your program:
---
---         P8COS = COS FUNCTION COS(ANGLE) RETURN P8COS(ANGLE/(3.1415*2)) END
---         P8SIN = SIN FUNCTION SIN(ANGLE) RETURN -P8SIN(ANGLE/(3.1415*2)) END
---
---@param x unknown
---@return unknown
function sin(x) end

--- SQRT(X)
---
---         Return the square root of x
---
---@param x unknown
---@return unknown
function sqrt(x) end

--- ABS(X)
---
---         Returns the absolute (positive) value of x
---
---@param x unknown
---@return unknown
function abs(x) end

--- RND(X)
---
---         Returns a random number n, where 0 <= n < x
---
---         If you want an integer, use flr(rnd(x)). If x is an array-style table, return a random
---         element between table[1] and table[#table].
---
---@param x unknown
---@return unknown
function rnd(x) end

--- SRAND(X)
---
---         Sets the random number seed. The seed is automatically randomized on cart startup.
---
---         FUNCTION _DRAW()
---             CLS()
---             SRAND(33)
---             FOR I=1,100 DO
---                 PSET(RND(128),RND(128),7)
---             END
---         END
---
---@param x unknown
---@return unknown
function srand(x) end

--- MENUITEM(INDEX, [LABEL], [CALLBACK])
---
---         Add or update an item to the pause menu.
---
---         INDEX should be 1..5 and determines the order each menu item is displayed.
---
---         LABEL should be a string up to 16 characters long
---
---         CALLBACK is a function called when the item is selected by the user. If the callback
---         returns true, the pause menu remains open.
---
---         When no label or function is supplied, the menu item is removed.
---
---         MENUITEM(1, "RESTART PUZZLE",
---             FUNCTION() RESET_PUZZLE() SFX(10) END
---         )
---
---         The callback takes a single argument that is a bitfield of L,R,X button presses.
---
---         MENUITEM(1, "FOO",
---             FUNCTION(B) IF (B&1 > 0) THEN PRINTH("LEFT WAS PRESSED") END END
---         )
---
---         To filter button presses that are able to trigger the callback, a mask can be  supplied in
---         bits 0xff00 of INDEX. For example, to disable L, R for a particular menu item, set bits
---         0x300 in the index:
---
---         MENUITEM(2 | 0x300, "RESET PROGRESS",
---             FUNCTION() DSET(0,0) END
---         )
---
---         Menu items can be updated, added or removed from within callbacks:
---
---         MENUITEM(3, "SCREENSHAKE: OFF",
---             FUNCTION()
---                 SCREENSHAKE = NOT SCREENSHAKE
---                 MENUITEM(NIL, "SCREENSHAKE: "..(SCREENSHAKE AND "ON" OR "OFF"))
---                 RETURN TRUE -- DON'T CLOSE
---             END
---         )
---
---@overload fun(index: unknown, label: unknown): unknown
---@overload fun(index: unknown, label: unknown, callback: unknown): unknown
---@param index unknown
---@return unknown
function menuitem(index) end

--- TOSTR(VAL, [FORMAT_FLAGS])
---
---         Convert VAL to a string.
---
---         FORMAT_FLAGS is a bitfield:
---
---             0x1: Write the raw hexadecimal value of numbers, functions or tables.
---             0x2: Write VAL as a signed 32-bit integer by shifting it left by 16 bits.
---
---         TOSTR(NIL) returns "[nil]"
---
---         TOSTR() returns ""
---
---         TOSTR(17)       -- "17"
---         TOSTR(17,0x1)   -- "0x0011.0000"
---         TOSTR(17,0x3)   -- "0x00110000"
---         TOSTR(17,0x2)   -- "1114112"
---
---@overload fun(val: unknown, format_flags: unknown): unknown
---@param val unknown
---@return unknown
function tostr(val) end

--- TONUM(VAL, [FORMAT_FLAGS])
---
---         Converts VAL to a number.
---
---         TONUM("17.5")  -- 17.5
---         TONUM(17.5)    -- 17.5
---         TONUM("HOGE")  -- NO RETURN VALUE
---
---         FORMAT_FLAGS is a bitfield:
---
---             0x1: Read the string as written in (unsigned, integer) hexadecimal without the "0x" prefix
---                  Non-hexadecimal characters are taken to be '0'.
---             0x2: Read the string as a signed 32-bit integer, and shift right 16 bits.
---             0x4: When VAL can not be converted to a number, return 0
---
---         TONUM("FF",       0x1)  -- 255
---         TONUM("1114112",  0x2)  -- 17
---         TONUM("1234abcd", 0x3)  -- 0x1234.abcd
---
---@overload fun(val: unknown, format_flags: unknown): unknown
---@param val unknown
---@return unknown
function tonum(val) end

--- CHR(VAL0, VAL1, ...)
---
---         Convert one or more ordinal character codes to a string.
---
---         CHR(64)                    -- "@"
---         CHR(104,101,108,108,111)   -- "hello"
---
---@param val0 unknown
---@param val1 unknown
---@return unknown
function chr(val0, val1, ...) end

--- ORD(STR, [INDEX], [NUM_RESULTS])
---
---         Convert one or more characters from string STR to their ordinal (0..255) character codes.
---
---         Use the INDEX parameter to specify which character in the string to use. When INDEX is out
---         of range or str is not a string, ORD returns nil.
---
---         When NUM_RESULTS is given, ORD returns multiple values starting from INDEX.
---
---         ORD("@")         -- 64
---         ORD("123",2)     -- 50 (THE SECOND CHARACTER: "2")
---         ORD("123",2,3)   -- 50,51,52
---
---@overload fun(str: unknown, index: unknown): unknown
---@overload fun(str: unknown, index: unknown, num_results: unknown): unknown
---@param str unknown
---@return unknown
function ord(str) end

--- SUB(STR, POS0, [POS1])
---
---         Grab a substring from string str, from pos0 up to and including pos1. When POS1 is not
---         specified, the remainder of the string is returned. When POS1 is specified, but not a
---         number, a single character at POS0 is returned.
---
---         S = "THE QUICK BROWN FOX"
---         PRINT(SUB(S,5,9))    --> "QUICK"
---         PRINT(SUB(S,5))      --> "QUICK BROWN FOX"
---         PRINT(SUB(S,5,TRUE)) --> "Q"
---
---@overload fun(str: unknown, pos0: unknown, pos1: unknown): unknown
---@param str unknown
---@param pos0 unknown
---@return unknown
function sub(str, pos0) end

--- SPLIT(STR, [SEPARATOR], [CONVERT_NUMBERS])
---
---         Split a string into a table of elements delimited by the given separator (defaults to ",").
---         When separator is a number n, the string is split into n-character groups. When
---         convert_numbers is true, numerical tokens are stored as numbers (defaults to true). Empty
---         elements are stored as empty strings.
---
---         SPLIT("1,2,3")               -- {1,2,3}
---         SPLIT("ONE:TWO:3",":",FALSE) -- {"ONE","TWO","3"}
---         SPLIT("1,,2,")               -- {1,"",2,""}
---
---@overload fun(str: unknown, separator: unknown): unknown
---@overload fun(str: unknown, separator: unknown, convert_numbers: unknown): unknown
---@param str unknown
---@return unknown
function split(str) end

--- TYPE(VAL)
---
---         Returns the type of val as a string.
---
---         > PRINT(TYPE(3))
---         NUMBER
---         > PRINT(TYPE("3"))
---         STRING
---
---@param val unknown
---@return unknown
function type(val) end

--- CARTDATA(ID)
---
---         Opens a permanent data storage slot indexed by ID that can be used to store and retrieve up
---         to 256 bytes (64 numbers) worth of data using @DSET() and @DGET().
---
---             CARTDATA("ZEP_DARK_FOREST")
---             DSET(0, SCORE)
---
---         ID is a string up to 64 characters long, and should be unusual enough that  other
---         cartridges do not accidentally use the same id. Legal characters are a..z, 0..9 and
---         underscore (_)
---
---         Returns true if data was loaded, otherwise false.
---
---         CARTDATA can be called once per cartridge execution, and so only a single data slot can be
---         used.
---
---         Once a cartdata ID has been set, the area of memory 0X5E00..0X5EFF is mapped  to permanent
---         storage, and can either be accessed directly or via @DGET()/@DSET().
---
---         There is no need to flush written data -- it is automatically saved to permanent storage
---         even if modified by directly @POKE()'ing 0X5E00..0X5EFF.
---
---@param id unknown
---@return unknown
function cartdata(id) end

--- DGET(INDEX)
---
---         Get the number stored at INDEX (0..63)
---
---         Use this only after you have called @CARTDATA()
---
---@param index unknown
---@return unknown
function dget(index) end

--- DSET(INDEX, VALUE)
---
---         Set the number stored at index (0..63)
---
---         Use this only after you have called @CARTDATA()
---
---@param index unknown
---@param value unknown
---@return unknown
function dset(index, value) end

--- SETMETATABLE(TBL, M)
---
---         Set table TBL metatable to M
---
---@param tbl unknown
---@param m unknown
---@return unknown
function setmetatable(tbl, m) end

--- GETMETATABLE(TBL)
---
---         return the current metatable for table t, or nil if none is set
---
---@param tbl unknown
---@return unknown
function getmetatable(tbl) end

--- RAWSET(TBL, KEY, VALUE)
---
---@param tbl unknown
---@param key unknown
---@param value unknown
---@return unknown
function rawset(tbl, key, value) end

--- RAWGET(TBL, KEY)
---
---@param tbl unknown
---@param key unknown
---@return unknown
function rawget(tbl, key) end

--- RAWEQUAL(TBL1,TBL2
---
---@param tbl1 unknown
---@param tbl2 unknown
---@return unknown
function rawequal(tbl1, tbl2) end

--- RAWLEN(TBL)
---
---         Raw access to the table, as if no metamethods were defined.
---
---@param tbl unknown
---@return unknown
function rawlen(tbl) end

--- COCREATE(F)
---
---         Create a coroutine for function f.
---
---@param f unknown
---@return unknown
function cocreate(f) end

--- CORESUME(C, [P0, P1 ..])
---
---         Run or continue the coroutine c. Parameters p0, p1.. are passed to the coroutine's
---         function.
---
---         Returns true if the coroutine completes without any errors Returns false, error_message if
---         there is an error.
---
---         ** Runtime errors that occur inside coroutines do not cause the program to stop running. It
---         is a good idea to wrap CORESUME() inside an @ASSERT(). If the assert fails, it will print
---         the error message generated by  coresume.
---
---@overload fun(c: unknown, p0: unknown, ...): unknown
---@param c unknown
---@return unknown
function coresume(c) end

--- COSTATUS(C)
---
---         Return the status of coroutine C as a string:
---             "running"
---             "suspended"
---             "dead"
---
---@param c unknown
---@return unknown
function costatus(c) end

--- YIELD()
---
---         Suspend execution and return to the caller.
---
---@return unknown
function yield() end
