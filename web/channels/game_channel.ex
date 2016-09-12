defmodule Quizzbuzz.GameChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("game:" <> room, _, socket) do
    {:ok, socket}
  end

  def handle_in("answer", payload, socket) do
    game_id = get_game_id(payload)
    case GenServer.call(game_id, :pop) do
      :end_game -> report_results(payload, socket)
      question -> push socket, "new_question", question
    end
    {:noreply, socket}
  end

  def handle_in("ready", payload, socket) do
    {:ok, question} = start_new_game(payload)
    push socket, "new_question", question
    {:noreply, socket}
  end

  defp start_new_game(payload) do
    questions = build_game
    game_id = get_game_id(payload)
    {:ok, _} = GenServer.start(__MODULE__, questions, name: game_id)
    {:ok, GenServer.call(game_id, :pop)}
  end

  defp report_results(payload, socket) do
    game_id = get_game_id(payload)
    push socket, "end_game", %{result: "You Win"}
  end

  defp get_game_id(payload) do
    String.to_char_list(payload["user_id"])
    |> :erlang.list_to_atom
  end

  defp build_game do
    Quizzbuzz.Question.random
    |> shuffle
  end

  defp shuffle(questions) do
    Enum.map questions, fn(question) -> %{
      question: %{
        body: question.body,
        answer: question.answer,
        options: Enum.shuffle(question.options)
      }
    }
    end
  end

  def handle_call(:pop, _from, []) do
    {:reply,:end_game, []}
  end
  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end
end
