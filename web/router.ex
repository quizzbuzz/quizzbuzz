defmodule Quizzbuzz.Router do
  use Quizzbuzz.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Quizzbuzz do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/game", GameController, :index
    get "/leaderboard", BoardController, :index
  end

end
