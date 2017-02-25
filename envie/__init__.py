from __future__ import print_function
import os.path
import subprocess


class EnvieError(Exception):
    """Envie-specific errors."""


def activate(start_dir=None):
    """Looks for and then activates the closest virtual environment, but only 
    if a single closest env is found."""

    try:
        output = subprocess.check_output("envie find -f -q", shell=True).strip('\n')

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

    execfile(activate_this, dict(__file__=activate_this))
