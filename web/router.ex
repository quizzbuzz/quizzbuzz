defmodule Quizzbuzz.Router do
  use Quizzbuzz.Web, :router
  use Passport

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Quizzbuzz do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/game", GameController, :index
    get "/login", SessionController, :new
    post "/session", SessionController, :create
    get "/logout", SessionController, :delete
    get "/join", RegistrationController, :new
    post "/register", RegistrationController, :create
    get "/passwords/new", PasswordController, :new
    post "/passwords", PasswordController, :reset
  end


end
