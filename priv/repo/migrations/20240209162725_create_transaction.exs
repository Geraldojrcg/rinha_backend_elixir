defmodule RinhaBackend.Repo.Migrations.CreateTransacao do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :value, :integer
      add :type, :string
      add :description, :string
      add :inserted_at, :naive_datetime
      add :client_id, references(:client, on_delete: :nothing)
    end

    create index(:transaction, [:client_id])
  end
end
