defmodule TodoAppWeb.PasswordController do
  use TodoAppWeb, :controller
  alias TodoApp.Accounts

  def reset_form(conn, %{"token" => token}) do
    render(conn, :reset_form, token: token, error: nil, success: nil)
  end

  def reset_password(conn, %{"token" => token, "password" => password, "password_confirmation" => password_confirmation}) do
    cond do
      String.trim(password) == "" or String.trim(password_confirmation) == "" ->
        render(conn, :reset_form, token: token, error: "Todos los campos son obligatorios", success: nil)

      String.length(password) < 8 ->
        render(conn, :reset_form, token: token, error: "La contraseña debe tener al menos 8 caracteres", success: nil)

      password != password_confirmation ->
        render(conn, :reset_form, token: token, error: "Las contraseñas no coinciden", success: nil)

      true ->
        case Accounts.reset_password(token, password) do
          {:ok, _user} ->
            render(conn, :reset_form, token: token, error: nil, success: "✓ Contraseña actualizada correctamente. Ya puedes iniciar sesión en tu app.")

          {:error, :invalid_or_expired_token} ->
            render(conn, :reset_form, token: token, error: "El enlace es inválido o ha expirado. Solicita uno nuevo.", success: nil)

          {:error, _reason} ->
            render(conn, :reset_form, token: token, error: "No se pudo actualizar la contraseña. Intenta de nuevo.", success: nil)
        end
    end
  end
end
