defmodule Quizzbuzz.Question do
  use Quizzbuzz.Web, :model

  schema "questions" do
    field :body, :string
    field :options, {:array, :string}
    field :answer, :string
    belongs_to :game, Quizzbuzz.Game

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:body, :options, :answer])
    |> cast_assoc(:questions, required: true)
    |> validate_required([:body, :options, :answer])
  end
end
