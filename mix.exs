Code.eval_file "tasks/readme.exs"

defmodule Edip.Mixfile do
  use Mix.Project

  def project do
    [
      app:         :edip,
      name:        "edip",
      version:     "0.4.0",
      elixir:      "~> 1.0",
      description: description,
      docs:        &docs/0,
      package:     package,
      deps:        deps
    ]
  end

  def application, do: []

  defp description do
    """
    Mix task to create a docker image of your application release.

    More detailed information about release image packaging at:
    https://github.com/asaaki/elixir-docker-image-packager
    """
  end

  defp docs do
    {ref, 0} = System.cmd("git", ["rev-parse", "--verify", "--quiet", "HEAD"])
    [
      source_ref: ref,
      readme:     "README.md",
      main:       "README"
    ]
  end

  defp package do
    [
      files:        ["lib", "tasks", "mix.exs", "README.md", "LICENSE"],
      contributors: ["Christoph Grabo"],
      licenses:     ["MIT"],
      links: %{
        "GitHub": "https://github.com/asaaki/mix-edip",
        "Docs":   "http://hexdocs.pm/edip",
        "EDIP":   "https://github.com/asaaki/elixir-docker-image-packager"
      }
    ]
  end

  defp deps do
    [
      { :ex_doc,  "~> 0.8", only: :docs },
      { :earmark, "~> 0.1", only: :docs }
    ]
  end
end
