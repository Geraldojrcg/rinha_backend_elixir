defmodule RinhaBackend.Repo.Migrations.CreateClient do
  use Ecto.Migration

  def change do
    create table(:client) do
      add :amount, :integer
      add :limit, :integer
    end
  end
end
