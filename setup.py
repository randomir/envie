#!/usr/bin/env python
from setuptools import setup

setup(
    name='envie',
    version='0.4.17',
    description="Bash helpers for navigating and managing Python VirtualEnvs.",
    long_description=open('README.rst').read(),
    author='Radomir Stevanovic',
    author_email='radomir.stevanovic@gmail.com',
    url='https://github.com/randomir/envie',
    license='MIT',
    packages=['envie'],
    package_dir={'envie': 'envie'},
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
    scripts=['scripts/envie', 'envie/guessing_envie.py']
)
