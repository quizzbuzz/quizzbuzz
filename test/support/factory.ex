defmodule Quizzbuzz.Factory do
  use ExMachina.Ecto, repo: Quizzbuzz.Repo

  alias Quizzbuzz.Game
  alias Quizzbuzz.Question

  def game_factory do
    %Game{
      title: "Game 1",
      topic: "Philosophy",
      questions: [%Question{
      body: "How many roads must a man walk down before he is a man?",
      options: ["1","2","3","4"],
      answer: "1",
    }]
    }
  end

end
