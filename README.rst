Navigate and manage Python VirtualEnvs
======================================

.. image:: https://img.shields.io/pypi/v/envie.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/badge/platform-GNU/Linux,%20BSD,%20Darwin/OS%20X-red.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/badge/shell-bash-blue.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://img.shields.io/pypi/pyversions/envie.svg
    :target: https://pypi.python.org/pypi/envie

.. image:: https://api.travis-ci.org/randomir/envie.svg?branch=master
    :target: https://travis-ci.org/randomir/envie

----

*Envie* is a set of ``bash`` shell utilities aiming to increase your productivity
when dealing with mundane Python virtual environment tasks, like creating, destroying,
listing/discovering, and switching/activating environments.

Where Envie really shines is auto-discovery, auto-activation and auto-creation of
virtual envs relevant to your project (or executable). It holds no assumptions on
virtual env dir location in relation to your code, but works best if they're near
(nested, in level, or one level up).


Motivation
----------

I like to keep my virtual environments close to source (especially in production).
With hundreds of projects on disk, this enables me to keep environment dir names short
and relevant to project (since a project can sometimes have several environments,
e.g. dev, prod, test), and environments easier to maintain in general.

If you structure your files/projects in any of the ways depicted in Fig 1. below, you'll
find Envie particularly helpful.

::

    work                            work                                /srv
    │                               │                                   │
    ├── plucky                      ├── jsonplus                        ├── production
    │   ├── env       <--           │   ├── .git                        │   ├── website
    │   ├── plucky                  │   ├── django                      │   │   ├── pythonenv     <--
    │   ├── tests                   │   │   ├── env                     │   │   ├── var
    │   └── ...                     │   │   │   ├── dev      <--        │   │   └── src
    │                               │   │   │   └── prod     <--        :   :       ├── .git
    ├── blog                        │   │   ├── tests                   :   :       └── ...
    │   ├── .env      <--           │   │   │   ├── env      <--        .   .
    :   ├── .git                    :   :   :   ├── test_1.py
    :   ├── _posts                  :   :   :   └── ...
    .   └── ...                     .   .   .
    
    (a) env in level with src       (b) env nested under src           (c) env one level above src
    
    Figure 1. Several ways to keep your environments local to the code.


Easy activation
...............

To activate the closest virtual environment in vicinity, just type ``envie`` / chenv_ (Fig 1.a and 1.c):

.. code-block:: bash

    ~/work/plucky$ envie
    Activated virtual environment at 'env'.

    /srv/production/website/src$ envie
    Activated virtual environment at '../pythonenv'.

If several equally close environments are found (Fig 1.b), you'll be prompted to select
the exact env. But, you can avoid it with a cunning use of fuzzy-filtering_, for example:

.. code-block:: bash

    ~/work/jsonplus$ envie dev
    Activated virtual environment at 'django/env/dev'.

Discovery and filtering have no limits on depth, so you can activate your project environment like:

.. code-block:: bash

    ~$ envie jsonplus dev
    Activated virtual environment at 'work/jsonplus/django/env/dev'.

.. _chenv: http://envie.readthedocs.io/en/latest/commands.html#chenv
.. _fuzzy-filtering: http://envie.readthedocs.io/en/latest/commands.html#fuzzy-filtering


Implicit activation
...................

Sometimes you don't care about activating the relevant environment *in your shell*.
You just want your script to run in the correct env. Easy peasy (ref. Fig 1.b):

.. code-block:: bash

    ~/work/jsonplus$ envie ./django/tests/test_1.py
    Activated virtual environment at 'django/tests/env'.
    # running test ...

It doesn't have to be a Python script:

.. code-block:: bash

    ~/work/plucky$ envie run make test
    Activated virtual environment at 'env'.
    # running 'make' with python from env

And it works from a hash bang too:

.. code-block:: python

    #!/usr/bin/env envie

You can even activate the closest environment after the fact, from your Python program
(changing the environment from global to closest):

.. code-block:: python

    #!/usr/bin/python
    import envie.activate_closest


Usage Summary
-------------

``envie [-1] [-f|-l] [<basedir>] [<keywords>]`` (alias ``chenv``)
    Interactively activate the closest environment (looking down, then up, with ``findenv``), optionally filtered by a list of ``<keywords>``. Start looking in ``<basedir>`` (defaults to ``.``).

``envie create [-2|-3|-e <pyexec>] [-r <pip_req>] [-p <pip_pkg>] [-a] [<envdir> | -t]`` (alias ``mkenv``)
    Create virtual environment in ``<envdir>`` (or in a temporary dir, ``-t``) based on a Python interpreter ``<pyexec>``, optionally installing Pip requirements from ``<pip_req>`` file, and/or ``<pip_pkg>`` requirement specifier(s).

``envie remove`` (alias ``rmenv``)
    Destroy the active environment.

``envie list [-f|-l] [<dir>] [<keywords>]`` (alias ``lsenv``)
    List all environments below ``<dir>`` directory, optionally filtered with a list of ``<keywords>``.

``envie find [-f|-l] [<dir>] [<keywords>]`` (alias ``findenv``)
    Find the closest environments by first looking down and then dir-by-dir up the tree, starting in ``<dir>``; optionally filtered with a list of ``<keywords>``.

``envie <script>``, ``envie python <script>``
    Run python ``script`` in the closest virtual environment.

``envie run <command>``
    Execute arbitrary ``command/builtin/file/alias/function`` in the closest virtual environment.

``envie-tmp <script>``
    Create a new temporary (throw-away) virtual environment, install requirements specified inside the ``<script>`` file, run the ``<script>``, and destroy the environment afterwards.

``envie config``
    Interactively configure envie.

``envie index``
    (Re-)index virtual environments (for faster searches with ``locate``).

``envie help``
    Print usage help. For details on a specific command use the '-h' switch (like ``envie find -h``, or ``mkenv -h``).


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

To automate the previous example, you can use ``envie-tmp`` command in your hashbang,
like this::

    #!/usr/bin/env envie-tmp
    # -*- requirements: ./path/to/your/requirements.txt -*-

    <your python code here>

When executed, a throw-away virtualenv is created, requirements specified are
installed inside, code is run, and the environment is destroyed afterwards.
Other way to do it is directly: ``envie-tmp SCRIPT``.


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
    1) project1/env
    2) project2/env
    3) projectx/env
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
Likewise, to search up the tree, level by level, use ``findenv``.
``chenv`` uses ``findenv`` when searching for environment to activate.

Suppose in your ``work`` directory you have projects named ``trusty`` and ``zesty``.
And for both of them you keep ``dev`` and ``prod`` env::

    $ lsenv dev

    work/trusty/dev
    work/zesty/dev

or to activate trusty dev, all you need to type is::

    $ envie t d

    Activated virtual environment at 'work/trusty/dev'.


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
