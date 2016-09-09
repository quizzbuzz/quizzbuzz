defmodule Quizzbuzz.GameChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("game:" <> room, _, socket) do
    game = set_game
    {:ok, _} = GenServer.start_link(__MODULE__, game.questions, name: :game1)
    question = GenServer.call(:game1, :pop)
    {:ok, question, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("answer", payload, socket) do
    question = GenServer.call(:game1, :pop)
    #do something the payload.answer
    push socket, "new_question", question
    {:noreply, socket}
  end

  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket} #does response payload need to be in this format?
  end


  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end


  defp set_game do
    game = last_game
    questions = shuffle(game.questions)
    %{questions: questions}
  end

  defp shuffle(questions) do
    Enum.shuffle(Enum.map questions, fn(question) -> %{
      question: %{
        body: question.body,
        answer: question.answer,
        options: Enum.shuffle(question.options)
      }
    }
    end)
  end

  # defp game_info(game) do
  #   %{
  #     topic: game.topic
  #   }
  # end

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
