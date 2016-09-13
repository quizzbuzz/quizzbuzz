defmodule Elixir.Quizzbuzz.TwoPlayersChannel do
  use Quizzbuzz.Web, :channel
  use GenServer

  def join("two_player:" <> game_id, payload, socket) do
    queue_name = to_atom( "queue#{game_id}" )
    try do
      GenServer.start_link(__MODULE__, [], name: queue_name)
    catch
      {:error, _} -> IO.puts "Server already started, error handled"
    end
    {:ok, Phoenix.Socket.assign(socket, %{game_id: game_id})}
  end

  def handle_in("ready", payload, socket) do
    queue_name = to_atom( "queue#{socket.assigns.game_id}" )
    case GenServer.call(queue_name, {:wait, socket, payload}) do
      :wait -> push socket, "waiting", %{}
      [socket|tail] -> fn -> {:ok, question} = start_new_game(socket)
                broadcast socket, "new_question", question
              end
    end
    {:noreply, socket}
  end

  def handle_in("answer", payload, socket) do
    game_id = to_atom(socket.assigns.game_id)
    queue_name = to_atom( "queue#{socket.assigns.game_id}" )
    case GenServer.call(queue_name, {:wait, socket, payload}) do
      :wait -> "nothing"
      {:go, players = [head | _]} -> case GenServer.call(game_id, :pop) do
        :end_game ->
          report_results(players)
        question -> broadcast head.socket, "new_question", question
      end
    end

    {:noreply, socket}
  end

  defp start_new_game(socket) do
    questions = build_game
    game_id = to_atom( socket.assigns.game_id )
    {:ok, _} = GenServer.start(__MODULE__, questions, name: game_id)
    {:ok, GenServer.call(game_id, :pop)}
  end

  defp report_results(players) do
    sort_results(players)
    |> update_scores
    case players do
      [h | t] -> fn(h,t) -> push h.socket, "end_game", %{result: "You Win", winner_score: h.payload["score"]}
        Enum.each(t, &( push &1.socket, "end_game",  %{result: "You Lose", winner_score: h.payload["score"]}))
      end
    end
  end

  defp sort_results(players) do
    Enum.sort_by players, fn(x) -> x.score end, &>=/2
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
    new_score = player.score
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


  def handle_call(:pop, _from, []) do
    {:reply,:end_game, []}
  end
  def handle_call(:pop, _from, [h | t]) do
    {:reply, h, t}
  end

  def hande_call({:wait, socket, payload}, _from, []) do
    {:reply, :wait, [%{socket: socket, payload: payload}]}
  end
  def hande_call({:wait, socket, payload}, _from, queue) do
    player = %{socket: socket, payload: payload}
    {:reply, [player | queue], []}
  end

  def handle_call({:push, payload, socket}, _from, []) do
    outcome = %{score: payload["score"], socket: socket}
    {:reply, :wait, [outcome]}
  end
  def handle_call({:push, payload, socket}, _from, list) do
    outcome = %{score: payload["final_score"], socket: socket}
    results = Enum.sort_by([outcome|list], &(&1.score), &>=/2)
    {:reply, results, []}
  end


end
