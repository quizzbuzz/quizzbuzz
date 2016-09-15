defmodule Quizzbuzz.Game.ServerTest do
  use Quizzbuzz.ChannelCase
  use GenServer

  import Quizzbuzz.GameLobbyChannel

  alias Quizzbuzz.Game.Server

  test "start" do
    Server.start(:name)
    assert_receive({:ok, _})
  end

  test "addtoqueue" do

  end

  test "pop" do

  end

  test "end_game" do

  end
end
