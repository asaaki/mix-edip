defmodule Edip.Options.Package do
  defstruct name:   nil,
            tag:    nil,
            prefix: nil
end

defmodule Edip.Options do
  alias Edip.Options.Package

  @option_aliases [n: :name, t: :tag, p: :prefix, s: :silent]
  @option_stricts [name: :string, tag: :string, prefix: :string, silent: :boolean]

  defstruct silent:  false,
            writer:  &Edip.Utils.PrefixWriter.write/1,
            package: %Package{}

  def from_args(args) do
    valid_options = parse_args(args)

    writer  = writer(valid_options)
    package = struct(Package, valid_options)
    struct(__MODULE__, Dict.merge(valid_options, [writer: writer, package: package]))
  end

  defp parse_args(args) do
    {valid_opts, _, _} = OptionParser.parse(args, aliases: @option_aliases, strict: @option_stricts)
    valid_opts
  end

  defp writer(valid_options) do
    case Dict.get(valid_options, :silent) do
      true -> &Edip.Utils.LogWriter.write/1
      _    -> &Edip.Utils.PrefixWriter.write/1
    end
  end
end
