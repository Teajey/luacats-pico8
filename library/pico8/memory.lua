---@meta

--- ----------------------------------------------------------------------------------------------------
---     Memory
--- ----------------------------------------------------------------------------------------------------
---
---     PICO-8 has 3 types of memory:
---
---         1. Base RAM (64k): see layout below. Access with PEEK() POKE() MEMCPY() MEMSET()
---         2. Cart ROM (32k): same layout as base ram until 0x4300
---         3. Lua RAM (2MB): compiled program + variables
---
---         Technical note: While using the editor, the data being modified is in cart rom, but api
---         functions such as @SPR()  and @SFX() only operate on base ram. PICO-8 automatically copies
---         cart rom to base ram (i.e. calls @RELOAD()) in 3 cases:<br> 1. When a cartridge is
---         loaded<br> 2. When a cartridge is run<br> 3. When exiting any of the editor modes // can
---         turn off with: poke(0x5f37,1)<br>
---
---     :: Base RAM Memory Layout
---
---         0X0    GFX
---         0X1000 GFX2/MAP2 (SHARED)
---         0X2000 MAP
---         0X3000 GFX FLAGS
---         0X3100 SONG
---         0X3200 SFX
---         0X4300 USER DATA
---         0X5600 CUSTOM FONT (IF ONE IS DEFINED)
---         0X5E00 PERSISTENT CART DATA (256 BYTES)
---         0X5F00 DRAW STATE
---         0X5F40 HARDWARE STATE
---         0X5F80 GPIO PINS (128 BYTES)
---         0X6000 SCREEN (8K)
---         0x8000 USER DATA
---
---         User data has no particular meaning and can be used for anything via @MEMCPY(), @PEEK() &
---         @POKE(). Persistent cart data is mapped to 0x5e00..0x5eff but only stored if @CARTDATA()
---         has been called. Colour format (gfx/screen) is 2 pixels per byte: low bits encode the left
---         pixel of each pair. Map format is one byte per tile, where each byte normally encodes a
---         sprite index.
---
---     :: Remapping Graphics and Map Data
---
---         The GFX, MAP and SCREEN memory areas can be reassigned by setting values at the following
---         addresses:
---
---         0X5F54 GFX:    can be 0x00 (default) or 0x60 (use the screen memory as the spritesheet)
---         0X5F55 SCREEN: can be 0x60 (default) or 0x00 (use the spritesheet as screen memory)
---         0X5F56 MAP:    can be 0x20 (default) or 0x10..0x2f, or 0x80 and above.
---         0X5F57 MAP SIZE: map width. 0 means 256. Defaults to 128.
---
---         Addresses can be expressed in 256 byte increments. So 0x20 means 0x2000, 0x21 means 0x2100
---         etc. Map addresses 0x30..0x3f are taken to mean 0x10..0x1f (shared memory area). Map data
---         can only be contained inside the memory regions 0x1000..0x2fff, 0x8000..0xffff, and  the
---         map height is determined to be the largest possible size that fits in the given region.
---
---         GFX and SCREEN addresses can additionally be mapped to upper memory locations 0x80, 0xA0,
---         0xC0, 0xE0,  with the constraint that MAP can not overlap with that address (in this case,
---         the conflicting GFX and/or SCREEN mappings are kicked back to their default mapping).
---
---         GFX and SCREEN memory mapping happens at a low level which also affects memory access
---         functions (peek, poke, memcpy). The 8k memory blocks starting at 0x0 and 0x6000 can be
---         thought of as pointers  to a separate video ram, and setting the values at 0X5F54 and
---         0X5F56 alters those pointers.
---
---

--- PEEK(ADDR, [N])
---
---         Read a byte from an address in base ram. If N is specified, PEEK() returns that number of
---         results (max: 8192). For example, to read the first 2 bytes of video memory:
---
---             A, B = PEEK(0x6000, 2)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PEEK)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#POKE)
---
---@param addr unknown
---@param val1 unknown
---@param val2 unknown
---@return unknown
function poke(addr, val1, val2, ...) end

--- PEEK2(ADDR)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PEEK2)
---
---@param addr unknown
---@return unknown
function peek2(addr) end

--- POKE2(ADDR, VAL)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#POKE2)
---
---@param addr unknown
---@param val unknown
---@return unknown
function poke2(addr, val) end

--- PEEK4(ADDR)
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PEEK4)
---
---@param addr unknown
---@return unknown
function peek4(addr) end

--- POKE4(ADDR, VAL)
---
---         16-bit and 32-bit versions of PEEK and POKE. Read and write one number (VAL) in
---         little-endian format:
---
---             16 bit: 0xffff.0000
---             32 bit: 0xffff.ffff
---
---         ADDR does not need to be aligned to 2 or 4-byte boundaries.
---
---     Alternatively, the following operators can be used to peek (but not poke), and are slightly
---     faster:
---
---         @ADDR  -- PEEK(ADDR)
---         %ADDR  -- PEEK2(ADDR)
---         $ADDR  -- PEEK4(ADDR)
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#POKE4)
---
---@param addr unknown
---@param val unknown
---@return unknown
function poke4(addr, val) end

--- MEMCPY(DEST_ADDR, SOURCE_ADDR, LEN)
---
---         Copy LEN bytes of base ram from source to dest. Sections can be overlapping
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MEMCPY)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RELOAD)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#CSTORE)
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
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MEMSET)
---
---@param dest_addr unknown
---@param val unknown
---@param len unknown
---@return unknown
function memset(dest_addr, val, len) end
