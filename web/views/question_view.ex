defmodule Quizzbuzz.QuestionView do
  use Quizzbuzz.Web, :view

  def render("index.json", %{questions: questions}) do
    %{
      round: question_json(questions)
    }
  end

  defp question_json(question) do
    %{
      question: %{
        id: question.id,
        body: question.body,
        options: question.options,
        answer: question.answer
      }
    }
  end
end
