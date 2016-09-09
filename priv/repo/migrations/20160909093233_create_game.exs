defmodule Quizzbuzz.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :title, :string
      add :topic, :string

      timestamps()
    end

  end
end
