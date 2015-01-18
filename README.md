Supermake
=========

A set of makefiles to create supermakefile.

Install
-------

Simplest way is to use `git submodule` to checkout `supermake` in subfolder folder.

    #> git submodule add https://github.com/eagafonov/supermake
    #> git commit -m "Add supermake submodule"

Minimal supermake file
----------------------

Here is an example of minimal supermakefile to use sandbox

    all:

    include supermake/python-sandbox.mk
