defmodule Quizzbuzz.GameLobbyChannel do
  use Quizzbuzz.Web, :channel
  alias Quizzbuzz.ChannelMonitor

  def join("game_lobby", payload, socket) do
    current_user = socket.assigns.current_user
    users = ChannelMonitor.user_joined("game_lobby", current_user)["game_lobby"]
    send self, {:after_join, users}
    LobbyQueue.start
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("join_two_player_queue", payload, socket) do
    IO.puts "Join two player queue message receieved"
    case LobbyQueue.join(:two_player, socket) do
      :wait -> {:noreply, socket}
      players -> game_id = hash_id(players)
        Enum.each players, &(push &1, "game_ready", %{game_id: "two_player:#{game_id}"})
    end
    {:noreply, socket}
  end

  def handle_in("join_twenty_player_queue", payload, socket) do
    case LobbyQueue.join(:twenty_player, socket) do
      :wait -> {:noreply, socket}
      players -> game_id = hash_id(players)
        Enum.each players, &(push &1, "game_ready", %{game_id: "twenty_player:#{game_id}"})
    end
    {:noreply, socket}
  end

  def handle_in("join_one_player_game", payload, socket) do
    game_id = hash_id([socket, socket, socket])
    push socket,"game_ready", %{game_id: "one_player:#{game_id}"}
    {:noreply, socket}
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    user_id = socket.assigns.current_user.id
    users = ChannelMonitor.user_left("game:lobby", user_id)["game:lobby"]
    lobby_update(socket, users)
    :ok
  end

  def handle_info({:after_join, users}, socket) do
    lobby_update(socket, users)
    {:noreply, socket}
  end

  defp lobby_update(socket, users) do
    broadcast! socket, "lobby_update", %{ users: get_usernames(users) }
  end

  defp get_usernames(nil), do: []
  defp get_usernames(users) do
    Enum.map users, &(&1.username)
  end


  def hash_id(sockets) do
    Enum.map(sockets, &( &1.assigns.current_user.email))
      |> to_string |> Base.url_encode64 |> binary_part(0, 20)
  end

  defp authorized?(_payload) do
    true
  end
end
