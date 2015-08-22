defmodule Edip.Runner do
  import Edip.Utils
  alias Edip.Options
  alias Edip.ImageConfig
  alias Edip.Settings

  @edip_version          "0.4.3"
  @edip_tool             "asaaki/edip-tool:#{@edip_version}"
  @docker_cmd            "docker"
  @docker_run            "#{@docker_cmd} run --privileged"
  @docker_import         "#{@docker_cmd} import"
  @docker_tag            "#{@docker_cmd} tag --force"
  @tarball_dir_name      "tarballs"
  @artifact_config       "artifact.cfg"
  @container_source_dir  "/source"
  @container_tarball_dir "/stage/tarballs"

  def run(args) do
    options = Options.from_args(args)
    info "Packaging your app release into a docker image"
    run_steps(options)
  end

  defp run_steps(options) do
    {:ok, :start, options}
    |> check_app
    |> check_exrm
    |> reinit_log
    |> step_build_artifact
    |> step_build_image
    |> evaluate_success_or_error
  end

  defp check_app({:error, _, _} = error), do: error
  defp check_app({_result, _msg, options}) do
    case Mix.Project.get do
      nil -> {:error, "No Mix project in this directory! Please ensure a mix.exs file is available.", options}
      _   -> {:ok, :project_present, options}
    end
  end

  defp check_exrm({:error, _, _} = error), do: error
  defp check_exrm({_result, _msg, options}) do
    case has_exrm? do
      true -> {:ok, :project_present, options}
      _    -> {:error, "No `exrm` dependency found. Please add it to your project.", options}
    end
  end

  defp reinit_log({:error, _, _} = error), do: error
  defp reinit_log({_result, _msg, options}) do
    {:ok, :reinit_log, options}
    |> substep_delete_log
    |> substep_add_log_header
  end

  defp substep_delete_log({:error, _, _, _} = error), do: error
  defp substep_delete_log({_result, _msg, [silent: false] = options}), do: {:ok, :skip_log_deletion, options}
  defp substep_delete_log({_result, _msg, options}) do
    log_file = Edip.Utils.LogWriter.log_file
    case File.rm_rf(log_file) do
      {:ok, _}       -> {:ok, :log_file_deleted, options}
      {:error, _, _} -> {:ok, :append_to_existing_log, options}
    end
  end

  defp substep_add_log_header({:error, _, _, _} = error), do: error
  defp substep_add_log_header({_result, _msg, [silent: false] = options}), do: {:ok, :skip_log_header, options}
  defp substep_add_log_header({_result, _msg, options}) do
    header = """
    EDIP tool v#{@edip_version}
    DT(UTC): #{inspect :calendar.universal_time}
    ================================================================================

    """
    Edip.Utils.LogWriter.write(header)

    {:ok, :log_header_added, options}
  end

  defp step_build_artifact({:error, _, _} = error), do: error
  defp step_build_artifact({_result, _msg, options}) do
    info("Creating artifact (might take a while) ...")
    command = "#{@docker_run} #{volumes(options)} #{release_settings(options)} #{@edip_tool}"

    options.writer.("$> #{command}\n")
    case do_cmd(command, options.writer) do
      0 ->
        info("Artifact successfully created.")
        {:ok, :artifact, options}
      _ ->
        {:error, "Artifact not created! Check for any errors above.", options}
    end
  end

  defp step_build_image({:error, _, _} = error), do: error
  defp step_build_image({_result, _msg, options}) do
    info("Creating docker image ...")
    config = ImageConfig.from_config(artifact_config)

    {:ok, :step_build_image, config, options}
    |> substep_import_image
    |> substep_tag_latest_image
    |> substep_return_options
  end

  defp substep_import_image({:error, _, _, _} = error), do: error
  defp substep_import_image({_result, _msg, config, options}) do
    image_command = "cat #{tarball_dir}/#{config.tarball} | #{@docker_import} #{config.settings} - #{config.tagged_name}"

    options.writer.("$> #{image_command}\n")
    case do_cmd(image_command, options.writer) do
      0 ->
        info("Docker image created: #{config.tagged_name}")

        usage_info = """

            You can try your freshly packaged image with:

            $ docker run --rm #{config.tagged_name}

            Or if you have a Phoenix app:

            $ docker run --rm -e "PORT=4000" -p 4000:4000 #{config.tagged_name}

        """
        print(usage_info)

        {:ok, :image_import, config, options}
      _ ->
        {:error, "Creation of Docker image `#{config.tagged_name}` failed! Check for any errors above.", config, options}
    end
  end

  defp substep_tag_latest_image({:error, _, _, _} = error), do: error
  defp substep_tag_latest_image({_result, _msg, config, options}) do
    tag_command = "#{@docker_tag} #{config.tagged_name} #{config.name}:latest"

    options.writer.("$> #{tag_command}\n")
    case do_cmd(tag_command, options.writer) do
      0 ->
        info("Docker image tagged as latest: #{config.tagged_name} -> #{config.name}:latest")
        {:ok, :image_import, config, options}
      _ ->
        {:error, "Creation of Docker image `#{config.tagged_name}` failed! Check for any errors above.", config, options}
    end
  end

  defp substep_return_options({result, msg, _config, options}), do: {result, msg, options}

  defp evaluate_success_or_error({:ok, _, _}) do
    info "Packaging was successful! \\o/"
    :ok
  end
  defp evaluate_success_or_error({:error, msg, _}) do
    error("An error happened!")
    error("Reason: #{msg}")
    abort!
  end

  defp current_dir,     do: System.cwd!
  defp tarball_dir,     do: current_dir <> "/" <> @tarball_dir_name
  defp artifact_config, do: tarball_dir <> "/" <> @artifact_config

  defp volumes(options) do
    [
      Settings.from_mapping_options(options.mappings),
      "-v #{current_dir}:#{@container_source_dir}",
      "-v #{tarball_dir}:#{@container_tarball_dir}"
    ]
    |> Enum.join(" ")
  end

  defp release_settings(options), do: Settings.from_package_options(options.package)

  defp has_exrm?,      do: project_deps |> Dict.has_key?(:exrm)
  defp project_deps,   do: project_config |> Dict.get(:deps)
  defp project_config, do: Mix.Project.config
end
