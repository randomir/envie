Setup
=====


.. _setup-install:

Install
-------

For convenience, Envie is packaged and distributed via `PyPI <https://pypi.python.org/pypi/envie>`_
as a Python package named ``envie``. Full source code is available on `GitHub <https://github.com/randomir/envie>`_.

You can install Envie in several ways.


1. System-wide install via pip
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The simplest and in most cases the recommended way of installing Envie is via
pip global install::

    sudo pip install envie

All executable Envie scripts (``envie``, ``envie-tmp`` and ``envie-tools``) will
be installed in system ``/usr/local/bin/`` directory and will be available to
all users of the system.

.. tip::

    You can check if Envie is properly installed with::

        $ envie --version
        Envie 0.4.33 command from /usr/local/bin/envie

    Actually, with this command you can also check if Envie is being run as a
    **command**, or as a **function**. Almost always you want ``envie`` to be a
    function -- otherwise you won't be able to easily activate virtual
    environments discovered. See :ref:`setup-config`.


2. User-local install via pip
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To install to the Python **user install** directory (typically ``~/.local``)::

    pip install --user envie

This is as a good option if you do not wish to (or can not) install Envie for
all users. Executable scripts will be located in your ``$HOME/.local/bin/``
directory.

If you're not already using other CLI tools installed this way, you'll have
to configure your ``PATH`` to make ``envie`` executable accessible. Add this
to your ``~/.bashrc``::

    export PATH="$PATH:$HOME/.local/bin"


3. Manual install from source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Clone with ``git``::

    git clone https://github.com/randomir/envie.git ~/Downloads/envie-master

or download a `zip archive <https://github.com/randomir/envie/archive/master.zip>`_.

After cloning/downloading, you have to either:

  (a) **Source** ``scripts/envie``, like this::

          . ~/Downloads/envie-master/scripts/envie

      Now you'll be running Envie **as a function**, check it out::

          $ envie --version
          Envie 0.4.33 function from /home/stevie/Downloads/envie-master/scripts/envie

      To ensure ``envie`` function is always available, add the sourcing statement to
      your ``.bashrc``, or simply run::

          envie config --register

      Also, be sure to check how to :ref:`setup-config` other aspects of Envie.

or

  (b) **Symlink** ``scripts/envie`` executable to your (local) bin directory, for example::

          ln -s ~/Downloads/envie-master/scripts/envie ~/bin/envie

      This assumes your ``PATH`` already includes ``~/bin/``. If not, add it just like
      above, by appending ``export PATH="$PATH:$HOME/bin"`` to your ``~/.bashrc``.

.. important::

    When manually installing Envie as a **command** -- and not a function,
    symlinking ``envie`` executable to a ``PATH``-discoverable
    location is a MUST. Otherwise Envie command **will not** function properly.

    The reason you have to symlink, and not just copy is, ultimately,
    cross-platform support and :ref:`fuzzy environment name filtering <fuzzy-filtering>`.
    Namely, cross-platform implementation of some basic tools (GNU ``readlink``,
    ``realpath``) and fuzzy-filtering is provided via Python package ``envie``
    (module ``envie.filters``). When Envie is pip-installed, this package is
    available -- but when running from source, Envie has to be able to locate it
    (relative to the ``envie`` executable).

.. hint::

    An important exception to the symlinking note above is when you know you'll be
    running Envie **only as a function**, never as a command (*Hint: you probably
    only want it as a function*).



.. _setup-config:

Configure
---------

Envie configuration is stored in a config file: ``$HOME/.config/envie/envierc``,
as a series of shell variables assignments. It is read once per sourcing or
execution. In the default setup (when Envie is sourced from ``.bashrc``), that
means the configuration is read once per Bash session.

Configuration file can be (re-)generated with a guided quick-start script::

    envie config

If you are installing/configuring Envie on a dev machine, you're probably safe
to answer all questions with the default (pressing ``Enter``)::

    Add to ~/.bashrc (strongly recommended) [Y/n]? 
    Use locate/updatedb for faster search [Y/n]? 
    Common ancestor dir of all environments to be indexed [/home/stevie]: 
    Update index periodically (every 15min) [Y/n]? 
    Refresh stale index before each search [Y/n]? 

    Envie added to /home/stevie/.bashrc.
    Config file written to /home/stevie/.config/envie/envierc.
    Crontab updated.
    Indexing environments in '/home/stevie'...Done.

.. tip::
  In a production/server environment, you maybe do not want to use *locate*
  method and run cron updatedb jobs every 15min.

  Actually, you **can** still use *locate*, but rebuild the index manually with
  ``envie index`` (when deemed necessary), or instruct Envie to *"refresh stale
  index before each search"*.



