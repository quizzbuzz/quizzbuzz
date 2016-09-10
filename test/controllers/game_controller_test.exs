defmodule Quizzbuzz.GameControllerTest do
  use Quizzbuzz.ConnCase

  alias Quizzbuzz.Game
  alias Quizzbuzz.Question

  test "GET /game", %{conn: conn} do
    conn = get conn, "/game"
    assert html_response(conn, 200) =~ ""
  end


  #
  # test "#index renders a single question" do
  #   conn = build_conn()
  #   game = insert(:game)
  #
  #   conn = get conn, game_path(conn, :index)
  #
  #   assert json_response(conn, 200) == %{
  #     "round" => %{
  #       "question" => %{
  #         "id" => last_id,
  #         "body" => "How many roads must a man walk down, before you can call him a man?",
  #         "options" => ["1", "3", "5", "42"],
  #         "answer" => "42"
  #       }
  #     }
  #   }
  # end
  #
  # defp last_id do
  #   Repo.one(from questions in Quizzbuzz.Question,
  #                   order_by: [desc: questions.id],
  #                   limit: 1).id
  # end
end
