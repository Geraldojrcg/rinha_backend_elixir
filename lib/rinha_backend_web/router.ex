defmodule RinhaBackendWeb.Router do
  use RinhaBackendWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RinhaBackendWeb do
    pipe_through :api

    post "/clientes/:id/transacoes", OperationController, :register_transaction
    get "/clientes/:id/extrato", OperationController, :get_client_statement
  end
end
