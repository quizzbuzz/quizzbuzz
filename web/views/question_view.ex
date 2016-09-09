defmodule Quizzbuzz.GameView do
  use Quizzbuzz.Web, :view

  def render("index.json", %{game: game}) do
    [question | _ ] = game_json(game).game.questions
    IO.inspect question.options
  end

  defp game_json(game) do
    %{
      game: %{
        id: game.id,
        title: game.title,
        topic: game.topic,
        questions: game.questions
      }
    }
  end
end
