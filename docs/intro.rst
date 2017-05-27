Quick start
===========

Start by installing Envie. You can install it system-wide (for all users) with:

.. code-block:: bash

    # system-wide install
    sudo pip install envie

or, if you prefer keeping it user-local, or just trying it out from the source
without installing, please take a look at :ref:`setup-install` instructions.

After installing, configuring is recommended, *but not required*. You can run a
quick interactive config with:

.. code-block:: bash

    # short step-by-step interactive configuration
    envie config

At bare minimum, grant yourself at least bash completions and better experience
by :ref:`registering Envie <minimum-config>` (sourcing it in your ``.bashrc``).
For details, see :ref:`setup-config`.

After Envie is configured, open a new shell, or simply source your ``.bashrc``:

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
        envie {create [ENV] | remove | list [DIR] [KEYWORDS] | find [DIR] [KEYWORDS] |
               python [SCRIPT] | run CMD | config | index | help | --help | --version}

    Commands:
        python SCRIPT  run Python SCRIPT in the closest environment
        run CMD        execute CMD in the closest environment. CMD can be a
                       script file, command, builtin, alias, or a function.

        create [ENV]   create a new virtual environment (alias for mkenv)
        remove         destroy the active environment (alias for rmenv)

        list [DIR]     list virtual envs under DIR (alias for lsenv)
        find [DIR]     like 'list', but also look above, until env found (alias for findenv)

        config         interactively configure Envie
        index          (re-)index virtualenvs under custom basedir (default: $HOME)
        --help, help   this help
        --version      version info

    The first form is basically an alias for 'chenv -v [DIR] [KEYWORDS]'. It interactively
    activates the closest environment (relative to DIR, or cwd, filtered by KEYWORDS).
    If a single closest environment is detected, it is auto-activated.

    The second form is a shorthand for executing python scripts in the closest 
    virtual environment, without the need for a manual env activation. It's convenient
    for hash bangs:
        #!/usr/bin/env envie
        # Python script here will be executed in the closest virtual env

    The third form exposes explicit commands for virtual env creation, removal, discovery, etc.
    For more details on a specific command, see its help with '-h', e.g. 'envie find -h'.
    Each of these commands has a shorter alias (mkenv, lsenv, findenv, chenv, rmenv, etc).

    Examples:
        envie python               # run interactive Python shell in the closest env
        envie manage.py shell      # run Django shell in the project env (auto activate)
        envie run /path/to/exec    # execute an executable in the closest env
        envie ~ my cool project    # activate the env with words my,cool,project in its path,
                                   # residing somewhere under your home dir (~)
        mkenv -3r dev-requirements.txt devenv    # create Python 3 virtual env in ./devenv and
                                                 # install pip packages from dev-requirements.txt
        mkenv -ta && pytest && rmenv -f          # run tests in a throw-away env with packages
                                                 # from the closest 'requirements.txt' file


Detailed :doc:`commands reference <commands>` is available.