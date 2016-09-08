defmodule Quizzbuzz.RoomChannel do
  use Phoenix.Channel

  def join("topic:"<> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("message", %{"body" => body}, socket) do
    broadcast! socket, "message", %{body: new_json}
    {:noreply, socket}
  end

  defp new_json do
    %{
      text: "Hello"
    }
  end

end
