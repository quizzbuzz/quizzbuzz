defmodule Quizzbuzz.GameLobbyChannel do
  use Quizzbuzz.Web, :channel

  GenServer.start(__MODULE__, [], name: :two_player_queue)

  def join("game_lobby", payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("join_two_player_queue", payload, socket) do
    GenServer.call(:two_player_queue, {:push, socket})
    {:noreply, socket}
  end

  def handle_call({:push, socket}, _from, []) do
    {:reply, :wait, [socket]}
  end
  def handle_call({:push, socket}, _from, list) do
    Enum.each(list, &( push, &1, "game_ready", %{game_id: HASHED_ID GOES HERE} ))
    {:reply, :wait, []}
  end

  def hash_id do
    
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