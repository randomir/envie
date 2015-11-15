# Shell-based helpers for Python VirtualEnv

The `shenv` is an ultra lightweight set of Bash functions aiming to increase
your productivity when dealing with everyday VirtualEnv tasks, like: creating,
destroying, listing and switching environments.

## Examples

### Create/destroy

To create a new VirtualEnv in the current directory, just type `mkenv <envname>`. 
This results with new environment created and activated in `./<envname>`.
When done with this environment, just type `rmenv` to destroy the active env.

```
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

```
stevie@caracal:~/demo$ ls
env <project files...>
stevie@caracal:~/demo$ cdenv
(env)stevie@caracal:~/demo$
```
