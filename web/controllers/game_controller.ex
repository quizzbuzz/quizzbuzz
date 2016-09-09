defmodule Quizzbuzz.GameController do
  use Quizzbuzz.Web, :controller

  alias Quizzbuzz.Game

  def index(conn, _params) do
    game = last_game
    render conn, "index.json", game: game
  end

  defp last_game do
    Repo.one(from game in Quizzbuzz.Game,
                    preload: [:questions],
                    order_by: [desc: game.id],
                    limit: 1)
  end

end
