defmodule RinhaBackendWeb.OperationController do
  alias RinhaBackend.Mapper
  alias RinhaBackend.Operation
  use RinhaBackendWeb, :controller

  def register_transaction(%Plug.Conn{body_params: body} = conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error ->
        conn |> send_resp(404, "")

      {parsed_id, _} ->
        Mapper.json_to_transaction(body)
        |> Operation.register_transaction(parsed_id)
        |> handle_register_transaction_response(conn)
    end
  end

  def get_client_statement(conn, %{"id" => id}) do
    case Integer.parse(id) do
      :error ->
        conn |> send_resp(404, "")

      {parsed_id, _} ->
        Operation.get_client_statement(parsed_id)
        |> handle_get_client_statement_response(conn)
    end
  end

  defp handle_register_transaction_response({:error, reason}, conn) do
    case reason do
      :unprocessable_entity ->
        conn |> send_resp(422, "")

      %Ecto.Changeset{valid?: false} ->
        conn |> send_resp(422, "")

      :not_found ->
        conn |> send_resp(404, "")

      _ ->
        conn |> send_resp(500, "")
    end
  end

  defp handle_register_transaction_response({:ok, client}, conn) do
    conn
    |> put_status(200)
    |> render(:render_register_transaction, client: client)
  end

  defp handle_get_client_statement_response({:error, _}, conn) do
    conn |> send_resp(404, "")
  end

  defp handle_get_client_statement_response({:ok, data}, conn) do
    conn
    |> put_status(200)
    |> render(:render_client_statement, data: data)
  end
end
