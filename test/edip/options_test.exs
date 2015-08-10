defmodule OptionsTest do
  use ExUnit.Case

  alias Edip.Options

  test "degenerate options string (defaults)" do
    parsed = Options.from_args([])

    assert parsed == %Options{}
    assert parsed.package == %Options.Package{}
    assert parsed.writer == &Edip.Utils.PrefixWriter.write/1
    assert parsed.mappings == []
  end

  test "package -- name option" do
    parsed = Options.from_args(["--name", "foo"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.name == "foo"

    # Test same option in alias form
    parsed = Options.from_args(["-n", "pfoo"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.name == "pfoo"
  end

  test "package -- tag option" do
    parsed = Options.from_args(["--tag", "tagged"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.tag == "tagged"

    # Test same option in alias form
    parsed = Options.from_args(["-t", "taggeddy"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.tag == "taggeddy"
  end

  test "package -- prefix option" do
    parsed = Options.from_args(["--prefix", "prefoo"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.prefix == "prefoo"

    # Test same option in alias form
    parsed = Options.from_args(["-p", "pfoo"])

    %Options{package: pkg_options} = parsed
    assert pkg_options.prefix == "pfoo"
  end

  test "writer -- silent option" do
    parsed = Options.from_args(["--silent", true])

    %Options{writer: writer} = parsed
    assert writer == &Edip.Utils.LogWriter.write/1

    # Test same option in alias form
    parsed = Options.from_args(["-s"])

    %Options{writer: writer} = parsed
    assert writer == &Edip.Utils.LogWriter.write/1
  end

  test "mappings -- basic mapping" do
    parsed = Options.from_args(["--mapping", "/from/a/vol:/to/a/vol"])

    %Options{mappings: mappings} = parsed
    assert length(mappings) == 1

    [mapping|[]] = mappings
    assert mapping == %Options.Mapping{from: "/from/a/vol", to: "/to/a/vol"}
  end

  test "mappings -- mapping with options" do
    parsed = Options.from_args(["--mapping", "/from/a/vol:/to/a/vol:ro"])

    %Options{mappings: mappings} = parsed
    assert length(mappings) == 1

    [mapping|[]] = mappings
    assert mapping == %Options.Mapping{from: "/from/a/vol", to: "/to/a/vol", options: "ro"}
  end

  test "mappings -- multiple mappings" do
    %Options{mappings: mappings} = [
      "--mapping", "/from/a/vol:/to/a/vol",
      "--mapping", "/from/another/vol:/to/another/vol"
    ]
    |> Options.from_args

    assert length(mappings) == 2

    [mapping1|[mapping2]] = mappings
    assert mapping1 == %Options.Mapping{from: "/from/a/vol", to: "/to/a/vol"}
    assert mapping2 == %Options.Mapping{from: "/from/another/vol", to: "/to/another/vol"}
  end
end
