Code.eval_file "tasks/readme.exs"

defmodule Edip.Mixfile do
  use Mix.Project

  @version "0.4.2"

  def project do
    [
      app:         :edip,
      name:        "edip",
      version:     @version,
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
    [
      extras:     ["README.md"],
      main:       "extra-readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/asaaki/mix-edip"
    ]
  end

  defp package do
    [
      files:        ["lib", "tasks", "mix.exs", "README.md", "LICENSE"],
      maintainers:  ["Christoph Grabo"],
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
      { :ex_doc,  "~> 0.10", only: :docs },
      { :earmark, "~> 0.1", only: :docs }
    ]
  end
end
