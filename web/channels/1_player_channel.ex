defmodule Quizzbuzz.OnePlayerChannel do
  use Quizzbuzz.Web, :channel

  alias Game.Server
  alias Phoenix.Socket

  @game_size 1

  def join("one_player:" <> game_id, payload, socket) do
    queue_id = to_atom( "queue#{game_id}" )
    try do
      Server.start(queue_id)
    catch
      {:error, _} -> IO.puts "Server already started, error handled"
    end
    {:ok, Socket.assign(socket, :game_id, game_id) }
  end

  def handle_in("ready", payload, socket) do
    queue_id = to_atom( "queue#{socket.assigns.game_id}" )

    case Server.add_to_queue(queue_id, payload, socket, @game_size) do
      :wait -> push socket, "waiting", %{}
      players -> {:ok, question} = start_new_game(socket)
                IO.puts "In the broadcast function"
                Enum.each(players, &(push &1.socket, "new_question", question))

    end
    {:noreply, socket}
  end

  def handle_in("answer", payload, socket) do
    game_id = to_atom(socket.assigns.game_id)
    queue_id = to_atom( "queue#{socket.assigns.game_id}" )
    case Server.add_to_queue(queue_id, payload, socket, @game_size) do
      :wait -> push socket, "waiting", %{}
      players = [head | tail] -> case Server.pop(game_id) do
        :end_game ->
          report_results(players)
          Server.end_game([game_id, queue_id])
        question -> broadcast! head.socket, "new_question", question
      end
    end

    {:noreply, socket}
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: body}
    {:noreply, socket}
  end

  def handle_in("user_left", _payload, socket) do
    broadcast! socket, "user_left", %{deserter: socket.assigns.current_user.username}
    {:noreply, socket}
  end


  defp start_new_game(socket) do
    questions = build_game
    game_id = to_atom( socket.assigns.game_id )
    {:ok, _} = Server.start_new_game(game_id, questions)
    {:ok, Server.pop(game_id)}
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





  # #
  # #
  # #
  # #
  # use Quizzbuzz.Web, :channel
  # use GenServer
  #
  # def join("one_player:" <> game_id, _, socket) do
  #   {:ok, Phoenix.Socket.assign(socket, :game_id, game_id)}
  # end
  #
  # def handle_in("answer", payload, socket) do
  #   game_id = get_game_id(socket)
  #   case GenServer.call(game_id, :pop) do
  #     :end_game -> report_results(payload, socket)
  #     question -> push socket, "new_question", question
  #   end
  #   {:noreply, socket}
  # end
  #
  # def handle_in("ready", payload, socket) do
  #   {:ok, question} = start_new_game(socket)
  #   push socket, "new_question", question
  #   {:noreply, socket}
  # end
  #
  # defp start_new_game(socket) do
  #   questions = build_game
  #   game_id = get_game_id(socket)
  #
  #   case GenServer.start(__MODULE__, questions, name: game_id) do
  #     {:ok, _} -> {:ok, GenServer.call(game_id, :pop)}
  #     {:error, _} ->
  #       GenServer.stop(game_id, "New Game being made")
  #       start_new_game(socket)
  #   end
  # end
  #
  # defp report_results(payload, socket) do
  #   IO.puts "inside report results"
  #   push socket, "end_game", %{result: "You Win"}
  #   update_score(payload,socket)
  # end
  #
  # defp update_score(payload, socket) do
  #   score = payload["score"]
  #   user_id = socket.assigns.current_user.id
  #   user =  Quizzbuzz.Repo.get!(Quizzbuzz.User, user_id)
  #   cond do
  #     user.high_score < score ->
  #       Quizzbuzz.User.update_score(score, user_id)
  #     user.high_score == nil ->
  #       Quizzbuzz.User.update_score(score, user_id)
  #     true ->
  #         IO.puts "something else"
  #   end
  #
  # end
  #
  # defp get_game_id(socket) do
  #   String.to_char_list(socket.assigns.game_id)
  #   |> :erlang.list_to_atom
  # end
  #
  # defp build_game do
  #   Quizzbuzz.Question.random
  #   |> shuffle
  # end
  #
  # defp shuffle(questions) do
  #   Enum.map questions, fn(question) -> %{
  #     question: %{
  #       body: question.body,
  #       answer: question.answer,
  #       options: Enum.shuffle(question.options)
  #     }
  #   }
  #   end
  # end
  #
  # def handle_call(:pop, _from, []) do
  #   {:stop,:end_game, :end_game, []}
  # end
  # def handle_call(:pop, _from, [h | t]) do
  #   {:reply, h, t}
  # end
# end
