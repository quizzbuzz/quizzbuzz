defmodule Quizzbuzz.Repo.Migrations.AddBelongsToRelationToQuestion do
  use Ecto.Migration

  def change do
    alter table(:questions) do
      add :game_id, references(:games)
    end
  end
end
