defmodule TodoApp.Accounts.PasswordResetToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "password_reset_tokens" do
    field :token, :string
    field :email, :string
    field :expires_at, :utc_datetime
    field :used, :boolean, default: false
    timestamps()
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :email, :expires_at, :used])
    |> validate_required([:token, :email, :expires_at])
  end
end
