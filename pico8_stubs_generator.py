#!/usr/bin/env python3
from collections import deque
from dataclasses import dataclass, field
from typing import Iterator
from typing import TypeVar
import re
import yaml

T = TypeVar("T")


def window(it: Iterator[T], size: int = 2) -> Iterator[list[T]]:
    if size < 2:
        raise ValueError("Window size must be at least 2")

    window: deque[T] = deque(maxlen=size)

    for _ in range(size):
        try:
            window.append(next(it))
        except StopIteration:
            return

    yield list(window)

    for item in it:
        window.append(item)
        yield list(window)


type ArgGroup = list[str | ArgGroup]


def delve_overloads(args: list[str | ArgGroup], limit: int) -> tuple[list[str], int]:
    return_args: list[str] = []
    for a in args:
        if isinstance(a, str):
            return_args.append(a)
        elif isinstance(a, list) and limit > 0:
            overloads, limit = delve_overloads(a, limit - 1)
            return_args += overloads
    return return_args, limit


def progress_overloads(args: list[str | ArgGroup]) -> Iterator[list[str]]:
    i = 0
    while True:
        i += 1
        overloads, lim = delve_overloads(args, i)

        if lim > 0:
            return

        yield overloads


COMMAND_REGEX = re.compile(r"^ {4}[A-Z][A-Z0-9]*(\([A-Z_0-9,\[\]\. ]*\))?\s*$")


@dataclass
class Command:
    original: str = ""
    name: str = ""
    doc: str = ""
    args: list[str | ArgGroup] = field(default_factory=list)


def extract_commands(it: Iterator[list[str]]) -> Iterator[Command]:
    while lines := next(it, None):
        result = Command()
        _, command, line = lines
        result.original = command.strip()
        command_name, _, args = command.partition("(")
        result.name = command_name.strip()
        args, _, _ = args.partition(")")
        result.args = yaml.safe_load(f"[{args}]")

        result.doc += line

        while lines := next(it, None):
            _, _, line = lines

            if line.startswith("-" * 10):
                break
            elif re.match(COMMAND_REGEX, line):
                break

            result.doc += line

        yield result

        if line.startswith("-" * 10):
            break


@dataclass
class Section:
    header: tuple[str, str, str]
    title: str = ""
    doc: list[str] = field(default_factory=list)
    commands: list[Command] = field(default_factory=list)


def extract_sections(it: Iterator[str]) -> Iterator[Section]:
    win = window(it, 3)

    while lines := next(win, None):
        line1, line2, line3 = lines

        if not (line1.startswith("-" * 10) and line3.startswith("-" * 10)):
            continue

        result = Section((line1, line2, line3))
        result.title = line2.strip()

        while lines := next(win):
            _, _, line = lines
            if line.startswith("-" * 10):
                break
            if re.match(COMMAND_REGEX, line):
                result.commands = list(extract_commands(win))
                break
            result.doc.append(line)

        yield result


def lua_function_lines(comm: Command) -> Iterator[str]:
    default_args = [a.lower() for a in comm.args if isinstance(a, str)]
    yield f"function {comm.name.lower()}({', '.join([a for a in default_args])}) end"
    yield "---@return unknown"

    for a in reversed(default_args):
        if a == "...":
            continue
        yield f"---@param {a} unknown"

    for overload_args in reversed(list(progress_overloads(comm.args))):
        yield f"---@overload fun({', '.join([f'{a.lower()}: unknown' if '..' not in a else '...' for a in overload_args])}): unknown"


def command_to_lua_function(command: Command) -> str:
    return "\n".join(reversed(list(lua_function_lines(command))))


TITLE_2_FILENAME = {
    "System": "system",
    "Graphics": "graphics",
    "Table Functions": "table",
    "Input": "input",
    "Audio": "audio",
    "Map": "map",
    "Memory": "memory",
    "Math": "math",
    "Custom Menu Items": "menu",
    "Strings and Type Conversion": "string",
    "Cartridge Data": "cartridge_data",
    "GPIO": "gpio",
    "Mouse and Keyboard Input": "mouse_and_keyboard",
    "Additional Lua Features": "additional",
}


def main():
    with open("./pico8_api_reference.txt") as f:
        sections = list(extract_sections(f))

    for section in sections:
        filename = TITLE_2_FILENAME[section.title]
        with open(f"./library/pico8/{filename}.lua", "w") as f:
            print("---@meta", file=f)
            print(file=f)
            for line in section.header:
                print("---", line, end="", file=f)
            for line in section.doc:
                print("---", line, end="", file=f)
            print(file=f)
            print(file=f)

            for comm in section.commands:
                print("---", comm.original, file=f)
                for line in comm.doc.splitlines(keepends=True):
                    print("---", line, end="", file=f)
                print(
                    "---",
                    f"[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#{comm.name})",
                    file=f,
                )
                print("---", file=f)
                print(command_to_lua_function(comm), file=f)
                print(file=f)


if __name__ == "__main__":
    main()
