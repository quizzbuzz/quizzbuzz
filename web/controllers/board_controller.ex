defmodule Quizzbuzz.BoardController do
  use Quizzbuzz.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

end