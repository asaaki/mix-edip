defmodule Edip.Utils.LogWriter do
  def write(data) do
    File.write(log_file, data, [:append])
  end

  def log_file, do: System.cwd! <> "/.edip.log"
end
