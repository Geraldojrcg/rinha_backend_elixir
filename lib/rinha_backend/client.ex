defmodule RinhaBackend.Client do
  use Ecto.Schema
  import Ecto.Changeset

  schema "client" do
    field :amount, :integer
    field :limit, :integer
  end

  def changeset(client, attrs) do
    client
    |> cast(attrs, [:amount, :limit])
    |> validate_required([:amount, :limit])
  end
end
