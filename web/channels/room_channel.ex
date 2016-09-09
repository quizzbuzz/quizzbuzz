defmodule Quizzbuzz.RoomChannel do
  use Phoenix.Channel

  def join("topic:"<> _topic_name, _auth_msg, socket) do
    {:ok, socket}
  end

  def handle_in("answer", %{"body" => body}, socket) do
    broadcast! socket, "answer", %{body: body}
    {:noreply, socket}
  end

  defp new_json do
    %{
      question: "the answer is 2",
      answers: ["1", "2", "3", "4"]
    }
  end

end