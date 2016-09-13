defmodule Quizzbuzz.GameChannelTest do
  use ExUnit.Case, async: false
  use Quizzbuzz.ChannelCase

  import Quizzbuzz.Factory

  alias Quizzbuzz.GameChannel



  setup do

    insert(:question)
    insert(:question)
    {:ok, game, socket} =
      socket("game", %{some: :assign})
      |> subscribe_and_join(GameChannel, "game:lobby")

    {:ok, game_info: game, socket: socket}

  end


  test "new question is returned when player is ready", %{socket: socket} do
    push socket, "ready", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
  end

  test "new question is returned when an answer is received", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "new_question", %{question:
                                  %{answer: _,
                                  body: _,
                                  options: [_, _, _, _]}}
  end

  test "game is ended after questions are all answered", %{socket: socket} do
    push socket, "answer", %{"user_id" => "888"}
    assert_push "end_game", %{:result => "You Win"}

  end

end
