defmodule RinhaBackend.Repo.Migrations.CreateTransacao do
  use Ecto.Migration

  def change do
    create table(:transaction) do
      add :value, :integer
      add :type, :string
      add :description, :string
      add :client_id, references(:client, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:transaction, [:client_id])
  end
end
