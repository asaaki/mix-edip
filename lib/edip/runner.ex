defmodule Edip.Runner do
  import Edip.Utils
  import Edip.Options

  @edip_repo "https://github.com/asaaki/elixir-docker-image-packager.git"
  @edip_dir  ".edip"

  def run(args) do
    options = options(args)
    info "Packaging your app release into a docker image"
    info "Build settings: #{package_make_vars(options)}"
    run_steps(options)
  end

  defp run_steps(opts) do
    force = force_recreate?(opts)
    remove_work_dir(force)
    create_work_dir(force || !work_dir_okay?)
    recreate_app_dir
    copy_app_files
    reset_edip_log_file
    package_release(opts)
    info "The image is ready! You can check with `docker images`"
  end

  defp current_dir,  do: File.cwd!
  defp work_dir,     do: current_dir <> "/" <> @edip_dir
  defp work_app_dir, do: work_dir <> "/app"

  defp work_dir_okay?, do: File.exists?(work_dir) && File.dir?(work_dir)

  defp remove_work_dir(true), do: File.rm_rf!(work_dir)
  defp remove_work_dir(_),    do: :noop

  defp create_work_dir(true), do: clone_edip
  defp create_work_dir(_),    do: :noop

  defp clone_edip do
    info "Download EDIP ..."
    do_cmd("git clone #{@edip_repo} #{@edip_dir}", &ignore/1)
  end

  defp recreate_app_dir do
    File.rm_rf!(work_app_dir)
    File.mkdir_p!(work_app_dir)
  end

  defp copy_app_files do
    for file <- valid_app_files do
      File.cp_r!(current_dir <> "/" <> file, work_app_dir <> "/" <> file)
    end
  end

  defp current_app_files, do: File.ls!(current_dir)
  defp valid_app_files, do: current_app_files |> Enum.filter(&is_valid_file?/1)

  defp is_valid_file?(@edip_dir),    do: false
  defp is_valid_file?(".git"),       do: false
  defp is_valid_file?(".gitignore"), do: false
  defp is_valid_file?("_build"),     do: false
  defp is_valid_file?("deps"),       do: false
  defp is_valid_file?(_),            do: true

  defp package_release(opts) do
    info "Building ..."
    silent = silent?(opts)
    do_cmd("make -C #{work_dir} #{package_make_vars(opts)}", silent_build?(silent))
  end

  defp silent_build?(true), do: &silent_log/1
  defp silent_build?(false), do: &IO.write/1

  defp silent_log(data) do
    File.write(edip_log_file, data, [:append])
  end

  def reset_edip_log_file do
    File.rm_rf!(edip_log_file)
  end

  defp edip_log_file, do: current_dir <> "/.edip.log"

  defp package_make_vars(opts) do
    {_, vars} = {opts, []} |> package_name |> package_tag |> package_prefix
    vars |> Enum.join(" ")
  end

  defp package_name({opts, vars}) do
    case Dict.get(opts, :name) do
      nil  -> {opts, vars}
      name -> {opts, ["NAME=#{name}" | vars]}
    end
  end

  defp package_tag({opts, vars}) do
    case Dict.get(opts, :tag) do
      nil -> {opts, vars}
      tag -> {opts, ["TAG=#{tag}" | vars]}
    end
  end

  defp package_prefix({opts, vars}) do
    case Dict.get(opts, :prefix) do
      nil    -> {opts, vars}
      prefix -> {opts, ["PREFIX=#{prefix}" | vars]}
    end
  end
end
