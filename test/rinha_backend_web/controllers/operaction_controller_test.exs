defmodule RinhaBackendWeb.OperactionControllerTest do
  alias RinhaBackend.Client
  alias RinhaBackend.Repo
  use RinhaBackendWeb.ConnCase, async: true

  @invalid_debit_transaction_params %{
    valor: 80001,
    tipo: "d",
    descricao: "teste"
  }

  @invalid_transaction_params %{
    valor: 8000,
    tipo: "e",
    descricao: "teste"
  }

  @valid_debit_transaction_params %{
    valor: 1000,
    tipo: "d",
    descricao: "teste"
  }

  @valid_credit_transaction_params %{
    valor: 2000,
    tipo: "c",
    descricao: "teste"
  }

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "register transaction" do
    test "should register the debit transaction and return the info", %{conn: conn} do
      client = Repo.get(Client, 1)

      conn = post(conn, ~p"/clientes/1/transacoes", @valid_debit_transaction_params)

      assert client != nil

      new_amount = client.amount - @valid_debit_transaction_params.valor

      new_limit = client.limit

      assert response(conn, 200)

      %{
        "saldo" => amount,
        "limite" => limit
      } = json_response(conn, 200)

      assert amount == new_amount
      assert limit == new_limit
    end

    test "should register the credit transaction and return the info", %{conn: conn} do
      client = Repo.get(Client, 1)

      conn = post(conn, ~p"/clientes/1/transacoes", @valid_credit_transaction_params)

      assert client != nil

      new_amount =
        client.amount + @valid_credit_transaction_params.valor

      new_limit = client.limit

      assert response(conn, 200)

      %{
        "saldo" => amount,
        "limite" => limit
      } = json_response(conn, 200)

      assert amount == new_amount
      assert limit == new_limit
    end

    test "when the client id isnt passed in the path should return 404", %{conn: conn} do
      conn = post(conn, ~p"/clientes", @invalid_transaction_params)
      assert response(conn, 404)
    end

    test "when the client id isnt a number should return 404", %{conn: conn} do
      conn = post(conn, ~p"/clientes/a/transacoes", @invalid_transaction_params)
      assert response(conn, 404)
    end

    test "when the client id doesnt not exists should return 404", %{conn: conn} do
      conn = post(conn, ~p"/clientes/8/transacoes", @invalid_transaction_params)
      assert response(conn, 404)
    end

    test "when the value isnt provided should return 422", %{conn: conn} do
      conn =
        post(
          conn,
          ~p"/clientes/2/transacoes",
          Map.delete(@invalid_transaction_params, "valor")
        )

      assert response(conn, 422)
    end

    test "when the description isnt provided should return 422", %{conn: conn} do
      conn =
        post(
          conn,
          ~p"/clientes/2/transacoes",
          Map.delete(@invalid_transaction_params, "descricao")
        )

      assert response(conn, 422)
    end

    test "when the type isnt c or d should return 422", %{conn: conn} do
      conn = post(conn, ~p"/clientes/2/transacoes", @invalid_transaction_params)
      assert response(conn, 422)
    end

    test "when the client doesnt have suficient limit should return 422", %{conn: conn} do
      conn = post(conn, ~p"/clientes/2/transacoes", @invalid_debit_transaction_params)
      assert response(conn, 422)
    end
  end

  describe "get client statements" do
    test "should return the client statements correctly", %{conn: conn} do
      conn = post(conn, ~p"/clientes/1/transacoes", @valid_credit_transaction_params)

      conn = get(conn, ~p"/clientes/1/extrato")

      create_date = DateTime.to_string(DateTime.utc_now())

      assert response(conn, 200)

      response = json_response(conn, 200)

      assert %{
               "saldo" => %{
                 "total" => 2000,
                 "limite" => 100_000
               },
               "ultimas_transacoes" => [
                 %{
                   "valor" => 2000,
                   "tipo" => "c",
                   "descricao" => "teste"
                 }
               ]
             } = response
    end
  end
end
