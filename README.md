----

**Outdated/Deprecated** - Please use [mix-edib](https://github.com/edib-tool/mix-edib) instead.

----

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
  - [Project dependency](#project-dependency)
  - [mix archive](#mix-archive)
- [Usage](#usage)
- [Help](#help)
- [Options](#options)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->
<!-- moduledoc: Mix.Tasks.Edip -->
EDIP creates a docker image of your application release.

## Install

### Project dependency

In mix.exs:

    defp deps do
      [
        {:exrm, "~> 0.19"},
        {:edip, "~> 0.4.3"}
      ]
    end

Then run:

    mix deps.get edip && mix deps.compile edip

### mix archive

Just run this and confirm:

    mix archive.install http://git.io/edip-0.4.3.ez

Adn don't forget to add `exrm` to your project:

    defp deps do
      [
        {:exrm, "~> 0.19"}
      ]
    end

## Usage

    mix edip

## Help

    mix help edip

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

    # Silence build output of EDIP (will be logged to `.edip.log` instead).
    mix edip --silent
    mix edip -s

If `--name` and `--prefix` are given, the name option takes precedence (prefix will be ignored).

    # Map additional volumes for use while building the release
    mix edip --mapping <FROM>:<TO>[:<OPTION>]
    mix edip -m <FROM>:<TO>[:<OPTION>]

To pull dependencies stored in private github repositories you will need to make your SSH keys accessible
from the container doing the build:

    mix edip --mapping /path/to/home/.ssh:/root/ssh.
<!-- endmoduledoc: Mix.Tasks.Edip -->
