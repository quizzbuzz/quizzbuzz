defmodule Quizzbuzz.Question do

  use Quizzbuzz.Web, :model
  require Ecto.Query

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
    |> validate_required([:body, :options, :answer])
  end

  def random do
    Ecto.Query.from(q in Quizzbuzz.Question, order_by: fragment("RANDOM()"), limit: 10, select: q)
    |> Quizzbuzz.Repo.all
   end
end
