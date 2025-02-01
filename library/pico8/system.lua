---@meta

--- ----------------------------------------------------------------------------------------------------
---     System
--- ----------------------------------------------------------------------------------------------------
---
---     System functions called from commandline can omit the usual brackets and string quotes. For
---     example, instead of LOAD("BLAH.P8"), it is possible to write:
---
---     >LOAD BLAH.P8
---
---

--- LOAD(FILENAME, [BREADCRUMB], [PARAM_STR])
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#LOAD)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SAVE)
---
---@param filename unknown
---@return unknown
function save(filename) end

--- FOLDER
---
---         Open the carts folder in the host operating system.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FOLDER)
---
---@return unknown
function folder() end

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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#LS)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RUN)
---
---@overload fun(param_str: unknown): unknown
---@return unknown
function run() end

--- STOP([MESSAGE])
---
---         Stop the cart and optionally print a message.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#STOP)
---
---@overload fun(message: unknown): unknown
---@return unknown
function stop() end

--- RESUME
---
---         Resume the program. Use R for short.
---
---         Use a single "." from the commandline to advance a single frame. This enters frame-by-frame
---         mode, that can be read with stat(110). While frame-by-frame mode is active, entering an
---         empty command (by pressing enter) advances one frames.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RESUME)
---
---@return unknown
function resume() end

--- ASSERT(CONDITION, [MESSAGE])
---
---         If CONDITION is false, stop the program and print MESSAGE if it is given. This can be
---         useful for debugging cartridges, by ASSERT()'ing that things that you expect to be true are
---         indeed true.
---
---         ASSERT(ADDR >= 0 AND ADDR <= 0x7FFF, "OUT OF RANGE")
---         POKE(ADDR, 42) -- THE MEMORY ADDRESS IS OK, FOR SURE!
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ASSERT)
---
---@overload fun(condition: unknown, message: unknown): unknown
---@param condition unknown
---@return unknown
function assert(condition) end

--- REBOOT
---
---         Reboot the machine Useful for starting a new project
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#REBOOT)
---
---@return unknown
function reboot() end

--- RESET()
---
---         Reset the values in RAM from 0x5f00..0x5f7f to their default values.  This includes the
---         palette, camera position, clipping and fill pattern. If you get lost at the command prompt
---         because the draw state makes viewing text  impossible, try typing RESET! It can also be
---         called from a running program.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RESET)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#INFO)
---
---@return unknown
function info() end

--- FLIP()
---
---         Flip the back buffer to screen and wait for next frame. This call is not needed when there
---         is a @_DRAW() or @_UPDATE() callback defined, as the flip is performed automatically. But
---         when using a custom main loop, a call to FLIP is normally needed:
---
---         ::_::
---         CLS()
---         FOR I=1,100 DO
---             A=I/50 - T()
---             X=64+COS(A)*I
---             Y=64+SIN(A)*I
---             CIRCFILL(X,Y,1,8+(I/4)%8)
---         END
---         FLIP()GOTO _
---
---         If your program does not call FLIP before a frame is up, and a @_DRAW() callback is not in
---         progress, the current contents of the back buffer are copied to screen.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FLIP)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PRINTH)
---
---@overload fun(str: unknown, filename: unknown): unknown
---@overload fun(str: unknown, filename: unknown, overwrite: unknown): unknown
---@overload fun(str: unknown, filename: unknown, overwrite: unknown, save_to_desktop: unknown): unknown
---@param str unknown
---@return unknown
function printh(str) end

--- TIME()
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#TIME)
---
---@return unknown
function time() end

--- T()
---
---         Returns the number of seconds elapsed since the cartridge was run.
---
---         This is not the real-world time, but is calculated by counting the number of times
---
---
---         _UPDATE or @_UPDATE60 is called. Multiple calls of TIME() from the same frame return
---
---         the same result.
---
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#T)
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
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#STAT)
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
---         :: Recording GIFs
---
---             EXTCMD("REC"), EXTCMD("VIDEO") is the same as using ctrl-8, ctrl-9 and saves a gif to
---             the desktop using the current GIF_SCALE setting (use CONFIG GIF_SCALE to change).
---
---             The two additional parameters can be used to override these defaults:
---
---                 EXTCMD("VIDEO", 4)    -- SCALE *4 (512 X 512)
---                 EXTCMD("VIDEO", 0, 1) -- DEFAULT SCALING, SAVE TO USER DATA FOLDER
---
---             The user data folder can be opened with EXTCMD("FOLDER") and defaults to the same path
---             as the cartridge, or {pico-8 appdata}/appdata/appname for exported binaries.
---
---             Due to the nature of the gif format, all gifs are recorded at 33.3fps, and frames
---             produced by PICO-8 are skipped or duplicated in the gif to match roughly what the user
---             is seeing. To record exactly one frame each time @FLIP() is called, regardless of the
---             runtime framerate or how long it took to generate the frame, use:
---
---                 EXTCMD("REC_FRAMES")
---
---             The default filename for gifs (and screenshots, audio) is foo_%d, where foo is the name
---             of the cartridge, and %d is a number starting at 0 and automatically incremented until
---             a file of that name does not exist. Use EXTCMD("SET_FILENAME","FOO") to override that
---             default. If the custom filename includes "%d", then the auto- incrementing number
---             behaviour is used, but otherwise files are written even if  there is an existing file
---             with the same name.
---
--- [View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#EXTCMD)
---
---@overload fun(cmd_str: unknown, p1: unknown, p2: unknown): unknown
---@param cmd_str unknown
---@return unknown
function extcmd(cmd_str) end
