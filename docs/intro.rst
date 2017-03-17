Quick start
===========

Install
-------

::

    sudo pip install envie


Configuration
-------------

::

    envie config

For details, see :doc:`config`.

After envie is configured, source your ``.bashrc``, or start a fresh shell:

.. code-block:: bash

    . ~/.bashrc


Start with ``envie help``
-------------------------

::

    Your virtual environments wrangler. Holds no assumptions on virtual env dir
    location in relation to code, but works best if they're near (nested or in level).

    Usage:
        envie [OPTIONS] [DIR] [KEYWORDS]
        envie SCRIPT
        envie {create [ENV] | remove | list [DIR] | find [DIR] | go [KEYWORDS] |
               python [SCRIPT] | run CMD | config | index | help}

    Commands:
        python SCRIPT  run Python SCRIPT in the closest environment
        run CMD        execute CMD in the closest environment. CMD can be a
                       script file, command, builtin, alias, or a function.

        create [ENV]   create a new virtual environment (alias for mkenv)
        remove         destroy the active environment (alias for rmenv)
        tmp            create a throw-away env in /tmp (alias for mkenv -t)

        list [DIR]     list virtual envs under DIR (alias for lsenv)
        find [DIR]     like 'list', but also look above, until env found (alias for lsupenv)
        go [KEYWORDS]  interactively activate the closest environment (alias for chenv)
                       (adaptively select the most relevant virtual env for list of KEYWORDS)

        config         interactively configure Envie
        index          (re-)index virtualenvs under /
        help           this help

    The first form is basically an alias for 'envie go -v [DIR] [KEYWORDS]'. It interactively
    activates the closest environment (relative to DIR, or cwd, filtered by KEYWORDS).
    If a single closest environment is detected, it is auto-activated.

    The second form is a shorthand for executing python scripts in the closest 
    virtual environment, without the need for a manual env activation. It's convenient
    for hash bangs:
        #!/usr/bin/env envie
        # Python script here will be executed in the closest virtual env

    The third form exposes explicit commands for virtual env creation, removal, discovery, etc.
    For more details on a specific command, see its help with '-h', e.g. 'envie find -h'.

    Examples:
        envie python               # run interactive Python shell in the closest env
        envie manage.py shell      # run Django shell in the project env (auto activate)
        envie run /path/to/exec    # execute an executable in the closest env
        envie ~ my cool project    # activate the env with words my,cool,project in its path,
                                   # residing somewhere under your home dir (~)
        mkenv -ta && ./setup.py test && rmenv -f     # run tests in a throw-away env (with reqs)
        envie tmp -a && ./setup.py test && envie remove -f   # more verbose version of the above
