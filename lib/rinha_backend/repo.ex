defmodule RinhaBackend.Repo do
  use Ecto.Repo,
    otp_app: :rinha_backend,
    adapter: Ecto.Adapters.Postgres
end
