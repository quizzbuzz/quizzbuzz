defmodule Quizzbuzz.QuestionController do
  use Quizzbuzz.Web, :controller

  alias Quizzbuzz.Question

  def index(conn, _params) do
    questions = last_question
    render conn, "index.json", questions: questions
  end

  defp last_question do
    Repo.one(from questions in Quizzbuzz.Question,
                    order_by: [desc: questions.id],
                    limit: 1)
  end

end
