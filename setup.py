#!/usr/bin/env python
import re
from setuptools import setup

def parse_envie_version():
    for line in open('scripts/envie').readlines():
        m = re.match(r'^_ENVIE_VERSION="([^"]+)"$', line)
        if m:
            return m.group(1)

setup(
    name='envie',
    version=parse_envie_version(),
    description="Bash helpers for navigating and managing Python VirtualEnvs.",
    long_description=open('README.rst').read(),
    author='Radomir Stevanovic',
    author_email='radomir.stevanovic@gmail.com',
    url='https://github.com/randomir/envie',
    license='MIT',
    packages=['envie'],
    package_dir={'envie': 'envie'},
    classifiers=[
        'Development Status :: 4 - Beta',
        'Intended Audience :: Developers',
        'Programming Language :: Python',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 2.6',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Unix Shell',
        'License :: OSI Approved :: MIT License',
        'Operating System :: POSIX',
        'Topic :: Utilities',
        'Topic :: System :: Shells'
    ],
    keywords='virtualenv bash helper closest virtual environment create mkenv destroy rmenv change chenv activate discover find findenv list lsenv cdenv',
    scripts=['scripts/envie', 'scripts/envie-tmp', 'scripts/envie-tools']
)
