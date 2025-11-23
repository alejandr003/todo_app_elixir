defmodule TodoAppWeb.HealthController do
  use TodoAppWeb, :controller

  def check(conn, _params) do
    status = %{
      status: "ok",
      app: "todo_app",
      version: Application.spec(:todo_app, :vsn) |> to_string(),
      timestamp: DateTime.utc_now() |> DateTime.to_iso8601()
    }

    db_status =
      try do
        Ecto.Adapters.SQL.query!(TodoApp.Repo, "SELECT 1")
        "connected"
      rescue
        _ -> "disconnected"
      end

    conn
    |> put_status(:ok)
    |> json(Map.put(status, :database, db_status))
  end
end
