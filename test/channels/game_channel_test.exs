defmodule Quizzbuzz.GameChannelTest do
  use Quizzbuzz.ChannelCase
  alias Quizzbuzz.GameChannel

  setup do
    insert(:game)
    {:ok, game_info, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(GameChannel, "game:lobby")

      IO.inspect game_info

    {:ok, game_info: game_info, socket: socket}
  end

  test "game info is returned on join of the lobby" do

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
