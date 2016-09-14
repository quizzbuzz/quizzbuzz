defmodule Quizzbuzz.BoardController do
  use Quizzbuzz.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(Quizzbuzz.User))
    |> render("index.html", %{high_scores: get_high_scores})
  end

  def get_high_scores do
    Quizzbuzz.User.all_high_scores
    |> format_scores
  end

  def format_scores(users) do
    Enum.map users, fn(user)->
      ["#{user.username}",
      "#{user.high_score}"]

    end
  end

end
