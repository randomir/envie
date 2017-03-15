Commands Reference
==================

.. code-block:: bash

    envie [DIR] [KEYWORDS]

    envie SCRIPT

    envie {go [DIR] [KEYWORDS] |
           create ... | remove |
           list [DIR] | find [DIR] |
           python [SCRIPT] | run CMD |
           index | config}



``envie create`` / ``mkenv`` - Create a new virtual environment
---------------------------------------------------------------

::

    Create a Python (2/3) virtual environment in DEST_DIR based on PYTHON.

    Usage:
        mkenv [-2|-3|-p PYTHON] [-r PIP_REQ] [-a] [-t] [DEST_DIR] [-- ARGS_TO_VIRTUALENV]
        mkenv2 [-r PIP_REQ] [-a] [-t] [DEST_DIR] [-- ARGS_TO_VIRTUALENV]
        mkenv3 [-r PIP_REQ] [-a] [-t] [DEST_DIR] [-- ARGS_TO_VIRTUALENV]
    
    Options:
        -2, -3      use Python 2, or Python 3
        -p PYTHON   use Python accessible with PYTHON name,
                    like 'python3.5', or '/usr/local/bin/mypython'.
        -r PIP_REQ  install pip requirements in the created virtualenv
        -i PIP_PKG  install pip package in the created virtualenv
        -a          autodetect and install pip requirements
        -t          create throw-away env in /tmp
        -v[v]       be verbose: show virtualenv&pip info/debug messages
        -q[q]       be quiet: suppress info/error messages

This command creates a new Python virtual environment with the ``virtualenv``
tool in a destination directory ``DEST_DIR`` (defaults to: ``env`` in current
directory, but it can be overriden with :doc:`config` variable ``_ENVIE_DEFAULT_ENVNAME``).

The default Python interpreter version (executable) is defined with the config
variable ``_ENVIE_DEFAULT_PYTHON`` and it will use system's default ``python``
if otherwise unspecified. Python executable can be specified with ``-p``
parameter like this: ``-p /path/to/python``, or ``-p python3.5``. The shorthand
flags ``-2`` and ``-3`` will select the default Python 2 and Python 3
interpreters available, respectively.

To combine with ``pip`` and pre-install a set of Pip packages (requirements),
you can use ``-r requirements-file.txt`` or  ``-i package/archive/url``. The
first form will install requirements from a given file (or files, if option is
repeated). You can combine it with ``-a`` flag which performs "requirements
autodetection and install" (all files named ``requirements.txt`` below the
current directory are installed).

The second form will accept any package specification recognized by
pip and pass-through to pip -- for example:

- ``-i requests``, ``-i "jsonplus>=0.6"``,
- ``-i /path/to/my/local/package``,
- ``-i "-e git+https://github.com/randomir/plucky.git#egg=plucky"``.

Throw-away or temporary environment is created with ``-t`` flag. The location
and name of the virtual environment are chosen randomly with the ``mktemp``
(something like ``/tmp/tmp.4Be8JJ8OJb``). When done with hacking in a throw-away
env, simply destroy it with ``rmenv -f``.

.. note:: TODO examples



``envie remove`` / ``rmenv`` - Delete an existing virtual environment
---------------------------------------------------------------------

::

    Remove (delete) the base directory of the active virtual environment.

    Usage:
        rmenv [-f]
    
    Options:
        -f    force; don't ask for permission



``envie list`` / ``lsenv [DIR]`` - List virtual environments below ``DIR``
--------------------------------------------------------------------------

::

    Find and list all virtualenvs under DIR.

    Usage:
        lsenv [-f|-l] [DIR [AVOID_SUBDIR]]

    Options:
        -f, --find    use only 'find' for search
        -l, --locate  use only 'locate' for search
                      (by default, try find for 0.4s, then failback to locate)
        -v            be verbose: show info messages
        -q            be quiet: suppress error messages

``envie list`` searches down only, starting with the ``DIR`` given (default ``.``).
The search method is defined with config, but it can be overriden with ``-f``
and ``-l`` to force ``find`` or ``locate`` methods respectively.



``envie find`` / ``lsupenv [DIR]`` - Find the closest virtual around ``DIR``
----------------------------------------------------------------------------

::

    Find and list all virtualenvs below DIR, or above if none found below.

    Usage:
        lsupenv [-f|-l] [DIR]

    Options:
        -f, --find    use only 'find' for search
        -l, --locate  use only 'locate' for search
                      (by default, try find for 0.4s, then failback to locate)
        -v            be verbose: show info messages
        -q            be quiet: suppress error messages


Similar to ``envie list``, but with a key distinction: if no environments are
found below the starting ``DIR``, the search is being expanded -- level by level
up -- until at least one virtual environment is found.



``envie go`` / ``chenv`` - Interactively activate the closest virtual environment
---------------------------------------------------------------------------------

::

    Interactively activate the closest Python virtual environment relative to DIR (or .)
    A list of the closest environments is filtered by KEYWORDS.

    Usage:
        chenv [-1] [-v] [-q] [DIR] [KEYWORDS]

    Options:
        -1    activate only if a single closest env found, abort otherwise
        -v    be verbose: show info messages (path to activated env)
        -q    be quiet: suppress error messages


.. note:: TODO description, examples

