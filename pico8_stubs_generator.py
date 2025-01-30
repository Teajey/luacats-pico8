#!/usr/bin/env python3
from collections import deque
from dataclasses import dataclass, field
from typing import Iterator
from typing import TypeVar
import re
import yaml
import sys

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


COMMAND_REGEX = re.compile("^ {4,6}[A-Z]+(\\([A-Z_0-9,\\[\\]\\. ]*\\))?\\s*$")


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

        # print(f"command: {command=}")
        # print(f"doc: {line=}")

        while lines := next(it, None):
            _, _, line = lines

            # print(f"doc: {line=}")

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
    header: list[str] = field(default_factory=list)
    title: str = ""
    doc: list[str] = field(default_factory=list)
    commands: list[Command] = field(default_factory=list)


def extract_sections(it: Iterator[str]) -> Iterator[Section]:
    win = window(it, 3)

    while lines := next(win, None):
        result = Section()
        line1, line2, line3 = lines

        if not (line1.startswith("-" * 10) and line3.startswith("-" * 10)):
            continue

        result.header = [line1, line2, line3]
        result.title = line2.strip()

        while lines := next(win):
            _, _, line = lines
            if line.startswith("-" * 10):
                break
            if re.match(COMMAND_REGEX, line):
                break
            result.doc.append(line)

        result.commands = list(extract_commands(win))

        yield result


def extract_command_docs(it: Iterator[str]) -> Iterator[list[str]]:
    f = window(it)
    while True:
        result: list[str] = []
        try:
            line, next_line = next(f)
        except StopIteration:
            break

        if not re.search(COMMAND_REGEX, line):
            continue

        result.append(line.strip())

        while True:
            current_line, next_line = next(f)

            if current_line == line:
                continue

            result.append(current_line)

            if next_line is None:
                continue

            if not current_line.strip() and not next_line.strip():
                break

            if next_line.lstrip().startswith("="):
                break
            if next_line.lstrip().startswith("-"):
                break
            if next_line.lstrip().startswith(":"):
                break
            if re.search(COMMAND_REGEX, next_line):
                break

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


def main():
    # with open("./pico8_api_reference.txt") as f:
    #     command_docs = list(extract_command_docs(f))

    with open("./pico8_api_reference.txt") as f:
        sections = list(extract_sections(f))

    print("---@meta")
    print()

    for section in sections:
        # for line in section.header:
        #     print("---", line, end="")
        # for line in section.doc:
        #     print("---", line, end="")
        # print()
        # print()

        for comm in section.commands:
            print("---", comm.original)
            for line in comm.doc.splitlines(keepends=True):
                print("---", line, end="")
            print(
                "---",
                f"[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#{comm.name})",
            )
            print("---")
            print(command_to_lua_function(comm))
            print()

    for i, section in enumerate(sections):
        print(i + 1, section.title, file=sys.stderr)

    # for command, *doc in command_docs:
    #     print("---", command)
    #     for line in doc:
    #         print("---", line, end="")
    #     command_name, _, _, = command.partition("(")
    #     print("---", f"[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#{command_name})")
    #     print("---")
    #     print(command_to_lua_function(command))
    #     print()


if __name__ == "__main__":
    main()
