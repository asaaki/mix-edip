defmodule Edip.Settings do
  alias Edip.Options.Mapping
  def from_package_options(options) do
    parse_package_options(options)
    |> Enum.map_join(" ", &(~s(-e "#{&1}")))
  end

  def from_mapping_options(options) do
    options |>
    Enum.map_join(" ", &(~s(-v "#{mapping_to_string(&1)}")))
  end

  defp mapping_to_string(m = %Mapping{options: nil}), do: "#{m.from}:#{m.to}"
  defp mapping_to_string(m = %Mapping{}), do: "#{m.from}:#{m.to}:#{m.options}"

  defp parse_package_options(options) do
    {_, vars} =
      {options, []}
      |> package_name
      |> package_tag
      |> package_prefix

    vars
  end

  defp package_name({options, vars}) do
    case options.name do
      nil  -> {options, vars}
      name -> {options, ["RELEASE_NAME=#{name}" | vars]}
    end
  end

  defp package_tag({options, vars}) do
    case options.tag do
      nil -> {options, vars}
      tag -> {options, ["RELEASE_TAG=#{tag}" | vars]}
    end
  end

  defp package_prefix({options, vars}) do
    case options.prefix do
      nil    -> {options, vars}
      prefix -> {options, ["RELEASE_PREFIX=#{prefix}" | vars]}
    end
  end
end
