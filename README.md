# PICO-8 Definitions

Lua definitions for the PICO-8 Fantasy Console

Also see https://github.com/ahai64/pico-api

## Usage

Copy the library/ directory into your project.

It's also best to configure LuaLS as much as possible for PICO-8's flavour of Lua.

The following is an example config for LuaLS (.luarc.json)

All configuration options are available here: https://luals.github.io/wiki/configuration/

```json
{
  "workspace.library": [
    "library/"
  ],
  "files.associations": {
    "*.lua": "lua"
  },
  "runtime.version": "LuaJIT",
  "diagnostics.disable": [
    "lowercase-global",
    "unknown-symbol",
    "unicode-name"
  ],
  "runtime.nonstandardSymbol": [
    "!=",
    "+=",
    "-=",
    "*=",
    "/=",
    "%=",
    "^=",
    "|=",
    "&=",
    "<<=",
    ">>=",
    "//"
  ],
  "runtime.builtin": {
    "basic": "disabled",
    "bit": "disabled",
    "bit32": "disabled",
    "builtin": "disabled",
    "coroutine": "disabled",
    "debug": "disabled",
    "ffi": "disabled",
    "io": "disabled",
    "jit": "disabled",
    "math": "disabled",
    "os": "disabled",
    "package": "disabled",
    "string": "disabled",
    "table": "disabled",
    "table.clear": "disabled",
    "table.new": "disabled",
    "utf8": "disabled"
  }
}
```

## Development guidelines

1. Copy the API Reference section of https://www.lexaloffle.com/dl/docs/pico-8_manual.txt to pico8_api_reference.txt, starting from

```
----------------------------------------------------------------------------------------------------
    System
----------------------------------------------------------------------------------------------------
```

Up until the next `^=+` line. (Ideally there'll be a Python script for this soon)

2. Be sure to only commit genuine changes to pico8_api_reference.txt from the source. There are some places it has been changed just for the sake of consistency to make implementing the pico8_stubs_generator.py easier.

3. Make any necessary changes to pico8_stubs_generator.py to produce the desired LuaCATS output

4. Run the generator script, and be sure to only commit the changes that reflect the changes in pico8_api_reference.txt, without overwriting parameter types, because...

5. Variable types are maintained manually, because they can't reasonably be derived from the manual automatically.
