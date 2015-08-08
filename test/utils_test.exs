defmodule Edip.UtilsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  import Edip.Utils

  test "do_cmd" do
    assert ExUnit.CaptureIO.capture_io(fn ->
      do_cmd("echo EDIP", &IO.puts/1, "Echoing")
    end) == "EDIP\n\n"
  end

  test "do_cmd failing" do
    fun = fn ->
      assert catch_exit(do_cmd("fail_echo EDIP", &IO.puts/1, "Echoing")) == {:shutdown, 1}
    end
    assert capture_io(fun) =~ "Echoing stage failed. Please fix any errors and try again"
  end
end
