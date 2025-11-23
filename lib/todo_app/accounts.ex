defmodule TodoApp.Accounts do
  alias TodoApp.Repo
  alias TodoApp.Accounts.Users
  alias TodoApp.Accounts.PasswordResetToken
  import Ecto.Query, warn: false

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
  end


  def get_user_by_id(id) do
    Repo.get(Users, id)
  end

  def request_password_reset(email, url) do
    user = get_user_by_email(email)
    if user do
      token = generate_reset_token()
      expires_at = DateTime.add(DateTime.utc_now(), 3600, :second)
      %PasswordResetToken{}
      |> PasswordResetToken.changeset(%{
        token: token,
        email: email,
        expires_at: expires_at
      })
      |> Repo.insert!()
      TodoApp.Emails.send_password_reset_email(user, token, url)
      {:ok, token}
    else
      {:error, :user_not_found}
    end
  end

  def reset_password(token, new_password) do
    reset_token = Repo.get_by(PasswordResetToken, token: token, used: false)
    cond do
      is_nil(reset_token) -> {:error, :invalid_or_expired_token}
      DateTime.compare(reset_token.expires_at, DateTime.utc_now()) != :gt -> {:error, :invalid_or_expired_token}
      true ->
        user = get_user_by_email(reset_token.email)
        if user do
          user
          |> Users.registration_changeset(%{"password" => new_password})
          |> Repo.update!()
          reset_token
          |> Ecto.Changeset.change(used: true)
          |> Repo.update!()
          {:ok, user}
        else
          {:error, :user_not_found}
        end
    end
  end

  defp generate_reset_token do
    :crypto.strong_rand_bytes(32) |> Base.url_encode64()
  end
end
