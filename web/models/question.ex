defmodule Quizzbuzz.Question do
  use Quizzbuzz.Web, :model

  schema "questions" do
    field :body, :string
    field :options, {:array, :string}
    field :answer, :string

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
end
