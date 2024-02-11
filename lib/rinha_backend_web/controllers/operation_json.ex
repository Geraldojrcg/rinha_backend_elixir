defmodule RinhaBackendWeb.OperationJSON do
  alias RinhaBackend.Mapper

  def render_register_transaction(%{client: %{amount: amount, limit: limit}}) do
    %{
      "saldo" => amount,
      "limite" => limit
    }
  end

  def render_client_statement(%{data: %{client: client, transactions: transactions}}) do
    %{
      "saldo" => %{
        "total" => client.amount,
        "data_extrato" => DateTime.utc_now(),
        "limite" => client.limit
      },
      "ultimas_transacoes" => Enum.map(transactions, fn t -> Mapper.transaction_to_json(t) end)
    }
  end
end
