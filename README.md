# EDIP mix task

A mix task for [EDIP (elixir docker image packager)](https://github.com/asaaki/elixir-docker-image-packager).

<!--
  TOC generaged with doctoc: `npm install -g doctoc`

    $ doctoc README.md --github --maxlevel 4 --title '## TOC'

-->
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
## TOC

- [Install](#install)
- [Usage](#usage)
- [Options](#options)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
<!-- moduledoc: Mix.Tasks.Edip -->
EDIP creates a docker image of your application release.

## Install

In mix.exs:

    defp deps do
      [
        {:exrm, "~> 0.18"},
        {:edip, "~> 0.1"}
      ]
    end

## Usage

    mix deps.get edip && mix deps.compile edip
    mix edip

## Options

    # Override the (repository) name of the docker image.
    mix edip --name <NAME>
    mix edip -n <NAME>

    # Set a specific tag for the docker image.
    mix edip --tag <TAG>
    mix edip -t <TAG>

    # Set only a specific prefix for the docker image name (default: local).
    mix edip --prefix <PREFIX>
    mix edip -p <PREFIX>

    # Get the tarball from the packaging (true), without even creating the docker image (only).
    # The tarballs can be found in the `.edip/tarballs` directory.
    mix edip --tarball true|only
    mix edip -a true|only

    # Force redownload of EDIP tool
    mix edip --force
    mix edip -f

    # Silence build output of EDIP (will be logged to `.edip.log` instead).
    mix edip --silent
    mix edip -s

If `--name` and `--prefix` are given, the name option takes precedence (prefix will be ignored).
<!-- endmoduledoc: Mix.Tasks.Edip -->
