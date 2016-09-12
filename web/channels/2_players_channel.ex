defmodule Elixir.Quizzbuzz.TwoPlayersChannel do
  use Quizzbuzz.Web, :channel

  def join("2_players:" <> game_id, payload, socket) do
    {:ok, socket}
  end

  def handle_in("ready", payload, socket) do
    {:ok, question} = start_new_game(payload)
    push socket, "new_question", question
    {:noreply, socket}
  end

  def handle_in("answer", payload, socket) do
    game_id = get_game_id(payload)
    case GenServer.call(game_id, :pop) do
      :end_game -> report_results(payload, socket)
      question -> push socket, "new_question", question
    end
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
    case GenServer.call(game_id, {:push, payload, socket}) do
      :wait -> IO.puts "waiting for results"
      [h | t] -> fn(h,t) -> push h.socket, "end_game", %{result: "You Win"}
        Enum.each(t, &( push &1.socket, "end_game",  %{result: "You Loose"}))
      end
    end
  end

  defp get_game_id(payload) do
    String.to_char_list(payload["game_id"])
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
  
  def handle_call({:push, payload, socket}, _from, []) do
    outcome = %{score: payload["final_score"], socket: socket}
    {:reply, :wait, outcome}
  end
  def handle_call({:push, payload, socket}, _from, list) do
    outcome = %{score: payload["final_score"], socket: socket}
    results = Enum.sort_by([outcome|list], &(&1.score), &>=/2))
    {:reply, results, []}
  end


end
