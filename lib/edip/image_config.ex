defmodule Edip.ImageConfig do
  def from_config(config_path) do
    config_path
    |> config_data
    |> config_lines
    |> parse_lines
  end

  def parse_lines(config_lines) do
    config_lines
    |> Enum.reduce(%{}, fn(line, config) -> parse_line(line, config) end)
  end

  def parse_line("TARBALL_FILE " <> tarball_file, config) do
    Map.merge(config, %{ tarball: tarball_file })
  end
  def parse_line("IMAGE_NAME " <> tagged_name, config) do
    name = tagged_name |> String.split(":") |> hd
    Map.merge(config, %{ tagged_name: tagged_name, name: name })
  end
  def parse_line("IMAGE_TAG " <> tag, config) do
    Map.merge(config, %{ tag: tag })
  end
  def parse_line("IMAGE_SETTINGS " <> settings, config) do
    Map.merge(config, %{ settings: settings })
  end
  def parse_line(_any, config), do: config

  def config_lines(config_data), do: config_data |> String.split("\n") |> Enum.map(&String.strip/1)

  def config_data(config_path), do: File.read!(config_path)
end
