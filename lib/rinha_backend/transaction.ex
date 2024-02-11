defmodule RinhaBackend.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transaction" do
    field :value, :integer
    field :type, :string
    field :description, :string
    field :inserted_at, :naive_datetime

    field :client_id, :id
  end

  def changeset(transaction, attrs) do
    transaction
    |> cast(attrs, [:value, :type, :description, :client_id])
    |> validate_required([:value, :type, :description, :client_id])
    |> validate_length(:description, min: 1, max: 10)
    |> validate_value(:value)
    |> validate_type(:type)
  end

  def validate_value(changeset, :value) do
    validate_change(changeset, :value, fn _field, value ->
      if value >= 0, do: [], else: [value: "must be positive"]
    end)
  end

  def validate_type(changeset, :type) do
    validate_change(changeset, :type, fn _field, value ->
      if Enum.member?(["c", "d"], value), do: [], else: [type: "must be c or d"]
    end)
  end
end
