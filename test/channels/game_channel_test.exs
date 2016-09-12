defmodule Quizzbuzz.GameChannelTest do
  use Quizzbuzz.ChannelCase

  import Quizzbuzz.Factory

  alias Quizzbuzz.GameChannel

  setup do

    insert(:game)
    {:ok, game, socket} =
      socket("game", %{some: :assign})
      |> subscribe_and_join(GameChannel, "game:lobby")

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
    assert_push "end_game", %{"body" => "Hello"}
  end


  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to game:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
