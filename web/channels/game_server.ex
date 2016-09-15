defmodule Game.Server do
  use GenServer

  def start(name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def end_game(servers) do
    Enum.each servers, &(GenServer.stop(&1))
  end

  def add_to_queue(name, payload, socket, game_size) do
    GenServer.call(name, {:wait, payload, socket, game_size})
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

    def handle_call({:wait, payload, socket, game_size}, _from, queue) do
      player = %{socket: socket, payload: payload}
      players = [player | queue]
      if length(players) == game_size do
        {:reply, players, []}
      else
        {:reply, :wait, players}
      end
    end

end
