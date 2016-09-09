defmodule Quizzbuzz.RoomChannel do
  use Phoenix.Channel

  def join("room:"<> _topic_name, _auth_msg, socket) do
    send self, :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
   push socket, "new_question", %{question: "The answer is A", options: ["A", "B", "C", "D"]}
   {:noreply, socket}
 end

  def handle_in("answer", %{"body" => body}, socket) do
    push socket, "new_question", %{question: "the answer is ewfdvcxbdv",
    options: ["these", "are", "my", "options"]}
    IO.puts body
    {:noreply, socket}
  end
  
end
