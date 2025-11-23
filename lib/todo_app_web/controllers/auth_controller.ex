defmodule TodoAppWeb.AuthController do
  use TodoAppWeb, :controller
  alias TodoApp.Accounts

  action_fallback TodoAppWeb.FallbackController

  def register(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        token = generate_user_token(conn, user)

        # Enviar email de bienvenida
        url = Application.get_env(:todo_app, TodoAppWeb.Endpoint)[:backend_url] || "http://localhost:4000"
        TodoApp.Emails.send_welcome_email(user, url)

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


  def forgot_password(conn, %{"email" => email}) do
    url = Application.get_env(:todo_app, TodoAppWeb.Endpoint)[:backend_url] || "http://localhost:4000"
    case Accounts.request_password_reset(email, url) do
      {:ok, _token} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Si el correo existe, recibirás un email de recuperación"})
      {:error, _} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Si el correo existe, recibirás un email de recuperación"})
    end
  end

  def reset_password(conn, %{"token" => token, "password" => password}) do
    case Accounts.reset_password(token, password) do
      {:ok, _user} ->
        conn
        |> put_status(:ok)
        |> json(%{message: "Contraseña actualizada exitosamente"})
      {:error, :invalid_or_expired_token} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Token inválido o expirado"})
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
  def logout(conn, _params) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         user = conn.assigns.current_user do
      %TodoApp.Accounts.RevokedToken{}
      |> TodoApp.Accounts.RevokedToken.changeset(%{token: token, user_id: user.id})
      |> TodoApp.Repo.insert()
      conn |> put_status(:ok) |> json(%{message: "Sesión cerrada correctamente"})
    else
      _ -> conn |> put_status(:unauthorized) |> json(%{error: "No autorizado"})
    end
  end
end
