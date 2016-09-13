defmodule Quizzbuzz.GameLobbyChannel do
  use Quizzbuzz.Web, :channel
  use GenServer


  def join("game_lobby", payload, socket) do
    try do
      GenServer.start(__MODULE__, [], name: :two_player_queue)
    catch
      {:error, _} -> IO.puts "Server already started, error handled"
    end
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("join_two_player_queue", payload, socket) do
    GenServer.call(:two_player_queue, {:push, socket})
    {:noreply, socket}
  end
  def handle_in("join_one_player_game", payload, socket) do
    game_id = hash_id([socket, socket, socket])
    push socket,"game_ready", %{game_id: "one_player:#{game_id}"}
    {:noreply, socket}
  end

  def handle_call({:push, socket}, _from, []) do
    IO.puts "================"
    IO.puts "1 a single player joined an empty queue in lobby"
    IO.puts "================"
    {:reply, :wait, [socket]}
  end

  def handle_call({:push, socket}, _from, list) do
    IO.puts "================"
    IO.puts "=======QUEUE========="
    IO.inspect list
    IO.puts "================"
    IO.puts "================"
    IO.puts "================"
    IO.puts "2 another player joins the queue and they are sent thier game_id"
    IO.puts "================"
    players = [socket | list]
    game_id = hash_id(players)
    Enum.each players, &(push &1, "game_ready", %{game_id: "two_player:#{game_id}"})
    {:reply, :go, []}
  end

  def hash_id(sockets) do
    Enum.map(sockets, &( &1.assigns.current_user.email))
      |> to_string |> Base.url_encode64 |> binary_part(0, 20)
  end
  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_lobby:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
