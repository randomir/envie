#!/usr/bin/env python
from __future__ import print_function
from setuptools import setup
from setuptools.command.install import install as _install
import subprocess

class install(_install):
    def run(self):
        _install.do_egg_install(self)
        err = subprocess.call('echo "source `which envie.sh`" >> ~/.bashrc', shell=True)
        if not err:
            print("envie.sh added to ~/.bashrc")
            print("Open new shell, or run: 'source ~/.bashrc'.")

setup(
    name='envie',
    version='0.3.3',
    description="Bash helpers for navigating and managing Python VirtualEnvs.",
    long_description=open('README.md').read(),
    author='Radomir Stevanovic',
    author_email='radomir.stevanovic@gmail.com',
    url='https://github.com/randomir/envie',
    license='MIT',
    classifiers=[
        'Development Status :: 5 - Production/Stable',
        'Intended Audience :: Developers',
        'Programming Language :: Unix Shell',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX',
        'Topic :: Utilities',
        'Topic :: System :: Shells'
    ],
    keywords='virtualenv bash helper closest virtual environment create mkenv destroy rmenv change cdenv',
    scripts=['envie.sh'],
    #cmdclass={'install': install}
)
