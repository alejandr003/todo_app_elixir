defmodule TodoApp.Notes do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias TodoApp.Repo

  schema "notes" do
    field :title, :string
    field :subtitle, :string
    field :content, :string
    belongs_to :user, TodoApp.Accounts.Users

    timestamps()
  end

  def changeset(note, attrs) do
    note
    |> cast(attrs, [:title, :subtitle, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> validate_length(:title, min: 1, max: 100)
    |> validate_length(:subtitle, max: 150)
  end

  def create_note(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  def get_note_by_id_and_user(id, user_id) do
    Repo.get_by(__MODULE__, id: id, user_id: user_id)
  end

  def update_note(note, attrs) do
    note
    |> changeset(attrs)
    |> Repo.update()
  end

  def delete_note(note) do
    Repo.delete(note)
  end

  def list_notes_by_user(user_id) do
    Repo.all(from n in __MODULE__, where: n.user_id == ^user_id)
  end
end
