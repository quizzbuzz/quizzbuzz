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
      email: "test@test.com",
      password: "password",
      id: 888
    }
  end
end
