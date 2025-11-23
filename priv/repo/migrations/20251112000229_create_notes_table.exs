defmodule TodoApp.Repo.Migrations.CreateNotesTable do
  use Ecto.Migration

  def change do
    create table (:notes) do
      add :title, :string, null: false
      add :subtitle, :string
      add :content, :text, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:notes, [:user_id])
  end
end
