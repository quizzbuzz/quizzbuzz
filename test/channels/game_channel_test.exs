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

  test "game info is returned on join of the lobby" do

  end

  test "new question is returned on the reveival of an answer", %{socket: socket} do
    push socket, "answer", %{"answer" => "1"}
    assert_push "new_question", %{question:
                                  %{answer: "1",
                                  body: "How many roads must a man walk down before he is a man?",
                                  options: [_, _, _, _]}}
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
