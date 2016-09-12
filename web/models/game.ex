defmodule Quizzbuzz.Game do
  use Quizzbuzz.Web, :model

  schema "games" do
    field :title, :string
    field :topic, :string
    # has_many :questions, Quizzbuzz.Question


    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title, :topic])
    # |> cast_assoc(:questions, required: true)
    |> validate_required([:title, :topic])
  end
end
