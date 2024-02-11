defmodule RinhaBackend.Release do
  @app :rinha_backend

  @repos Application.compile_env(@app, :ecto_repos, [])

  def migrate do
    Application.load(@app)

    for repo <- @repos do
      repo.__adapter__().storage_up(repo.config())
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def seed do
    Application.load(@app)

    for repo <- @repos do
      {:ok, _, _} =
        Ecto.Migrator.with_repo(repo, fn repo ->
          Ecto.Migrator.run(repo, :up, all: true)

          run_seeds_for(repo)
        end)
    end
  end

  defp run_seeds_for(repo) do
    seed_script = priv_path_for(repo, "seeds.exs")

    if File.exists?(seed_script) do
      Code.eval_file(seed_script)
    end
  end

  defp priv_path_for(repo, filename) do
    app = Keyword.get(repo.config, :otp_app)

    repo_underscore =
      repo
      |> Module.split()
      |> List.last()
      |> Macro.underscore()

    priv_dir = "#{:code.priv_dir(app)}"

    Path.join([priv_dir, repo_underscore, filename])
  end
end
