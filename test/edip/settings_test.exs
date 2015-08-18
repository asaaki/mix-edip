defmodule SettingsTest do
  use ExUnit.Case

  alias Edip.Options

  test "package name is converted to environment var spec string" do
    pkg_options =
      %Options.Package{name: "pkg_name"}
      |> Edip.Settings.from_package_options

   assert String.contains?(pkg_options, "RELEASE_NAME=pkg_name")
  end

  test "tag name is converted to environment var spec string" do
    pkg_options =
      %Options.Package{tag: "taggar"}
    |> Edip.Settings.from_package_options

    assert String.contains?(pkg_options, "RELEASE_TAG=taggar")
  end

  test "package prefix is converted to environment var spec string" do
    pkg_options =
      %Options.Package{prefix: "prefixer"}
    |> Edip.Settings.from_package_options

    assert String.contains?(pkg_options, "RELEASE_PREFIX=prefixer")
  end

  test "basic mapping is formatted for docker run command" do
    mapping_options =
      [%Options.Mapping{from: "/from/vol", to: "/to/vol"}]
    |> Edip.Settings.from_mapping_options

    assert mapping_options == ~s(-v "/from/vol:/to/vol")
  end

  test "mapping with access option is formatted for docker run command" do
    mapping_options =
      [%Options.Mapping{from: "/from/vol", to: "/to/vol", options: "ro"}]
    |> Edip.Settings.from_mapping_options

    assert mapping_options == ~s(-v "/from/vol:/to/vol:ro")
  end

  test "multiple mappings are formatted for docker run command" do
    mapping_options =
      [%Options.Mapping{from: "/from/vol", to: "/to/vol"},
       %Options.Mapping{from: "/from/diff/vol", to: "/to/diff/vol", options: "rw"}]
    |> Edip.Settings.from_mapping_options

    assert String.contains?(mapping_options, ~s(-v "/from/vol:/to/vol"))
    assert String.contains?(mapping_options, ~s(-v "/from/diff/vol:/to/diff/vol:rw"))
  end
end
