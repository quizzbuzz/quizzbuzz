defmodule Quizzbuzz.User do
  use Quizzbuzz.Web, :model
  alias Passport.Password

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :high_score, :integer
    field :username, :string

    timestamps
  end

  def changeset(model, params \\ :empty) do model
    |> cast(params, ~w(email), [])
    |> validate_length(:email, min: 1, max: 150)
    |> unique_constraint(:email)
  end

  def update_score(score, user_id) do
    user = Quizzbuzz.Repo.get!(Quizzbuzz.User, user_id)
    IO.inspect user
    changeset = score_changeset(user, %{high_score: score})
    Quizzbuzz.Repo.update(changeset)
  end

  def score_changeset(model, params \\ :empty) do model
    |> cast(params, [:high_score])
  end


  def registration_changeset(model, params) do model
    |> changeset(params)
    |> cast(params, ~w(password), [])
    |> validate_length(:password, min: 6, max: 100)
    |> put_hashed_password()
    |> cast(params, ~w(username), [])
    |> validate_length(:username, min: 4, max: 60)
    |> unique_constraint(:username)
  end

  defp put_hashed_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Password.hash(pass))
        _ ->
          changeset
    end
  end

  def all_high_scores do
    Ecto.Query.from(u in Quizzbuzz.User, order_by: [desc: u.high_score], limit: 20, select: u)
    |> Quizzbuzz.Repo.all
  end


end
