defmodule Elixir.Quizzbuzz.TwoPlayersChannel do
  use Quizzbuzz.Web, :channel
  import Quizzbuzz.GameHelper

  alias Quizzbuzz.Game.Server
  alias Phoenix.Socket

  @game_size 2
  @room_prefix "two_player:"


  def join(@room_prefix <> game_id, payload, socket) do
    start_new_game(game_id)
    {:ok, Socket.assign(socket, :game_id, game_id) }
  end

  def handle_in("ready", payload, socket) do
    case handle_answer(payload, socket, @game_size) do
      :queue_not_full -> push socket, "waiting", %{}
      {:end_game, players} -> report_results(players)
      {:question, question} -> broadcast! socket, "new_question", question
    end
    {:noreply, socket}
  end

  def handle_in("answer", payload, socket) do
    case handle_answer(payload, socket, @game_size) do
      :queue_not_full -> push socket, "waiting", %{}
      {:end_game, players} -> report_results(players)
      {:question, question} -> broadcast! socket, "new_question", question
    end
    {:noreply, socket}
  end


  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    broadcast! socket, "user_left", %{deserter: socket.assigns.current_user.username}
    Server.end_game(server_ids(socket))
  end

  defp report_results(players) do
    [winner | losers] = sort_results(players)
    push winner.socket, "end_game", %{result: "You Win", winner_score: winner.payload["score"]}
    Enum.each(losers, &( push &1.socket, "end_game",  %{result: "You Lose", winner_score: winner.payload["score"]}))
    update_scores(players)
  end
end
