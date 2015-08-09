defmodule Edip.Utils do
  import Mix.Shell, only: [cmd: 2]

  def print(message), do: Mix.shell.info(message)

  @doc "Print an informational message without color"
  def debug(message), do: IO.puts "==> #{message}"

  @doc "Print an informational message in green"
  def info(message),  do: IO.puts "==> #{IO.ANSI.green}#{message}#{IO.ANSI.reset}"

  @doc "Print a warning message in yellow"
  def warn(message),  do: IO.puts "==> #{IO.ANSI.yellow}#{message}#{IO.ANSI.reset}"

  @doc "Print a notice in cyan"
  def notice(message), do: IO.puts "#{IO.ANSI.cyan}#{message}#{IO.ANSI.reset}"

  @doc "Print an error message in red"
  def error(message), do: IO.puts "==> #{IO.ANSI.red}#{message}#{IO.ANSI.reset}"

  @doc "Exits with exit status 1"
  def abort!, do: exit({:shutdown, 1})

  def do_cmd(command, callback \\ &Edip.Utils.PrefixWriter.write/1) do
    cmd(command, callback)
  end

  def silence?(options), do: options.silent
end
