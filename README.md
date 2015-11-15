# Shell-based helpers for Python VirtualEnv

The `shenv` is an ultra lightweight set of Bash functions aiming to increase
your productivity when dealing with everyday VirtualEnv tasks, like: creating,
destroying, listing and switching environments.

## Examples

### Create/destroy

To create a new VirtualEnv in the current directory, just type `mkenv <envname>`. 
This results with new environment created and activated in `./<envname>`.
When done with this environment, just type `rmenv` to destroy the active env.

```sh
stevie@caracal:~/demo$ ls
stevie@caracal:~/demo$ mkenv env
Running virtualenv with interpreter /usr/bin/python2
New python executable in ./bin/python2
Also creating executable in ./bin/python
Installing setuptools, pip...done.
/home/stevie/demo
(env)stevie@caracal:~/demo$ ls
env
(env)stevie@caracal:~/demo$ pip freeze
argparse==1.2.1
wsgiref==0.1.2
(env)stevie@caracal:~/demo$ rmenv
stevie@caracal:~/demo$ ls
stevie@caracal:~/demo$
```

### Change/activate environment

Use `cdenv` to activate the closest environment, tree-wise. We first look 
down the tree, then up the tree. If a single Python environment is found,
it's automatically activated. In case the multiple environments are found,
a choice is presented to user.

```sh
stevie@caracal:~/demo$ ls -F
env/ project/ file1 file2 ...
stevie@caracal:~/demo$ cdenv
(env)stevie@caracal:~/demo$
```

Assume the following tree exists:
```
~/demo
  |_ project1
  |  |_ env
  |  |  |_ ...
  |  |_ src
  |     |_ ...
  |_ project2
  |  |_ env
  |     |_ ...
```

Now, consider you work in `~/demo/project1/src/deep/path/to/module`, but keep the environment
in the `env` parallel to `src`. Instead of manually switching to `env` and activating it with 
something like `source ../../../../../env/bin/activate`, just type `cdenv` (`cde<TAB>` should
actually do it, if you use tab completion):
```sh
stevie@caracal:~/demo/project1/src/deep/path/to/module$ cdenv
(env)stevie@caracal:~/demo/project1/src/deep/path/to/module$ which python
/home/stevie/demo/project1/env/bin/python
```

On the other hand, if there are multiple environments to choose from, you'll get a prompt:
```sh
stevie@caracal:~/demo$ cdenv
1) ./project1/env
2) ./project2/env
#? 2
(env)stevie@caracal:~/demo$ which python
/home/stevie/demo/project2/env/bin/python
```

## Install

Clone the repo and source the `functions.sh` file from your `.bashrc`.

```
~$ git clone https://github.com/randomir/shenv
~$ echo . ~/shenv/functions.sh >> ~/.bashrc
```
