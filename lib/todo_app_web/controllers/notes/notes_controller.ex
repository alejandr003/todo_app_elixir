defmodule TodoAppWeb.Notes.NotesController do
  use TodoAppWeb, :controller
  alias TodoApp.Notes

  action_fallback TodoAppWeb.FallbackController

  #
  # CREATE
  #
  def create(conn, %{"note" => note_params}) do
    user = conn.assigns.current_user
    attrs = Map.put(note_params, "user_id", user.id)

    with {:ok, note} <- Notes.create_note(attrs) do
      conn
      |> put_status(:created)
      |> json(%{data: format_note(note)})
    end
  end

  #
  # UPDATE
  #
  def update(conn, %{"id" => id, "note" => note_params}) do
    user = conn.assigns.current_user

    with note when not is_nil(note) <- Notes.get_note_by_id_and_user(id, user.id),
         {:ok, updated_note} <- Notes.update_note(note, note_params) do
      json(conn, %{data: format_note(updated_note)})
    else
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Nota no encontrada"})
    end
  end

  #
  # DELETE
  #
  def delete(conn, %{"id" => id}) do
    user = conn.assigns.current_user

    with note when not is_nil(note) <- Notes.get_note_by_id_and_user(id, user.id),
         {:ok, _} <- Notes.delete_note(note) do
      json(conn, %{message: "Nota eliminada exitosamente"})
    else
      nil ->
        conn |> put_status(:not_found) |> json(%{error: "Nota no encontrada"})
    end
  end

  #
  # LIST / INDEX
  #
  def index(conn, _params) do
  user = conn.assigns.current_user
  notes = Notes.list_notes_by_user(user.id)
  json(conn, %{data: notes})
end

  #
  # Helper
  #
  defp format_note(note) do
    %{
      id: note.id,
      title: note.title,
      subtitle: note.subtitle,
      content: note.content,
      user_id: note.user_id,
      inserted_at: note.inserted_at,
      updated_at: note.updated_at
    }
  end
end
