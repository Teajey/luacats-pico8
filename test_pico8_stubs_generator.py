from dataclasses import asdict
import unittest
import re

from pico8_stubs_generator import (
    extract_commands,
    window,
    command_to_lua_function,
    delve_overloads,
    COMMAND_REGEX,
    Command,
)


class TestWindow(unittest.TestCase):
    def test_command_regex(self):
        m = re.search(COMMAND_REGEX, "    PALT(C, [T])")
        assert m
        self.assertEqual(
            m.group(),
            "    PALT(C, [T])",
        )

        m = re.search(COMMAND_REGEX, "    SPR(N, X, Y, [W, H], [FLIP_X], [FLIP_Y])")
        assert m
        self.assertEqual(
            m.group(),
            "    SPR(N, X, Y, [W, H], [FLIP_X], [FLIP_Y])",
        )

        m = re.search(COMMAND_REGEX, "    FOLDER")
        assert m
        self.assertEqual(
            m.group(),
            "    FOLDER",
        )

        m = re.search(COMMAND_REGEX, "    EXTCMD(CMD_STR, [P1, P2])")
        assert m
        self.assertEqual(
            m.group(),
            "    EXTCMD(CMD_STR, [P1, P2])",
        )

    def test_window(self):
        self.assertSequenceEqual(
            list(window(iter([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]))),
            [
                [0, 1],
                [1, 2],
                [2, 3],
                [3, 4],
                [4, 5],
                [5, 6],
                [6, 7],
                [7, 8],
                [8, 9],
            ],
        )

        self.assertSequenceEqual(
            list(window(iter([0, 1, 2, 3, 4]), 3)),
            [
                [0, 1, 2],
                [1, 2, 3],
                [2, 3, 4],
            ],
        )

        self.assertSequenceEqual(
            list(window(iter([0]), 3)),
            [],
        )

    def test_command_to_lua_function(self):
        self.maxDiff = None

        lua_fn = command_to_lua_function(Command(name="YIELD"))
        self.assertEqual(
            """---@return unknown
function yield() end""",
            lua_fn,
        )

        lua_fn = command_to_lua_function(Command(name="MSET", args=["X", "Y", "VAL"]))
        self.assertEqual(
            """---@param x unknown
---@param y unknown
---@param val unknown
---@return unknown
function mset(x, y, val) end""",
            lua_fn,
        )

        lua_fn = command_to_lua_function(
            Command(
                name="MAP",
                args=[
                    "TILE_X",
                    "TILE_Y",
                    ["SX", "SY"],
                    ["TILE_W", "TILE_H"],
                    ["LAYERS"],
                ],
            )
        )
        self.assertEqual(
            """---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown): unknown
---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown, tile_w: unknown, tile_h: unknown): unknown
---@overload fun(tile_x: unknown, tile_y: unknown, sx: unknown, sy: unknown, tile_w: unknown, tile_h: unknown, layers: unknown): unknown
---@param tile_x unknown
---@param tile_y unknown
---@return unknown
function map(tile_x, tile_y) end""",
            lua_fn,
        )

    #         lua_fn = command_to_lua_function("CHR(VAL0, VAL1, ...)")
    #         self.assertEqual(
    #             """---@param val0 unknown
    # ---@param val1 unknown
    # ---@return unknown
    # function chr(val0, val1, ...) end""",
    #             lua_fn,
    #         )

    #         lua_fn = command_to_lua_function("CORESUME(C, [P0, P1 ..])")
    #         self.assertEqual(
    #             """---@overload fun(c: unknown, p0: unknown, ...): unknown
    # ---@param c unknown
    # ---@return unknown
    # function coresume(c) end""",
    #             lua_fn,
    #         )

    #         lua_fn = command_to_lua_function("FSET(N, [F], VAL)")
    #         self.assertEqual(
    #             """---@overload fun(n: unknown, f: unknown, val: unknown): unknown
    # ---@param n unknown
    # ---@param val unknown
    # ---@return unknown
    # function fset(n, val) end""",
    #             lua_fn,
    #         )

    #         lua_fn = command_to_lua_function("SPR(N, X, Y, [W, H], [FLIP_X], [FLIP_Y])")
    #         self.assertEqual(
    #             """---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown): unknown
    # ---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown, flip_x: unknown): unknown
    # ---@overload fun(n: unknown, x: unknown, y: unknown, w: unknown, h: unknown, flip_x: unknown, flip_y: unknown): unknown
    # ---@param n unknown
    # ---@param x unknown
    # ---@param y unknown
    # ---@return unknown
    # function spr(n, x, y) end""",
    #             lua_fn,
    #         )

    #         # NOTE: This test case is broken... I think this signature for LINE is actually just inconsistently written
    #         lua_fn = command_to_lua_function("LINE(X0, Y0, [X1, Y1, [COL]])")
    #         self.assertEqual(
    #             """---@overload fun(x0: unknown, y0: unknown, col: unknown): unknown
    # ---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown): unknown
    # ---@overload fun(x0: unknown, y0: unknown, x1: unknown, y1: unknown, col: unknown): unknown
    # ---@param x0 unknown
    # ---@param y0 unknown
    # ---@return unknown
    # function line(x0, y0) end""",
    #             lua_fn,
    #         )

    def test_delve_overloads(self):
        test_list = ["0", ["1"], "2", ["3", "4"], ["5", ["6"]]]

        self.assertSequenceEqual(
            delve_overloads(test_list, 0),
            (["0", "2"], 0),
        )

        self.assertSequenceEqual(
            delve_overloads(test_list, 1),
            (["0", "1", "2"], 0),
        )

        self.assertSequenceEqual(
            delve_overloads(test_list, 2),
            (["0", "1", "2", "3", "4"], 0),
        )

        self.assertSequenceEqual(
            delve_overloads(test_list, 3),
            (["0", "1", "2", "3", "4", "5"], 0),
        )

        self.assertSequenceEqual(
            delve_overloads(test_list, 4),
            (["0", "1", "2", "3", "4", "5", "6"], 0),
        )

        self.assertSequenceEqual(
            delve_overloads(test_list, 5),
            (["0", "1", "2", "3", "4", "5", "6"], 1),
        )

    def test_extract_commands(self):
        text = """
    SETMETATABLE(TBL, M)

        Set table TBL metatable to M


    GETMETATABLE(TBL)

        return the current metatable for table t, or nil if none is set

    RAWSET(TBL, KEY, VALUE)

    RAWGET(TBL, KEY)

"""
        self.maxDiff = None
        split_text = text.splitlines(keepends=True)
        commands_iter = extract_commands(window(iter(split_text), 3))
        commands = list(commands_iter)
        self.assertDictEqual(
            {
                "args": ["TBL", "M"],
                "doc": "\n        Set table TBL metatable to M\n\n\n",
                "name": "SETMETATABLE",
                "original": "SETMETATABLE(TBL, M)",
            },
            asdict(commands[0]),
        )
        self.assertDictEqual(
            {
                "args": ["TBL"],
                "doc": "\n"
                "        return the current metatable for table t, or nil if none is "
                "set\n"
                "\n",
                "name": "GETMETATABLE",
                "original": "GETMETATABLE(TBL)",
            },
            asdict(commands[1]),
        )
        self.assertDictEqual(
            {
                "args": ["TBL", "KEY", "VALUE"],
                "doc": "\n",
                "name": "RAWSET",
                "original": "RAWSET(TBL, KEY, VALUE)",
            },
            asdict(commands[2]),
        )
        self.assertDictEqual(
            {
                "args": ["TBL", "KEY"],
                "doc": "\n",
                "name": "RAWGET",
                "original": "RAWGET(TBL, KEY)",
            },
            asdict(commands[3]),
        )


if __name__ == "__main__":
    unittest.main()
