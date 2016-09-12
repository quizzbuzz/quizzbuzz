defmodule Quizzbuzz.GameChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("game:" <> room, _, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("answer", payload, socket) do
    game_id = get_game_id(payload)
    case GenServer.call(game_id, :pop) do
      :end_game -> calculate_results(payload, socket)
      question -> push socket, "new_question", question
    end
    {:noreply, socket}
  end

  def handle_in("ready", payload, socket) do
    game = set_game
    game_id = get_game_id(payload)
    {:ok, _} = GenServer.start(__MODULE__, game.questions, name: game_id)
    question = GenServer.call(game_id, :pop)
    push socket, "new_question", question
    {:noreply, socket} #does response payload need to be in this format?
  end


  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game:lobby).

  defp calculate_results(payload, socket) do
    game_id = get_game_id(payload)
    push socket, "results", %{result: "You Win"}
  end

  defp set_game do
    game = build_game
    questions = shuffle(game)
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

  def handle_call(:pop, _from, []) do
    {:reply,:end_game, []}
  end
  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  defp get_game_id(payload) do
    String.to_char_list(payload["user_id"])
      |> :erlang.list_to_atom
  end

  defp build_game do
    Quizzbuzz.Question.random
  end
  # Add authorization logic here as required.
end
