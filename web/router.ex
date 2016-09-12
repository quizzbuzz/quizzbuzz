defmodule Quizzbuzz.Router do
  use Quizzbuzz.Web, :router
  use Passport

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :current_user
  end

  scope "/", Quizzbuzz do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/game", GameController, :index
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/forget-password", PasswordController, :forget_password
    post "/reset-password", PasswordController, :reset_password
    get "/leaderboard", BoardController, :index
  end


end
