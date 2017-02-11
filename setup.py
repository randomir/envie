#!/usr/bin/env python
from __future__ import print_function
from setuptools import setup
from setuptools.command.install import install as _install
import subprocess

setup(
    name='envie',
    version='0.4.4',
    description="Bash helpers for navigating and managing Python VirtualEnvs.",
    long_description=open('README.rst').read(),
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
    scripts=['envie']
)
