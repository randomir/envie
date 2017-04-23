"""Envie utils."""
from __future__ import absolute_import
import os
import os.path


def readlink(path):
    """Emulate GNU coretools' `readlink -m <path>`.
    Return canonical (normalized, absolute) path by following every symlinks,
    without requirements on components existence.
    """
    return os.path.realpath(os.path.expanduser(path))


def realpath(path, start=None):
    """Emulate GNU coretools' `realpath --relative-to=<start> <path>`.
    Extends `readlink` to return canonical path relative to `start`.
    Without `start`, equivalent to `readlink`.
    """
    path = readlink(path)
    if start is None:
        return path
    return os.path.relpath(path, start)