.. _no-config:

The unconfigured mode
^^^^^^^^^^^^^^^^^^^^^

When you run Envie without explicitly configuring it, a set of safe
:ref:`defaults <default-config>` will be used. Most notably, only ``find``
method will be used for environments discovery.



.. _source-vs-exec:

Sourcing vs. Executing
^^^^^^^^^^^^^^^^^^^^^^

Envie can be run directly (by executing ``envie`` script), or as a shell
function (which is defined when ``envie`` script is sourced).

Either way you chose to run Envie, it will behave the same -- with one notable
exception:

.. warning::
  If Envie is **not run as a function**, it will **not be able to activate a
  virtual environment**.

The effects of this will be visible in two scenarios:

``envie create``/``mkenv``
  Environment will be created, and requirements/packages will be installed, but
  virtualenv will not be activated in your current shell.

``envie``/``chenv``
  Environments will be listed/selected, but it will not be activated in the
  current shell.



.. _minimum-config:

A reasonable minimum
^^^^^^^^^^^^^^^^^^^^

However you decide on *locate* and crontab index updating, the simplest fully
functional (bash completions included) and minimal-performance-overhead
configuration is achieved with::

    envie config --register

This will add Envie sourcing statement to your ``.bashrc`` and ensure you have
a working ``envie`` function, along with the accompanying shorthand aliases like
``mkenv``, ``lsenv``, etc.



.. _default-config:

The defaults
^^^^^^^^^^^^

``cat $HOME/.config/envie/envierc``::

    _ENVIE_DEFAULT_ENVNAME="env"
    _ENVIE_DEFAULT_PYTHON="python"
    _ENVIE_CONFIG_DIR="$HOME/.config/envie"
    _ENVIE_USE_DB="1"
    _ENVIE_DB_PATH="$HOME/.config/envie/locate.db"
    _ENVIE_INDEX_ROOT="$HOME"
    _ENVIE_CRON_INDEX="1"
    _ENVIE_CRON_PERIOD_MIN="15"
    _ENVIE_LS_INDEX="1"
    _ENVIE_FIND_LIMIT_SEC="0.4"
    _ENVIE_LOCATE_LIMIT_SEC="4"
    _ENVIE_UUID="28d0b2c7bc5245d5b1278015abc3f0cd"



Config variables
^^^^^^^^^^^^^^^^

``_ENVIE_DEFAULT_ENVNAME``
  Name of the virtual environment base directory.
  The usual values are: ``env``, ``.env``, ``.venv``, and ``pythonenv``.

``_ENVIE_DEFAULT_PYTHON``
  Preferred Python interpreter. Use something like ``python`` (the system default),
  ``python3`` (the default version of Python 3), or ``/usr/local/bin/python3.6``.

``_ENVIE_USE_DB``
  Should Envie use ``locate``/``updatedb`` when looking for virtual environments
  on disk? (boolean: ``0``/``1``). Defaults to yes, but in server environments you
  may be inclined to fall-back to ``find``-only approach. Please note you still
  may use the ``locate`` approach with manual or on-demand indexing.

``_ENVIE_DB_PATH``
  Path to Envie's local ``updatedb`` database.

``_ENVIE_INDEX_ROOT``
  Root dir for ``updatedb`` index. Set it to a common ancestor of all virtual
  environments **you wish to index**. Defaults to ``$HOME``, but you may want
  to set it to something like ``/srv``, ``/var/www``, or even ``/``. Note that
  this setting does not affect the ``find`` search.

``_ENVIE_CRON_INDEX``
  Should Envie refresh its ``updatedb`` database with a periodic cron job?
  (boolean: ``0``/``1``). If the appropriate question during ``envie config``
  is answered affirmatively, an user-local cron job is added with ``crontab``.

``_ENVIE_CRON_PERIOD_MIN``
  Database refresh period (1-60 minutes).

``_ENVIE_LS_INDEX``
  Should Envie initiate ``updatedb`` upon each environment search with
  ``lsenv``/``envie list``/``findenv``/``envie find``/``chenv``/``envie``
  if the index is older than ``_ENVIE_LOCATE_LIMIT_SEC`` seconds?
  (boolean: ``0``/``1``).

``_ENVIE_FIND_LIMIT_SEC``
  Limit in seconds on execution time for ``find`` when searching for
  environments, if a locate database is used.

``_ENVIE_LOCATE_LIMIT_SEC``
  Max. allowed age for locate database, in seconds. If database is older than
  this, index rebuild is called if ``_ENVIE_LS_INDEX=1``, or a warning message
  is displayed otherwise.
