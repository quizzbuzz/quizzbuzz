defmodule TwentyPlayerServer do
  use GenServer

  def start(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def add_to_queue(name, payload, socket) do
    GenServer.call(name, {:wait, payload, socket})
  end

  def start_new_game(game_id, questions) do
    GenServer.start(__MODULE__, questions, name: game_id)
  end

  def pop(name) do
    GenServer.call(name, :pop)
  end

    def handle_call(:pop, _from, [h | t]) do
      {:reply, h, t}
    end

    def handle_call(:pop, _from, []) do
      {:reply,:end_game, []}
    end

    def handle_call({:wait, payload, socket}, _from, queue) do
      player = %{socket: socket, payload: payload}
      players = [player | queue]
      if length(players) == 3 do
        {:reply, players, []}
      else
        {:reply, :wait, players}
      end
    end

    def handle_call({:push, payload, socket}, _from, []) do
      outcome = %{score: payload["score"], socket: socket}
      {:reply, :wait, [outcome]}
    end
    def handle_call({:push, payload, socket}, _from, list) do
      outcome = %{score: payload["final_score"], socket: socket}
      results = [outcome | list]
      if length(results) == 3 do
        results = Enum.sort_by([outcome|list], &(&1.score), &>=/2)
        {:reply, results, []}
      else
        {:reply, :wait, results}
      end
    end
end
