defmodule Quizzbuzz.OnePlayerChannelTest do
  use ExUnit.Case, async: false
  use Quizzbuzz.ChannelCase
  use Phoenix.Socket

  import Quizzbuzz.Factory

  alias Quizzbuzz.OnePlayerChannel

  setup do

    insert(:question)
    insert(:question)
    user = insert(:user)

    {:ok, game, socket} =
      socket("game", %{current_user: %{email: user.email, id: user.id}})
      |> subscribe_and_join(OnePlayerChannel, "one_player:lobby")

    {:ok, game_info: game, socket: socket}

  end


  test "new question is returned when player is ready", %{socket: socket} do
    push socket, "ready", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
  end

  test "new question is returned when an answer is received", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
  end

  test "game is ended after questions are all answered", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "end_game", %{:result => "You Win"}
  end

  test "when a game ends with a new high score it is added to the user" do

  end

  test "when a game ends without a new high score it is not added to the user" do

  end

  test "when a players first game ends a new high score is added" do

  end

  test "if a user has a previously unfinished game the server restarts" do

  end



end
