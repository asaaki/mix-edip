defmodule Edip.Mixfile do
  use Mix.Project

  def project do
    [
      app:     :edip,
      version: "0.1.0",
      elixir:  "~> 1.0",
      deps:    deps
    ]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end
end
