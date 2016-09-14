defmodule Quizzbuzz.Factory do
  use ExMachina.Ecto, repo: Quizzbuzz.Repo

  alias Quizzbuzz.Question
  alias Quizzbuzz.User

  def question_factory do
    %Question{
      body: "How many roads must a man walk down before he is a man?",
      options: ["1","2","3","4"],
      answer: "1",
    }
  end
  def user_factory do
    %User{
      email: "testingemail@test.com",
      password: "password",
      username: "testytest",
      high_score: 1,
      id: 888
    }
  end
end
