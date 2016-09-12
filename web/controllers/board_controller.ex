defmodule Quizzbuzz.BoardController do
  use Quizzbuzz.Web, :controller

  def index(conn, _params) do
    conn
    |> assign(:users, Repo.all(Quizzbuzz.User))
    |> render("index.html")
  end

end
