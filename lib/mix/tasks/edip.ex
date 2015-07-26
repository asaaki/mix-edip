defmodule Mix.Tasks.Edip do
  @moduledoc """
  Create a Docker image of your application release.

  (Needs `exrm` dependeny in your project.)
  """

  @shortdoc "Create a Docker image of your app."

  use Mix.Task

  defdelegate run(args), to: Mix.Tasks.Edip.Image
end
