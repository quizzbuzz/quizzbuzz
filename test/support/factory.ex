defmodule Quizzbuzz.Factory do
  use ExMachina.Ecto, repo: Quizzbuzz.Repo

  def question_factory do
    %Quizzbuzz.Question{
        body: "How many roads must a man walk down, before you can call him a man?",
        options: ["1", "3", "5", "42"],
        answer: "42"
      }
  end
end
