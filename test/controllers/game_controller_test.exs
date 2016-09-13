defmodule Quizzbuzz.GameControllerTest do
  use Quizzbuzz.ConnCase

  test "GET /game", %{conn: conn} do
    conn = get conn, "/game"
    assert html_response(conn, 200) =~ ""
  end
end
