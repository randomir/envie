# Navigate and manage Python VirtualEnvs

The `shenv` is an ultra lightweight set of Bash functions aiming to increase
your productivity when dealing with everyday VirtualEnv tasks, like: creating,
destroying, listing and switching environments.

## Summary

- `mkenv [<env>|"env"] [<pyexec>|"python"]` - Create virtualenv in `<env>` based on Python version `<pyexec>`.
- `rmenv` - Destroy the active environment.
- `cdenv` - Interactively activate the closest environment (looking down, then up, with `lsupenv`).
- `lsenv [<start>|"." [<avoid>]]` - List all environments below `<start>` directory, skipping `<avoid>` subdir.
- `lsupenv` - Find the closest environments by first looking down and then dir-by-dir up the tree, starting with cwd.
- `shenv_install` - Run (once) to enable (faster) searches with `locate`.
- `shenv_updatedb` - Run to re-index directories searched with `updatedb`.

## Examples

### Create/destroy

To create a new VirtualEnv in the current directory, just type `mkenv <envname>`. 
This results with new environment created and activated in `./<envname>`.
When done with this environment, just type `rmenv` to destroy the active env.

```sh
stevie@caracal:~/demo$ ls
stevie@caracal:~/demo$ mkenv env
Creating python environment in 'env'.
Using Python 2.7.9 (/usr/bin/python).
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

### Search/list environments

To search down the tree for valid Python VirtualEnvs, use `lsenv`.
Likewise, to search up the tree, level by level, use `lsupenv`.
`cdenv` uses `lsupenv` when searching to environment to activate.

## Install

Clone the repo and source the `functions.sh` file from your `.bashrc`.

```
~$ git clone https://github.com/randomir/shenv
~$ echo . ~/shenv/functions.sh >> ~/.bashrc
```

### Enable the faster search

By default, `shenv` uses the `find` command to search for environments. That approach is pretty fast when searching shallow trees. However, if you have a deeper directory trees, it's often faster to use a pre-built directory index (i.e. the `locate` command).
To enable a combined `locate/find` approach to search, run:

```
$ shenv_install
Indexing environments in '/home/stevie'...Done.
```

In the combined approach, if `find` doesn't finish within 100ms, search via `find` is aborted and `locate` is allowed to finish (faster).
