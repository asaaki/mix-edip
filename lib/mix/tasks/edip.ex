defmodule Mix.Tasks.Edip do
  @moduledoc """
  EDIP creates a docker image of your application release.

  ## Install

  In mix.exs:

      defp deps do
        [
          {:exrm, "~> 0.18"},
          {:edip, "~> 0.2"}
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
  """

  @shortdoc "Create a Docker image of your app."

  use Mix.Task

  defdelegate run(args), to: Mix.Tasks.Edip.Image
end
