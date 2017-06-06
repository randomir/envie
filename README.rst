Navigate and manage Python virtual environments
===============================================

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

*Envie* is a set of shell utilities (in ``bash``) aiming to increase your productivity
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

To activate the closest virtual environment in vicinity, just type ``envie`` (Fig 1.a and 1.c):

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


Terse & pip-infused create
..........................

Sure, you can use ``virtualenv --python=python3 --no-site-packages env``, but isn't this simpler?

.. code-block:: bash

    $ envie create -3
    
    # or, shorter:
    $ mkenv3

And how about also **installing** your **pip requirements** in one go?

.. code-block:: bash

    $ mkenv -r dev-requirements.txt env/dev

Or, creating a **temporary/throw-away** environment **with** some **packages** installed, then
hacking in an interactive Python session, and finally destroying the complete environment upon exit:

.. code-block:: bash

    $ mkenv -t -p requests -p 'plucky>=0.4' && python && rmenv -f

Details and more examples are available in `envie create`_, `envie remove`_, and `envie-tmp`_ docs.


Discovery
.........

Activation of the closest environment is predicated on the discovery of the existing virtual
environments below a certain directory with ``lsenv`` (`envie list`_), and on the up-the-tree
search with ``findenv`` (`envie find`_):

.. code-block:: bash

    ~/work$ lsenv
    plucky/env
    blog/.env
    jsonplus/django/env/dev
    ...


.. _chenv: http://envie.readthedocs.io/en/latest/commands.html#chenv
.. _fuzzy-filtering: http://envie.readthedocs.io/en/latest/commands.html#fuzzy-filtering
.. _`envie create`: http://envie.readthedocs.io/en/latest/commands.html#mkenv
.. _`envie remove`: http://envie.readthedocs.io/en/latest/commands.html#rmenv
.. _`envie-tmp`: http://envie.readthedocs.io/en/latest/commands.html#envie-tmp
.. _`envie list`: http://envie.readthedocs.io/en/latest/commands.html#lsenv
.. _`envie find`: http://envie.readthedocs.io/en/latest/commands.html#findenv


Install & configure
-------------------

For convenience, ``envie`` is packaged and distributed as a Python package.
You can install it system-wide with: (for user-local / source install, see `Install`_ in docs):

.. code-block:: bash

    $ sudo pip install envie
    $ envie config

    # start clean:
    $ . ~/.bashrc
    
    # or, open a new shell

After install, be sure to run a (short and interactive) `configuration`_ procedure with ``envie config``.
If in doubt, go with the defaults. Running config is optional, but it will allow you
to add Envie sourcing statement to ``.bashrc`` (enabling Bash completion and alias
functions), and to enable environments indexing (faster search with ``locate``).

.. _Install: http://envie.readthedocs.io/en/latest/setup.html#install
.. _configuration: http://envie.readthedocs.io/en/latest/setup.html#configure


Enable index
............

By default, ``envie`` uses the ``find`` command to search for environments. That
approach is pretty fast when searching shallow trees. However, if you have a
deeper directory trees, it's often faster to use a pre-built directory index
(i.e. the ``locate`` command). To enable a combined ``locate/find`` approach to
search, run ``envie config``.

When index is enabled, the combined approach is used by default (if not overriden with
``-f`` or ``-l`` switches). In the combined approach, if ``find`` doesn't finish
within 400ms, search via ``find`` is aborted and ``locate`` is allowed to finish
(faster).


Testing
.......

Run all test suites locally with::

    $ make test

(after cloning the repo.)


Usage in short
--------------

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
    Run Python ``script`` in the closest virtual environment.

``envie run <command>``
    Execute arbitrary ``command/builtin/file/alias/function`` in the closest virtual environment.

``envie-tmp <script>``
    Create a new temporary (throw-away) virtual environment, install requirements specified inside the ``<script>`` file, run the ``<script>``, and destroy the environment afterwards.

``envie config``
    Interactively configure Envie.

``envie index``
    (Re-)index virtual environments (for faster searches with ``locate``).

``envie help``
    Print usage help. For details on a specific command use the ``-h`` switch (like ``envie find -h``, or ``mkenv -h``).


Documentation
-------------

Documentation is hosted by ReadTheDocs, latest version being available at `envie.rtfd.io <http://envie.rtfd.io/>`_.
