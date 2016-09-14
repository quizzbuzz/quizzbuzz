defmodule Quizzbuzz.GameLobbyChannelTest do
  use Quizzbuzz.ChannelCase
  use Phoenix.Socket

  import Quizzbuzz.GameLobbyChannel

  alias Quizzbuzz.GameLobbyChannel

  setup do
    user = insert(:user)
    question = insert(:question)

    {:ok, two_player_game, socket} =
      socket("two_player_game", %{current_user: %{email: user.email, username: user.username, high_score: user.high_score}})
      |> subscribe_and_join(GameLobbyChannel, "game_lobby")

    {:ok, socket: socket}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "sends the game_id", %{socket: socket} do
    push socket, "join_one_player_game", %{"email" => "njewc@ncjj.com"}
    assert_push "game_ready", %{game_id: _}
  end

  test "waits for both players to answer", %{socket: socket} do

  end
  # test "posts chat messages", %{socket: socket} do
  #   push socket, "message", %{"body" => "hello"}
  #   assert_broadcast "message", %{"body" => "hello"}
  #   assert_receive %Phoenix.Socket.Broadcast{topic: "game_lobby", event: message, payload: %{"body" => "hello"}}
  # end
  test "once there enough players ready is sent", %{socket: socket} do


  end
end
