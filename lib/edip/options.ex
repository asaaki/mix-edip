defmodule Edip.Options do
  @option_aliases [n: :name, t: :tag, p: :prefix, a: :tarball, f: :force, s: :silent]
  @option_stricts [name: :string, tag: :string, prefix: :string, tarball: :string, force: :boolean, silent: :boolean]

  def options(args) do
    {valid_opts, _, _} = OptionParser.parse(args, aliases: @option_aliases, strict: @option_stricts)
    valid_opts
  end

  def force_recreate?(options), do: Dict.get(options, :force, false)
  def silent?(opts),            do: Dict.get(opts, :silent, false)
end
