defmodule Quizzbuzz.GameChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("game:" <> room, _, socket) do
    game = set_game
    {:ok, _} = GenServer.start_link(__MODULE__, game.questions, name: :game1)
    IO.inspect GenServer.call(:game1, :pop)
    {:ok, game.game_info, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    IO.inspect payload
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end


  defp set_game do
    game = last_game
    game_info = game_info(game)
    questions = game.questions
    %{game_info: game_info, questions: questions}
  end

  defp game_info(game) do
    %{
      title: game.title,
      topic: game.topic
    }
  end

  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  defp last_game do
    Repo.one(from games in Quizzbuzz.Game,
                  preload: [:questions],
                    order_by: [desc: games.id],
                    limit: 1)
  end
  # Add authorization logic here as required.
end
