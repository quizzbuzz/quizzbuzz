defmodule Quizzbuzz.RoomController do
  use Quizzbuzz.Web, :controller

  def index(conn, _params) do
    render conn, "index"
  end
end
