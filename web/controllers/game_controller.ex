defmodule Quizzbuzz.GameController do
  use Quizzbuzz.Web, :controller

  def index(conn, params) do
    case Passport.Plug.current_user(conn, params).assigns.current_user do
      nil -> conn |> put_flash(:error, "You need to log in before you can play") |> redirect( to: page_path(conn, :index))
      user -> render conn, "index.html"
    end
  end
end
