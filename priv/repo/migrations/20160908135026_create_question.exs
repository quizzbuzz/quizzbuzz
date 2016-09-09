defmodule Quizzbuzz.Repo.Migrations.CreateQuestion do
  use Ecto.Migration

  def change do
    create table(:questions) do
      add :body, :text
      add :options, {:array, :string}
      add :answer, :string

      timestamps()
    end

  end
end
