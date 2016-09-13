defmodule Quizzbuzz.GameLobbyChannelTest do
  use Quizzbuzz.ChannelCase

  alias Quizzbuzz.GameLobbyChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(GameLobbyChannel, "game_lobby")

    {:ok, socket: socket}
  end

  test "shout broadcasts to game_lobby:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
