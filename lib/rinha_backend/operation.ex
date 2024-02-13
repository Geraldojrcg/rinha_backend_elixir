defmodule RinhaBackend.Operation do
  import Ecto.Query, only: [from: 2]

  alias RinhaBackend.Client
  alias RinhaBackend.Repo
  alias RinhaBackend.Transaction

  def register_transaction(params, id) do
    params =
      params
      |> Map.merge(%{"client_id" => id})

    {:ok, response} =
      Repo.transaction(fn ->
        with {:ok, client} <- get_client_for_update(id),
             {:ok, _} <- insert_transaction(params) do
          update_client_amount(params, client)
        end
      end)

    response
  end

  def get_client_statement(client_id) do
    case Repo.get(Client, client_id) do
      nil ->
        {:error, nil}

      client ->
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

  defp get_client_for_update(client_id) do
    query =
      from c in Client,
        where: c.id == ^client_id,
        lock: fragment("FOR UPDATE")

    case Repo.all(query) do
      [%Client{} = client] -> {:ok, client}
      _ -> {:error, :not_found}
    end
  end

  defp insert_transaction(transaction_params) do
    %Transaction{}
    |> Transaction.changeset(transaction_params)
    |> Repo.insert()
  end

  defp update_client(client, new_amount) do
    client
    |> Client.changeset(%{amount: new_amount})
    |> Repo.update()
  end

  defp update_client_amount(
         %{"type" => "d", "value" => value},
         client
       ) do
    with {:ok, _} <- check_client_limit(client, value) do
      update_client(client, client.amount - value)
    end
  end

  defp update_client_amount(
         %{"type" => "c", "value" => value},
         client
       ) do
    update_client(client, client.amount + value)
  end

  defp check_client_limit(%{amount: amount, limit: limit} = client, transaction_value) do
    cond do
      amount - transaction_value < -limit -> {:error, :unprocessable_entity}
      true -> {:ok, client}
    end
  end
end
