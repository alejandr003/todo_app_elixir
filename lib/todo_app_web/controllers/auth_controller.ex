defmodule TodoAppWeb.AuthController do
  use TodoAppWeb, :controller
  alias TodoApp.Accounts

  action_fallback TodoAppWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        token = generate_user_token(conn, user)
        conn
        |> put_status(:created)
        |> json(%{
          data: %{
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            token: token,
            inserted_at: user.inserted_at,
            updated_at: user.updated_at
          }
        })

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: translate_errors(changeset)})
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        token = generate_user_token(conn, user)
        conn
        |> put_status(:ok)
        |> json(%{
          data: %{
            id: user.id,
            name: user.name,
            last_name: user.last_name,
            email: user.email,
            token: token,
            info: "Inicio de sesión exitoso para #{user.name}"
          }
        })

      {:error, :invalid_password, _action, message} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: message})

      {:error, :user_not_found, _action, message} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: message})
    end
  end

  defp generate_user_token(conn, user) do
    Phoenix.Token.sign(conn, "user auth", user.id, max_age: 86400 * 15)
  end

  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
  end
end
