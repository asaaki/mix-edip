defmodule Edip.Options.Package do
  defstruct name:   nil,
            tag:    nil,
            prefix: nil
end

defmodule Edip.Options.Mapping do
  defstruct from: nil,
            to:   nil,
            options: nil
end

defmodule Edip.Options do
  alias Edip.Options.Package
  alias Edip.Options.Mapping

  @option_aliases [n: :name, t: :tag, p: :prefix, s: :silent, m: :mapping]
  @option_stricts [
    name:    :string,
    tag:     :string,
    prefix:  :string,
    silent:  :boolean,
    mapping: [:string, :keep]
  ]

  defstruct silent:   false,
            writer:   &Edip.Utils.PrefixWriter.write/1,
            package:  %Package{},
            mappings: []

  def from_args(args) do
    valid_options = parse_args(args)

    writer  = writer(valid_options)
    package = struct(Package, valid_options)
    mappings = valid_options[:mappings]
    struct(__MODULE__, Dict.merge(valid_options, [writer: writer, package: package, mappings: mappings]))
  end

  defp parse_args(args) do
    {parsed_opts, _, _} = OptionParser.parse(args, aliases: @option_aliases, strict: @option_stricts)
    |> consolidate_mappings

    parsed_opts
  end

  defp writer(valid_options) do
    case Dict.get(valid_options, :silent) do
      true -> &Edip.Utils.LogWriter.write/1
      _    -> &Edip.Utils.PrefixWriter.write/1
    end
  end

  defp consolidate_mappings({parsed, argv, errors}) do
    mappings = parsed
    |> Keyword.get_values(:mapping)
    |> Enum.map(&create_valid_mapping/1)

    parsed = parsed |> Keyword.delete(:mapping) |> Keyword.merge(mappings: mappings)

    {parsed, argv, errors}
  end

  defp create_valid_mapping(mapping_opt) do
    case mapping_opt |> String.split(":") do
      [from, to] -> %Mapping{from: from, to: to}
      [from, to, options] -> %Mapping{from: from, to: to, options: options}
      _ -> raise "Volume mapping is /from/vol:/to/vol or /from/vol/:/to/vol:access_option"
    end
  end
end
