defmodule TodoApp.Accounts.RevokedToken do
  use Ecto.Schema
  import Ecto.Changeset

  schema "revoked_tokens" do
    field :token, :string
    belongs_to :user, TodoApp.Accounts.Users
    timestamps()
  end

  def changeset(token, attrs) do
    token
    |> cast(attrs, [:token, :user_id])
    |> validate_required([:token, :user_id])
  end
end
