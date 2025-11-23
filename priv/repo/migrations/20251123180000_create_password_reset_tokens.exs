defmodule TodoApp.Repo.Migrations.CreatePasswordResetTokens do
  use Ecto.Migration

  def change do
    create table(:password_reset_tokens) do
      add :token, :string, null: false
      add :email, :string, null: false
      add :expires_at, :utc_datetime, null: false
      add :used, :boolean, default: false
      timestamps()
    end

    create unique_index(:password_reset_tokens, [:token])
    create index(:password_reset_tokens, [:email])
  end
end
