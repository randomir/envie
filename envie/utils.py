#!/usr/bin/env python

"""Envie cross-platform utils, serving as a fallback if a tool is not available
on a particular user's platform."""

from __future__ import absolute_import, print_function
import sys
import os
import os.path


def readlink(path, *args):
    """Emulate GNU coretools' `readlink -m <path>`.
    Return canonical (normalized, absolute) path by following every symlinks,
    without requirements on components existence.
    """
    return os.path.realpath(os.path.expanduser(path))


def realpath(path, start=None, *args):
    """Emulate GNU coretools' `realpath --relative-to=<start> <path>`.
    Extends `readlink` to return canonical path relative to `start`.
    Without `start` (None, missing, or empty string), equivalent to `readlink`.
    """
    path = readlink(path)
    if not start:
        return path
    return os.path.relpath(path, start)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        sys.exit(255)

    tool = sys.argv[1]
    args = sys.argv[2:]

    tools = {
        'readlink': readlink,
        'realpath': realpath
    }

    if tool in tools:
        print(tools[tool](*args))
    else:
        sys.exit(1)
