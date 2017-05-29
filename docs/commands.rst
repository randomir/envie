Commands Reference
==================

Calling Envie
-------------

The ``envie`` script (or a :ref:`shell function <source-vs-exec>`) has three
calling forms -- two "shortcut" forms, and general/all-purpose form:

1. **find & activate**
^^^^^^^^^^^^^^^^^^^^^^

    ::

        envie [OPTIONS] [DIR] [KEYWORDS]

    The first form interactively activates the closest environment (relative to
    ``DIR``, or the current working directory, filtered by ``KEYWORDS``). If a
    single closest environment is detected, it is auto-activated. This calling
    form is basically an alias for ``chenv -v [DIR] [KEYWORDS]``. For options
    and details on environments discovery/selection, see :ref:`chenv <chenv>`
    below.


2. **run python script**
^^^^^^^^^^^^^^^^^^^^^^^^

    ::

        envie SCRIPT

    The second form is a shorthand for executing python scripts in the closest
    virtual environment, without the need for a manual env activation. It's
    identical in behaviour to ``envie python SCRIPT``
    (see :ref:`below <envie-python>`), but more convenient for a hash bang use:

        .. code-block:: python

            #!/usr/bin/env envie
            # Python script here will be executed in the closest virtual env


3. **general**
^^^^^^^^^^^^^^

    ::

        envie {create [ENV] | remove |
               list [DIR] [KEYWORDS] | find [DIR] [KEYWORDS] |
               python [SCRIPT] | run CMD |
               index | config | help | --help | --version}

    The third is a general form as it explicitly exposes all commands (for
    virtual env creation, removal, discovery, etc.) Most of these commands have a
    shorter alias you'll probably prefer in everyday use (like ``mkenv``, ``lsenv``,
    ``findenv``, ``chenv``, ``rmenv``, etc).



.. _chenv:

``envie`` / ``chenv`` - Interactively activate the closest virtual environment
------------------------------------------------------------------------------

::

    Interactively activate the closest Python virtual environment relative to DIR (or .)
    A list of the closest environments is filtered by KEYWORDS. Separate KEYWORDS with --
    if they start with a dash, or a dir with the same name exists.

    Usage:
        chenv [-1] [-f|-l] [-v] [-q] [DIR] [--] [KEYWORDS]
        envie ...

    Options:
        -1            activate only if a single closest env found, abort otherwise
        -f, --find    use only 'find' for search
        -l, --locate  use only 'locate' for search
        -v            be verbose: show info messages (path to activated env)
        -q            be quiet: suppress error messages

    For details on other Envie uses, see 'envie help'.


.. note:: TODO description, examples



``envie create`` / ``mkenv`` - Create a new virtual environment
---------------------------------------------------------------

::

    Create Python (2/3) virtual environment in DEST_DIR based on PYTHON.

    Usage:
        mkenv [-2|-3|-e PYTHON] [-r PIP_REQ] [-p PIP_PKG] [-a] [-t] [DEST_DIR] [-- ARGS_TO_VIRTUALENV]
        mkenv2 [-r PIP_REQ] [-p PIP_PKG] [-a] [-t] [DEST_DIR] ...
        mkenv3 [-r PIP_REQ] [-p PIP_REQ] [-a] [-t] [DEST_DIR] ...
        envie create ...

    Options:
        -2, -3      use Python 2, or Python 3
        -e PYTHON   use Python accessible with PYTHON name,
                    like 'python3.5', or '/usr/local/bin/mypython'.
        -r PIP_REQ  install pip requirements in the created virtualenv,
                    e.g. '-r dev-requirements.txt'
        -p PIP_PKG  install pip package in the created virtualenv,
                    e.g. '-p "Django>=1.9"', '-p /var/pip/pkg', '-p "-e git+https://gith..."'
        -a          autodetect and install pip requirements
                    (search for the closest 'requirements.txt' and install it)
        -t          create throw-away env in /tmp
        -v[v]       be verbose: show virtualenv&pip info/debug messages
        -q[q]       be quiet: suppress info/error messages

    For details on other Envie uses, see 'envie help'.


This command creates a new Python virtual environment with the ``virtualenv``
tool in a destination directory ``DEST_DIR`` (defaults to: ``env`` in current
directory, but it can be overriden with :ref:`setup-config` variable
``_ENVIE_DEFAULT_ENVNAME``).

The default Python interpreter version (executable) is defined with the config
variable ``_ENVIE_DEFAULT_PYTHON`` and it will use system's default ``python``
if otherwise unspecified. Python executable can be specified with ``-e``
parameter like this: ``-e /path/to/python``, or ``-e python3.5``. The shorthand
flags ``-2`` and ``-3`` will select the default Python 2 and Python 3
interpreters available, respectively.

