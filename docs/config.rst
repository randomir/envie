Configuration
=============

Envie configuration is stored in a config file: ``$HOME/.config/envie/envierc``
as a series of shell variables. The file can be (re-)generated with a guided
quick-start script::

    envie config

If not sure, to all questions answer with the default (press ``Enter``)::

    Add to ~/.bashrc (strongly recommended) [Y/n]? 
    Use locate/updatedb for faster search [Y/n]? 
    Common ancestor dir of all environments to be indexed [/home/stevie]: 
    Update index periodically (every 15min) [Y/n]? 
    Refresh stale index before each search [Y/n]? 
    Envie already registered in /home/stevie/.bashrc.
    Config file written to /home/stevie/.config/envie/envierc.
    Crontab updated.
    Indexing environments in '/home/stevie'...Done.


The defaults
------------

``cat $HOME/.config/envie/envierc``::

    _ENVIE_DEFAULT_ENVNAME="env"
    _ENVIE_DEFAULT_PYTHON="python"
    _ENVIE_CONFIG_DIR="/home/stevie/.config/envie"
    _ENVIE_USE_DB="1"
    _ENVIE_DB_PATH="/home/stevie/.config/envie/locate.db"
    _ENVIE_INDEX_ROOT="/home/stevie"
    _ENVIE_CRON_INDEX="1"
    _ENVIE_CRON_PERIOD_MIN="15"
    _ENVIE_LS_INDEX="1"
    _ENVIE_FIND_LIMIT_SEC="0.4"
    _ENVIE_LOCATE_LIMIT_SEC="4"
    _ENVIE_UUID="28d0b2c7bc5245d5b1278015abc3f0cd"


Config variables
----------------

* ``_ENVIE_DEFAULT_ENVNAME`` - name of the virtual environment base directory. 
  The usual values are: ``env``, ``.env``, and ``.venv``.

* ``_ENVIE_DEFAULT_PYTHON`` - preferred Python interpreter. Use something like 
  ``python`` (the system default), ``python3`` (the default version of Python 3),
  or ``/usr/local/bin/python``.

* ``_ENVIE_USE_DB`` - should envie use ``locate``/``updatedb`` when looking for
  virtual environments on disk? (boolean: ``0``/``1``). Defaults to yes, but in 
  server environments you may be inclined to fall-back to ``find``-only approach.

* ``_ENVIE_DB_PATH`` - path to envie's local ``updatedb`` database.

* ``_ENVIE_INDEX_ROOT`` - root for ``updatedb`` index. Set it to a common 
  ancestor of your virtual environments. Defaults to ``$HOME``, but you may want
  to set it to something like ``/srv``, or ``/``.

* ``_ENVIE_CRON_INDEX`` - should envie refresh its ``updatedb`` database with a
  periodic cron job? (boolean: ``0``/``1``). If the appropriate question during
  ``envie config`` is answered affirmatively, user-local cron job is added with
  ``crontab``.

* ``_ENVIE_CRON_PERIOD_MIN`` - database refresh period (1-60 minutes).

* ``_ENVIE_LS_INDEX`` - should envie initiate ``updatedb`` upon each environment
  search with ``lsenv``/``envie list``/``envie find``/``envie go`` if the index
  is older than ``_ENVIE_LOCATE_LIMIT_SEC`` seconds? (boolean: ``0``/``1``).

* ``_ENVIE_FIND_LIMIT_SEC`` - limit in seconds on execution time for ``find``
  when searching for environments, if a locate database is used.

* ``_ENVIE_LOCATE_LIMIT_SEC`` - max allowed age for locate database, in seconds.
  If database is older than this, index rebuild is called if 
  ``_ENVIE_LS_INDEX=1``, or a warning message is displayed.
