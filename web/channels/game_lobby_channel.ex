defmodule Quizzbuzz.GameLobbyChannel do
  use Quizzbuzz.Web, :channel

  def join("game_lobby", payload, socket) do
    LobbyQueue.start
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    username = socket.assigns.current_user.username
    push socket, "username", %{username: username}
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("join_two_player_queue", payload, socket) do
    case LobbyQueue.join(:two_player, socket) do
      :wait -> {:noreply, socket}
      players -> game_id = hash_id(players)
        IO.puts "GAME ID IS #{game_id}"
        IO.puts "======PLAYERS======"
        IO.inspect players
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

  def hash_id(sockets) do
    Enum.map(sockets, &( String.to_char_list(&1.assigns.current_user.email)
      |>Enum.shuffle |> to_string))
      |> to_string |> Base.url_encode64 |> binary_part(0, 20)
  end

  defp authorized?(_payload) do
    true
  end
end