To combine with ``pip`` and pre-install a set of Pip packages (requirements),
you can use ``-r requirements-file.txt`` or  ``-p package/archive/url``. The
first form will install requirements from a given file (or files, if option is
repeated). You can combine it with ``-a`` flag which performs "requirements
autodetection and install" (all files named ``requirements.txt`` below the
current directory are installed).

The second form will accept any package specification recognized by
pip and pass-through to pip -- for example:

- ``-p requests``, ``-p "jsonplus>=0.6"``,
- ``-p /path/to/my/local/package``,
- ``-p "-e git+https://github.com/randomir/plucky.git#egg=plucky"``.

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
        rmenv [-f] [-v]
        envie remove ...

    Options:
        -f    force; don't ask for permission
        -v    be verbose

    For details on other Envie uses, see 'envie help'.



``envie list`` / ``lsenv [DIR]`` - List virtual environments below ``DIR``
--------------------------------------------------------------------------

::

    Find and list all virtualenvs under DIR, optionally filtered by KEYWORDS.

    Usage:
        lsenv [-f|-l] [DIR [AVOID_SUBDIR]] [--] [KEYWORDS]
        envie list ...

    Options:
        -f, --find    use only 'find' for search
        -l, --locate  use only 'locate' for search
                      (by default, try find for 0.4s, then failback to locate)
        -v            be verbose: show info messages
        -q            be quiet: suppress error messages

    For details on other Envie uses, see 'envie help'.


``envie list`` searches down only, starting in ``DIR`` (defaults to ``.``).
The search method is defined with config, but it can be overriden with ``-f``
and ``-l`` to force ``find`` or ``locate`` methods respectively.

.. _fuzzy-filtering:

To narrow down the list of virtualenv paths, you can filter it by supplying ``KEYWORDS``.
Filtering algorithm is not strict and exclusive (like grep), but fuzzy and typo- forgiving.

It works like this: (1) all virtualenv paths discovered are split into directory components;
(2) we try to greedily match all keywords to components by maximum similarity score;
(3) paths are sorted by total similarity score; (4) the best matches are passed-thru - if
there's a tie, all best matches are printed.

When calculating similarity between directory name (path component) and a keyword, we
assign: (1) maximum weight to a complete match (identity), (2) smaller, but still high, weight
to a prefix match, and (3) the smallest (and variable) weight to a diff-metric similarity.

For example, suppose you have a directory tree like this one::

    ├── trusty-tahr
    │   ├── dev
    │   └── prod
    ├── zesty-zapus
    │   ├── dev
    │   └── prod

To get all environments containing ``dev`` word:

.. code-block:: bash

    $ lsenv dev
    trusty-tahr/dev
    zesty-zapus/dev

To get all ``trusty`` envs, you can either filter by ``trusty`` (or ``tahr``, or ``hr``, or ``t``):

.. code-block:: bash

    $ lsenv hr
    trusty-tahr/dev
    trusty-tahr/prod

or, list envs in ``./trusty-tahr`` dir:

.. code-block:: bash

    $ lsenv ./trusty-tahr
    trusty-tahr/dev
    trusty-tahr/prod

Combine it:

.. code-block:: bash

    $ lsenv trusty-tahr pr
    trusty-tahr/prod

or with several keywords:

.. code-block:: bash

    $ lsenv z d
    zesty-zapus/dev



``envie find`` / ``findenv [DIR]`` - Find the closest virtual env around ``DIR``
--------------------------------------------------------------------------------

::

    Find and list all virtualenvs below DIR, or above if none found below.
    List of virtualenv paths returned is optionally filtered by KEYWORDS.

    Usage:
        findenv [-f|-l] [DIR] [--] [KEYWORDS]
        envie find ...

    Options:
        -f, --find    use only 'find' for search
        -l, --locate  use only 'locate' for search
                      (by default, try find for 0.4s, then failback to locate)
        -v            be verbose: show info messages
        -q            be quiet: suppress error messages

    For details on other Envie uses, see 'envie help'.


Similar to ``envie list``, but with a key distinction: if no environments are
found below the starting ``DIR``, the search is being expanded -- level by level
up -- until at least one virtual environment is found.

Description of discovery methods (``--find``/``--locate``), as well as keywords
filtering behaviour given for ``envie list``/``lsenv`` apply here also.



.. _envie-python:

``envie python`` / ``envie SCRIPT`` - Run Python SCRIPT in its closest environment
----------------------------------------------------------------------------------


.. _envie-run:

``envie run COMMAND`` - Run COMMAND in the closest environment
--------------------------------------------------------------


.. _envie-config:

``envie config`` - Configure Envie
-----------------------------------


.. _envie-index:

``envie index`` - (Re-)Index Environments
-----------------------------------------

