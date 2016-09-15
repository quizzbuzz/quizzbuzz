defmodule Quizzbuzz.OnePlayerChannelTest do
  use ExUnit.Case, async: false
  use Quizzbuzz.ChannelCase
  use Phoenix.Socket

  import Quizzbuzz.Factory

  alias Quizzbuzz.OnePlayerChannel

  def create_user(email, username, password) do
    %User{}
    |> User.changeset(%{email: email, username: username, password: password})
    |> Repo.insert
  end

  setup do

    insert(:question)
    insert(:question)
    user = insert(:user)

    {:ok, game, socket} =
      socket("game", %{current_user: %{email: user.email, id: user.id}, high_score: nil})
      |> subscribe_and_join(OnePlayerChannel, "one_player:lobby")

    {:ok, game_info: game, socket: socket}

  end


  test "new question is returned when player is ready", %{socket: socket} do
    push socket, "ready", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
    leave socket
  end

  test "new question is returned when an answer is received", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
    leave socket
  end

  test "game is ended after questions are all answered", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "end_game", %{:result => "You Win"}
    leave socket
  end

  test "when a game ends with a new high score it is added to the user", %{socket: socket} do
    
  end

  test "if a user has a previously unfinished game the server restarts", %{socket: socket} do

  end



end
