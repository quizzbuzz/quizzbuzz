defmodule LobbyQueue do
  use GenServer

  def start do
    try do
      GenServer.start(__MODULE__, [], name: :two_player_queue)
      GenServer.start(__MODULE__, [], name: :twenty_player_queue)
    catch
      {:error, _} -> IO.puts "Server already started, error handled"
    end
  end

  def join(:two_player, socket) do
    GenServer.call(:two_player_queue, {:push_two, socket})
  end
  def join(:twenty_player, socket) do
    GenServer.call(:twenty_player_queue, {:push_twenty, socket})
  end

  def handle_call({:push_two, socket}, _from, []) do
    {:reply, :wait, [socket]}
  end

  def handle_call({:push_two, socket}, _from, list) do
    players = [socket | list]
    IO.puts "in the two player server"

    if length(players) == 2 do
      IO.puts "two players join"
      {:reply, players, []}
    else
      IO.puts "A player joins the queue"
      {:reply, :wait, players}
    end
  end
  def handle_call({:push_twenty, socket}, _from, list) do
    players = [socket | list]
    if length(players) == 4 do
      {:reply, players, []}
    else
      {:reply, :wait, players}
    end
end



end
