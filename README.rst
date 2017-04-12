Navigate and manage Python VirtualEnvs
======================================

.. image:: https://img.shields.io/pypi/v/envie.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/badge/platform-linux-red.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/badge/shell-bash-blue.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/pypi/pyversions/envie.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://api.travis-ci.org/randomir/envie.svg?branch=master
    :target: https://travis-ci.org/randomir/envie

----

At its core, ``envie`` is a set of Bash functions aiming to increase your
productivity when dealing with mundane VirtualEnv tasks, like: creating,
destroying, listing, switching and activating environments.

But ``envie`` really shines when it comes to auto-discovery, auto-activation
and auto-creation of VirtualEnvs relevant to your project (or executable).
Just say:

.. code-block:: bash

    ~/work/projectA$ envie python tests.py
    
    ~/work/projectB$ envie manage.py migrate

    ~$ envie run python -c 'import os; print(os.getenv("VIRTUAL_ENV"))'

or use it in a hash bang:

.. code-block:: python

    #!/usr/bin/env envie

or, just import it at the beginning of your Python program:

.. code-block:: python

    #!/usr/bin/python
    import envie.require

and in each of these cases the Python script will be executed in the closest
virtual environment (for the definition of the *closest environment* see below,
section `Change/activate environment`).

To just activate the closest virtual env, just type ``envie``:

.. code-block:: bash

    ~/work/my-project-awesome-cattoy$ envie

or even:

.. code-block:: bash

    $ envie awesome toy

(keywords filter all virtual envs in vicinity and activate the best match - if unique;
if not unique you're prompted to select the exact environment you wish to activate)


Summary
-------

- ``envie`` / ``chenv [-1] [-f|-l] [-q] [-v] [<basedir>] [<keywords>]`` - Interactively activate the closest environment (looking down, then up, with ``lsupenv``), optionally filtered by a list of ``<keywords>``. Start looking in ``<basedir>`` (defaults to ``.``).
- ``envie create`` / ``mkenv [-2|-3|-e <pyexec>] [-r <pip_req>] [-p <pip_pkg>] [-a] [<envdir> | -t] -- [virtualenv opts]`` - Create virtualenv in ``<envdir>`` (or in temporary dir, ``-t``) based on Python version ``<pyexec>``, optionally install Pip packages from ``<pip_req>`` requirements file and ``<pip_pkg>`` package specifier.
- ``envie remove`` / ``rmenv`` - Destroy the active environment.
- ``envie list`` / ``lsenv [-f|-l] [<dir>|"." [<avoid>]]`` - List all environments below ``<dir>`` directory, skipping ``<avoid>`` subdir.
- ``envie find`` / ``lsupenv [-f|-l] [<dir>|"."]`` - Find the closest environments by first looking down and then dir-by-dir up the tree, starting with ``<dir>``.
- ``envie python <script>``, ``envie <script>`` - Run python ``script`` in the closest virtual environment.
- ``envie run <command>`` - Execute arbitrary ``command/builtin/file/alias/function`` in the closest virtual environment.
- ``envie config`` - Interactively configure envie.
- ``envie index`` - (Re-)index virtual environments (for faster searches with ``locate``).
- ``envie help`` - Print usage help. For details on a specific command use the '-h' switch (like ``envie find -h``, or ``mkenv -h``).
- ``cdenv`` - ``cd`` to the base dir of the currently active virtualenv (``$VIRTUAL_ENV``).


Install & configure
-------------------

For convenience, ``envie`` is packaged and distributed as a Python package. To
install, simply type::

    $ sudo pip install envie
    $ envie config

    # start clean:
    $ . ~/.bashrc
    
    # or, open a new shell

After install, be sure to run a (short and interactive) configuration procedure with ``envie config``.
If in doubt, go with the defaults.

By default, ``envie`` sourcing statement is added to your ``.bashrc`` file, ``locate`` 
index is set as a preferred source (it's set to be rebuilt every 15m, or on demand),
with all relevant environments' ancestor dir set to your ``$HOME`` directory.


Testing
.......

Run all test suites locally with::

    $ make test

(after cloning the repo.)


Examples
--------

Create/destroy
..............

To create a new VirtualEnv in the current directory, just type ``mkenv <envname>``. 
This results with new environment created and activated in ``./<envname>``.
When done with this environment, just type ``rmenv`` to destroy the active env.

::

    stevie@caracal:~/demo$ ls
    stevie@caracal:~/demo$ mkenv env
    Creating python environment in 'env'.
    Using Python 2.7.9 (/usr/bin/python).
    (env)stevie@caracal:~/demo$ ls
    env
    (env)stevie@caracal:~/demo$ pip freeze
    argparse==1.2.1
    wsgiref==0.1.2
    (env)stevie@caracal:~/demo$ rmenv
    stevie@caracal:~/demo$ ls
    stevie@caracal:~/demo$

Create Python 3 environment in ``env`` and install pip packages from
``requirements.txt``::

    $ mkenv3 -r requirements.txt

Create a throw-away environment with a pre-installed ``dev-requirements.txt`` and
a local project in editable mode from ``/home/stevie/work/mypackage/``::

    $ mkenv -t -r dev-requirements.txt -p "-e /home/stevie/work/mypackage/"

To automate the previous example, you can use ``envie-oneoff`` command in your hashbang,
like this::

    #!/usr/bin/env envie-oneoff
    # -*- requirements: ./path/to/my/requirements.txt -*-

    <your python code here>

When executed, a throw-away virtualenv is created, requirements specified are
installed inside, code is run, and the environment is destroyed afterwards.
Other way to do it is directly: ``envie-oneoff SCRIPT``.


Change/activate environment
...........................

Use ``envie`` (base command), or the explicit ``chenv`` to activate the closest 
environment, tree-wise. We first look down the tree, then up the tree. 
If a single Python environment is found, it's automatically activated. 
In case the multiple environments are found, a choice is presented to user.

::

    stevie@caracal:~/demo$ ls -F
    env/ project/ file1 file2 ...
    stevie@caracal:~/demo$ envie
    (env)stevie@caracal:~/demo$

Assume the following tree exists::

    ~/demo
      |_ project1
      |  |_ env
      |  |  |_ ...
      |  |_ src
      |     |_ ...
      |_ project2
      |  |_ env
      |     |_ ...

Now, consider you work in ``~/demo/project1/src/deep/path/to/module``, but keep the environment
in the ``env`` parallel to ``src``. Instead of manually switching to ``env`` and activating it with 
something like ``source ../../../../../env/bin/activate``, just type ``envie`` (or ``chenv``)::

    stevie@caracal:~/demo/project1/src/deep/path/to/module$ envie
    (env)stevie@caracal:~/demo/project1/src/deep/path/to/module$ which python
    /home/stevie/demo/project1/env/bin/python

On the other hand, if there are multiple environments to choose from, you'll get a prompt::

    stevie@caracal:~/demo$ envie
    1) ./project1/env
    2) ./project2/env
    3) ./projectx/env
    #? 2
    (env)stevie@caracal:~/demo$ which python
    /home/stevie/demo/project2/env/bin/python

