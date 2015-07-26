defmodule Mix.Tasks.Edip.Image do
  use Mix.Task

  def run(args), do: Edip.Runner.run(args)
end
