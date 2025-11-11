defmodule TodoApp.Accounts.Users do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bcrypt

  @min_password_length 8
  @max_password_length 100

  schema "users" do
    field :name, :string
    field :last_name, :string
    field :email, :string
    field :hashed_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:name, :last_name, :email, :password])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_length(:last_name, min: 2, max: 50)
    |> validate_format(:email, ~r/^[\w._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$/)
    |> validate_length(:password, min: @min_password_length, max: @max_password_length)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
      |> delete_change(:password_confirmation)
    else
      changeset
    end
  end
end
