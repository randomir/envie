#!/usr/bin/env python
from __future__ import print_function
import os
import subprocess

def activate(start_dir=None):
    """Looks for and then activates the closest virtual environment, but only 
    if a single closest env is found."""
    
    try:
        output = subprocess.check_output("envie find -f -q", shell=True).strip('\n')
        if not output:
            return 1
        envs = output.split('\n')
        if len(envs) != 1:
            return 2
        envpath = envs[0]
    except subprocess.CalledProcessError as exc:
        return 1

    activate_this = os.path.join(envpath, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
