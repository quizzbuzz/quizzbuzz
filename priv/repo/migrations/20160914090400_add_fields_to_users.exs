defmodule Quizzbuzz.Repo.Migrations.AddFieldsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end
  end
end
