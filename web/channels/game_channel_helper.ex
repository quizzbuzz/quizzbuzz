defmodule Quizzbuzz.GameHelper do
  alias Quizzbuzz.Game.Server


  def shuffle(questions) do
    Enum.map questions, fn(question) -> %{
      question: %{
        body: question.body,
        answer: question.answer,
        options: Enum.shuffle(question.options)
      }
    }
    end
  end

  def update_scores(players) do
    Enum.each(players, fn(player) -> update_score(player) end)
  end

  def update_score(player) do
    new_score = player.payload["score"]
    user =  Quizzbuzz.Repo.get!(Quizzbuzz.User, player.socket.assigns.current_user.id)
    cond do
      user.high_score < new_score ->
        Quizzbuzz.User.update_score(new_score, user.id)
      user.high_score == nil ->
        Quizzbuzz.User.update_score(new_score, user.id)
      true -> nil
    end
  end

  def sort_results(players) do
    Enum.sort_by players, fn(x) -> x.payload["score"] end, &>=/2
  end

  def to_atom(string) do
    String.to_char_list(string)
    |> :erlang.list_to_atom
  end

  def start_new_game(game_id) do
    queue_id = to_atom( "queue#{game_id}" )
    questions = build_game
    game_id = to_atom(game_id)
    Server.start(queue_id)
    Server.start(game_id, questions)
    {:ok, Server.pop(game_id)}
  end

  def build_game do
    Quizzbuzz.Question.random
    |> shuffle
  end

  def handle_answer(payload, socket, game_size) do
    game_id = to_atom(socket.assigns.game_id)
    queue_id = to_atom( "queue#{socket.assigns.game_id}" )
    case Server.add_to_queue(queue_id, payload, socket, game_size) do
      :wait -> :queue_not_full
      players = [head | tail] -> case Server.pop(game_id) do
        :end_game ->  Server.end_game([game_id, queue_id])
                      {:end_game, players}
        {:error, _} -> start_new_game(socket)
        question -> {:question, question}
        end
      end
  end

  def end_game(socket) do
    servers = server_ids(socket)
    Enum.each servers, &(GenServer.stop(&1))
  end

  def server_ids(socket) do
    game_id = socket.assigns.game_id
    game_server = to_atom(game_id)
    queue_server = to_atom("queue#{game_id}")
    [game_server, queue_server]
  end

end
