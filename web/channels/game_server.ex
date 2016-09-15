defmodule Quizzbuzz.Game.Server do
  use GenServer

  def start(name, questions \\ []) do
    try do
    GenServer.start_link(__MODULE__, questions, name: name)
    catch
      {:error, _} -> {:ok, "game already started"}
    end
  end

  def add_to_queue(name, payload, socket, game_size) do
    GenServer.call(name, {:wait, payload, socket, game_size})
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
