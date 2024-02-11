defmodule RinhaBackend.Mapper do
  def json_to_transaction(json) do
    %{
      "value" => Map.get(json, "valor"),
      "type" => Map.get(json, "tipo"),
      "description" => Map.get(json, "descricao")
    }
  end

  def transaction_to_json(transaction) do
    %{
      "valor" => transaction.value,
      "tipo" => transaction.type,
      "descricao" => transaction.description,
      "realizada_em" => transaction.inserted_at
    }
  end
end
