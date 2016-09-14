defmodule Elixir.Quizzbuzz.TwentyPlayersChannel do
  use Quizzbuzz.Web, :channel

  def join("twenty_player:" <> game_id, payload, socket) do
    queue_name = to_atom( "queue#{game_id}" )
    try do
      TwentyPlayerServer.start(queue_name)
    catch
      {:error, _} -> IO.puts "Server already started, error handled"
    end
    {:ok, Phoenix.Socket.assign(socket, :game_id, game_id) }
  end

  def handle_in("ready", payload, socket) do
    queue_name = to_atom( "queue#{socket.assigns.game_id}" )

    case TwentyPlayerServer.add_to_queue(queue_name, payload, socket) do
      :wait -> push socket, "waiting", %{}
      players -> {:ok, question} = start_new_game(socket)
                  IO.puts "In the broadcast function"
                Enum.each(players, &(push &1.socket, "new_question", question))

    end
    {:noreply, socket}
  end

  def handle_in("answer", payload, socket) do
    game_id = to_atom(socket.assigns.game_id)
    queue_name = to_atom( "queue#{socket.assigns.game_id}" )
    case TwentyPlayerServer.add_to_queue(queue_name, payload, socket) do
      :wait -> push socket, "waiting", %{}
      players = [head | tail] -> case TwentyPlayerServer.pop(game_id) do
        :end_game ->
          report_results(players)
        question -> broadcast! head.socket, "new_question", question
      end
    end

    {:noreply, socket}
  end

  defp start_new_game(socket) do
    questions = build_game
    game_id = to_atom( socket.assigns.game_id )
    {:ok, _} = TwentyPlayerServer.start_new_game(game_id, questions)
    {:ok, TwentyPlayerServer.pop(game_id)}
  end

  defp report_results(players) do
    [winner | losers] = sort_results(players)
    push winner.socket, "end_game", %{result: "You Win", winner_score: winner.payload["score"]}
    Enum.each(losers, &( push &1.socket, "end_game",  %{result: "You Lose", winner_score: winner.payload["score"]}))
    update_scores(players)
  end

  defp sort_results(players) do
    Enum.sort_by players, fn(x) -> x.payload["score"] end, &>=/2
  end

  defp to_atom(string) do
    String.to_char_list(string)
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

  defp update_scores(players) do
    Enum.each(players, fn(player) -> update_score(player) end)
  end

  defp update_score(player) do
    new_score = player.payload["score"]
    user =  Quizzbuzz.Repo.get!(Quizzbuzz.User, player.socket.assigns.current_user.id)
    cond do
      user.high_score < new_score ->
        Quizzbuzz.User.update_score(new_score, user.id)
      user.high_score == nil ->
        Quizzbuzz.User.update_score(new_score, user.id)
      true ->
          IO.puts "something else"
    end
  end
end
