from __future__ import print_function
import sys
import os.path
import subprocess


class EnvieError(Exception):
    """Envie-specific errors."""


def _guess_caller_path():
    """Since we are a module, we can't use ``__file__`` to determine a starting
    directory for the closest environment search. But we can try with the
    ``sys.argv[0]``, if the value has not been manipulated before a call to
    envie. It should contain a path to the script executed, or ``-c``, or be 
    empty when called with ``python -c '...'``/``'...prog...' | python``.
    """

    if len(sys.argv) < 1:
        return '.'
    argv = sys.argv[0]
    if argv == '-c' or argv == '':
        return '.'
    return os.path.dirname(os.path.abspath(argv))


# execfile equivalent for python3
try:
    _execfile = execfile
except NameError as exc:
    def _execfile(path):
        with open(path) as f:
            code = compile(f.read(), path, 'exec')
            exec(code, dict(__file__=path))


def activate():
    """Looks for and then activates the closest virtual environment,
    but only if a single closest env is found.
    """

    cwd = _guess_caller_path()
    try:
        output = subprocess.check_output(
            'envie find -f -q "%s"' % cwd, shell=True).decode('ascii').strip('\n')

        envs = output.split('\n')
        if len(envs) < 1:
            raise EnvieError("No virtual environments find in the vicinity.")
        elif len(envs) > 1:
            raise EnvieError("Found more than one virtual environment.")
        envpath = envs[0]

    except subprocess.CalledProcessError as exc:
        raise EnvieError("Failed to look for the closest virtual "\
                         "environment via envie command.")

    activate_this = os.path.join(envpath, 'bin/activate_this.py')
    if not os.path.isfile(activate_this):
        raise EnvieError(
            "Invalid virtual environment found (%s is missing)" % activate_this)

    _execfile(activate_this)

