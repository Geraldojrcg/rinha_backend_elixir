defmodule RinhaBackend.Operation do
  import Ecto.Query, only: [from: 2]

  alias RinhaBackend.Client
  alias RinhaBackend.Repo
  alias RinhaBackend.Transaction

  def register_transaction(params, id) do
    params =
      params
      |> Map.merge(%{"client_id" => id})

    with {:ok, client} <- check_client_exists_by_id(id),
         {:ok, _} <-
           check_client_limit(client, Map.get(params, "type"), Map.get(params, "value")),
         {:ok, transaction} <- save_transaction(params) do
      update_client_amount(client, transaction.type, transaction.value)
    end
  end

  def get_client_statement(client_id) do
    with {:ok, client} <- check_client_exists_by_id(client_id) do
      query =
        from t in Transaction,
          limit: 10,
          order_by: [desc: t.inserted_at],
          where: t.client_id == ^client_id

      transactions = Repo.all(query)

      {
        :ok,
        %{
          client: client,
          transactions: transactions
        }
      }
    end
  end

  defp save_transaction(params) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end

  defp update_client_amount(client, "d", value) do
    client
    |> Client.changeset(%{amount: client.amount - value})
    |> Repo.update()
  end

  defp update_client_amount(client, "c", value) do
    client
    |> Client.changeset(%{amount: client.amount + value})
    |> Repo.update()
  end

  defp check_client_exists_by_id(client_id) do
    case client = Repo.get(Client, client_id) do
      nil -> {:error, :not_found}
      _ -> {:ok, client}
    end
  end

  defp check_client_limit(client, type, transaction_value)

  defp check_client_limit(_, _, nil), do: {:error, :unprocessable_entity}

  defp check_client_limit(client, "c", _), do: {:ok, client}

  defp check_client_limit(%{amount: amount, limit: limit} = client, "d", transaction_value) do
    cond do
      amount - transaction_value < -limit -> {:error, :unprocessable_entity}
      true -> {:ok, client}
    end
  end

  defp check_client_limit(_, _, _), do: {:error, :unprocessable_entity}
end