If you know the name of your project (some specific path components -- `keywords`), you can
preemptively filter, and auto-activate the project environment with::

    stevie@caracal:~/demo$ envie x
    (env)stevie@caracal:~/demo$ which python
    /home/stevie/demo/projectx/env/bin/python


Search/list environments
........................

To search down the tree for valid Python VirtualEnvs, use ``lsenv``.
Likewise, to search up the tree, level by level, use ``lsupenv``.
``chenv`` uses ``lsupenv`` when searching for environment to activate.



Enable faster search
--------------------

By default, ``envie`` uses the ``find`` command to search for environments. That
approach is pretty fast when searching shallow trees. However, if you have a
deeper directory trees, it's often faster to use a pre-built directory index
(i.e. the ``locate`` command). To enable a combined ``locate/find`` approach to
search, run ``envie config``::

    $ envie config
    Add to ~/.bashrc (strongly recommended) [Y/n]?
    Use locate/updatedb for faster search [Y/n]?
    Common ancestor dir of all environments to be indexed [/]:
    Update index periodically (every 15min) [Y/n]?
    Refresh stale index before each search [Y/n]?
    Envie already registered in /home/stevie/.bashrc.
    Config file written to /home/stevie/.config/envie/envierc.
    Crontab updated.
    Indexing environments in '/'...Done.

From now on, the combined approach is used by default (if not overriden with
``-f`` or ``-l`` switches). In the combined approach, if `find` doesn't finish
within 400ms, search via ``find`` is aborted and ``locate`` is allowed to finish
(faster).
