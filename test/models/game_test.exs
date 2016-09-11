defmodule Quizzbuzz.GameTest do
  use Quizzbuzz.ModelCase

  alias Quizzbuzz.Game
  
  @valid_attrs %{title: "some content", topic: "some content", questions: [
    %{
      body: "How many roads must a man walk down before he is a man?",
      options: ["1","2","3","4"],
      answer: "1"
    }]
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Game.changeset(%Game{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Game.changeset(%Game{}, @invalid_attrs)
    refute changeset.valid?
  end
end
