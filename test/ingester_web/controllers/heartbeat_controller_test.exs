defmodule IngesterWeb.HeartbeatControllerTest do
  use IngesterWeb.ConnCase, async: true

  @user_agent "wakatime/13.0.3 (Darwin-18.7.0-x86_64-i386-64bit) Python3.7.5.final.0 vscode/1.42.0-insider vscode-wakatime/2.2.1"
  @entity "/Users/q/Developer/wakatime/ingester/test/ingester_web/controllers/heartbeat_controller_test.exs"

  describe "POST /api/heartbeats" do
    test "with valid payload", %{conn: conn} do
      conn =
        post(conn, "/api/heartbeats", %{
          "_json" => [
            %{
              "branch" => "master",
              "category" => nil,
              "cursorpos" => nil,
              "dependencies" => [],
              "entity" => @entity,
              "is_write" => false,
              "language" => "Elixir",
              "lineno" => nil,
              "lines" => 0,
              "project" => "wako",
              "time" => 1_577_295_163.530265,
              "type" => "file",
              "user_agent" => @user_agent
            }
          ]
        })

      assert conn.status == 200

      assert [
               %Ingester.Heartbeat{
                 branch: "master",
                 category: nil,
                 cursorpos: nil,
                 dependencies: [],
                 editor: "vscode/1.42.0-insider",
                 entity: @entity,
                 is_write: false,
                 language: "Elixir",
                 lineno: nil,
                 lines: 0,
                 operating_system: "Darwin-18.7.0-x86_64-i386-64bit",
                 project: "wako",
                 time: ~U[2019-12-25 17:32:43Z],
                 type: "file"
               }
             ] = Ingester.Repo.all(Ingester.Heartbeat)
    end

    test "with invalid payload", %{conn: conn} do
      payload = %{"this" => "is", "invalid" => "payload"}

      assert_raise Phoenix.ActionClauseError, fn ->
        post(conn, "/api/heartbeats", payload)
      end

      assert_raise FunctionClauseError, fn ->
        post(conn, "/api/heartbeats", %{"_json" => payload})
      end

      assert_raise FunctionClauseError, fn ->
        post(conn, "/api/heartbeats", %{"_json" => [payload]})
      end

      assert_raise MatchError, fn ->
        post(conn, "/api/heartbeats", %{
          "_json" => [%{"time" => "not a number", "user_agent" => "not a user agent"}]
        })
      end

      assert_raise ArithmeticError, fn ->
        post(conn, "/api/heartbeats", %{
          "_json" => [%{"time" => "not a number", "user_agent" => @user_agent}]
        })
      end

      assert_raise Postgrex.Error,
                   ~r/null value in column "entity" violates not-null constraint/,
                   fn ->
                     post(conn, "/api/heartbeats", %{
                       "_json" => [%{"time" => 123, "user_agent" => @user_agent}]
                     })
                   end

      assert_raise Postgrex.Error,
                   ~r/null value in column "type" violates not-null constraint/,
                   fn ->
                     post(conn, "/api/heartbeats", %{
                       "_json" => [
                         %{"time" => 123, "user_agent" => @user_agent, "entity" => @entity}
                       ]
                     })
                   end

      assert [] = Ingester.Repo.all(Ingester.Heartbeat)
    end
  end
end
