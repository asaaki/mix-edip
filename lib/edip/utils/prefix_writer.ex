defmodule Edip.Utils.PrefixWriter do
  def write(data) do
    data
    |> prefix_chunks
    |> IO.write
  end

  defp prefix_chunks(data) do
    data
    |> String.split("\n")
    |> Enum.reduce("", &prefix_chunk/2)
  end

  defp prefix_chunk("", result),    do: result
  defp prefix_chunk(chunk, result), do: result <> "#{IO.ANSI.magenta}|#{IO.ANSI.reset} #{chunk}\n"
end
