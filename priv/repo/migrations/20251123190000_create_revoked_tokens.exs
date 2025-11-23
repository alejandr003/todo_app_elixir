defmodule TodoApp.Repo.Migrations.CreateRevokedTokens do
  use Ecto.Migration

  def change do
    create table(:revoked_tokens) do
      add :token, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create unique_index(:revoked_tokens, [:token])
    create index(:revoked_tokens, [:user_id])
  end
end
