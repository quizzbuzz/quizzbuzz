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

  test "creates game id based on users' email" do

  end

  test "waits for two player in channel" do
    push socket, "join_one_player_game", %{}
    assert_push "game_ready", %{game_id: "one_player:ueuoijewow"}
  end

  test "waits for both players to answer" do

  end
  test "posts chat messages" do
    push socket, "message", %{"body" => "hello"}
    assert_broadcast "message", %{"body" => "hello"}
  end
end
