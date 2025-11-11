defmodule TodoApp.Accounts do
  alias TodoApp.Repo
  alias TodoApp.Accounts.Users
  import Ecto.Query, warn: false
  import Ecto.Changeset

  def register_user(attrs) do
    %Users{}
    |> Users.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(Users, email: email)

    cond do
      user && Bcrypt.verify_pass(password, user.hashed_password) ->
        {:ok, user}
      user ->
        {:error, :invalid_password, :put_message, "Contraseña inválida"}
      true ->
        {:error, :user_not_found, :put_message, "Usuario no encontrado"}
    end
  end

  def get_user_by_email(email) do
    Repo.get_by(Users, email: email)

    if email do
      {:ok, email}
    else
      {:error, :user_not_found, :put_message, "Correo no encontrado"}
    end
  end

  def get_user_by_id(id) do
    Repo.get(Users, id)
    if id do
      {:ok, id}
    else
      {:error, :user_not_found, :put_message, "Usuario no encontrado"}
    end
  end

end
