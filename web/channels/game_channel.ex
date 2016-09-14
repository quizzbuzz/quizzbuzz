defmodule Quizzbuzz.GameChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("one_player:" <> game_id, _, socket) do
    {:ok, Phoenix.Socket.assign(socket, :game_id, game_id)}
  end

  def handle_in("answer", payload, socket) do
    game_id = get_game_id(socket)
    case GenServer.call(game_id, :pop) do
      :end_game -> report_results(payload, socket)
      question -> push socket, "new_question", question
    end
    {:noreply, socket}
  end

  def handle_in("ready", payload, socket) do
    {:ok, question} = start_new_game(socket)
    push socket, "new_question", question
    {:noreply, socket}
  end

  defp start_new_game(socket) do
    questions = build_game
    game_id = get_game_id(socket)

    case GenServer.start(__MODULE__, questions, name: game_id) do
      {:ok, _} -> {:ok, GenServer.call(game_id, :pop)}
      {:error, _} ->
        GenServer.stop(game_id, "New Game being made")
        start_new_game(socket)
    end
  end

  defp report_results(payload, socket) do
    update_score(payload,socket)
    push socket, "end_game", %{result: "You Win"}
  end

  defp update_score(payload, socket) do
    score = payload["score"]
    user_id = socket.assigns.current_user.id
    user =  Quizzbuzz.Repo.get!(Quizzbuzz.User, user_id)
    cond do
      user.high_score < score ->
        Quizzbuzz.User.update_score(score, user_id)
      user.high_score == nil ->
        Quizzbuzz.User.update_score(score, user_id)
      true ->
          IO.puts "something else"
    end

  end

  defp get_game_id(socket) do
    String.to_char_list(socket.assigns.game_id)
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
    {:stop,:end_game, :end_game, []}
  end
  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end
end
