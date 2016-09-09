defmodule Quizzbuzz.QuestionTest do
  use Quizzbuzz.ModelCase

  alias Quizzbuzz.Question

  @valid_attrs %{answer: "some content", body: "some content", options: []}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Question.changeset(%Question{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Question.changeset(%Question{}, @invalid_attrs)
    refute changeset.valid?
  end
end
