defmodule Quizzbuzz.RegistrationController do
  use Quizzbuzz.Web, :controller

  alias Quizzbuzz.User

  def new(conn, _params) do
    changeset = User.changeset(%Quizzbuzz.User{})
    conn
    |> render(:new, changeset: changeset)
  end

  def create(conn, %{"user" => registration_params}) do
    changeset = User.registration_changeset(%User{}, registration_params)
    case Repo.insert(changeset) do
      {:ok, user} ->
        Quizzbuzz.SessionController.create(conn, %{"session" => %{"email" => user.email, "password" => user.password}})
        conn
        |> put_flash(:info, "Account created!")
        |> redirect(to: page_path(conn, :index))
      {:error, changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

end
