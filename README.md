# EDIP mix task

A mix task for [EDIP (elixir docker image packager)](https://github.com/asaaki/elixir-docker-image-packager).

## Install

In _mix.exs (deps)_:

```elixir
defp deps do
  [{:edip, github: "asaaki/mix-edip"}]
end
```

## Usage

```shell
mix deps.get edip && mix deps.compile edip
mix edip
```
