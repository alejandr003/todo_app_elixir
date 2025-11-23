defmodule TodoAppWeb.Plugs.Auth do
  import Plug.Conn
  alias TodoApp.Accounts

  def init(opts), do: opts

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         false <- token_revoked?(token),
         {:ok, user_id} <- Phoenix.Token.verify(conn, "user auth", token, max_age: 86400 * 15),
         user when not is_nil(user) <- Accounts.get_user_by_id(user_id) do
      assign(conn, :current_user, user)
    else
      _ -> conn |> send_resp(401, "Unauthorized") |> halt()
    end
  end

  defp token_revoked?(token) do
    TodoApp.Repo.get_by(TodoApp.Accounts.RevokedToken, token: token) != nil
  end
end
