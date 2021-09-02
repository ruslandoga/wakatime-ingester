defmodule IngesterWeb.HeartbeatControllerTest do
  use IngesterWeb.ConnCase, async: true

  @user_agent "wakatime/13.0.3 (Darwin-18.7.0-x86_64-i386-64bit) Python3.7.5.final.0 vscode/1.42.0-insider vscode-wakatime/2.2.1"
  @entity "/Users/q/Developer/wakatime/ingester/test/ingester_web/controllers/heartbeat_controller_test.exs"

  describe "POST /heartbeats" do
    test "with old valid payload", %{conn: conn} do
      conn =
        post(conn, "/heartbeats", %{
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

    test "with new valid payload", %{conn: conn} do
      conn =
        post(conn, "/heartbeats", %{
          "_json" => [
            %{
              "branch" => "fix-events-tz",
              "category" => "coding",
              "cursorpos" => nil,
              "dependencies" => nil,
              "entity" =>
                "/Users/q/Developer/wakatime/ingester/test/ingester_web/controllers/heartbeat_controller_test.exs",
              "is_write" => true,
              "language" => "Elixir",
              "lineno" => nil,
              "lines" => 222,
              "project" => "wako",
              "time" => 1_621_430_715.381191,
              "type" => "file",
              "user_agent" =>
                "wakatime/v1.6.0 (darwin-20.3.0-arm64) go1.16.4 \"vscode/1.57.0-insider vscode-wakatime/9.0.3\""
            },
            %{
              "branch" => "dev",
              "category" => "coding",
              "cursorpos" => nil,
              "dependencies" => nil,
              "entity" => "/Users/q/Developer/wakatime/ingester/mix.exs",
              "is_write" => nil,
              "language" => "Elixir",
              "lineno" => nil,
              "lines" => 87,
              "project" => "wako",
              "time" => 1_621_347_601.841378,
              "type" => "file",
              "user_agent" =>
                "wakatime/v1.6.0 (darwin-20.3.0-arm64) go1.16.4 \"vscode/1.57.0-insider vscode-wakatime/9.0.0\""
            },
            %{
              "branch" => "dev",
              "category" => "coding",
              "cursorpos" => nil,
              "dependencies" => nil,
              "entity" => "/Users/q/Developer/wakatime/ingester/lib/ingester/application.ex",
              "is_write" => nil,
              "language" => "Elixir",
              "lineno" => nil,
              "lines" => 153,
              "project" => "wako",
              "time" => 1_621_347_951.1444328,
              "type" => "file",
              "user_agent" =>
                "wakatime/v1.6.0 (darwin-20.3.0-arm64) go1.16.4 \"vscode/1.57.0-insider vscode-wakatime/9.0.0\""
            }
          ]
        })

      assert conn.status == 200

      assert [
               %Ingester.Heartbeat{
                 branch: "fix-events-tz",
                 category: "coding",
                 cursorpos: nil,
                 dependencies: nil,
                 editor: "\"vscode/1.57.0-insider",
                 entity:
                   "/Users/q/Developer/wakatime/ingester/test/ingester_web/controllers/heartbeat_controller_test.exs",
                 is_write: true,
                 language: "Elixir",
                 lineno: nil,
                 lines: 222,
                 operating_system: "darwin-20.3.0-arm64",
                 project: "wako",
                 time: ~U[2021-05-19 13:25:15Z],
                 type: "file"
               },
               %Ingester.Heartbeat{
                 branch: "dev",
                 category: "coding",
                 cursorpos: nil,
                 dependencies: nil,
                 editor: "\"vscode/1.57.0-insider",
                 entity: "/Users/q/Developer/wakatime/ingester/mix.exs",
                 is_write: false,
                 language: "Elixir",
                 lineno: nil,
                 lines: 87,
                 operating_system: "darwin-20.3.0-arm64",
                 project: "wako",
                 time: ~U[2021-05-18 14:20:01Z],
                 type: "file"
               },
               %Ingester.Heartbeat{
                 branch: "dev",
                 category: "coding",
                 cursorpos: nil,
                 dependencies: nil,
                 editor: "\"vscode/1.57.0-insider",
                 entity: "/Users/q/Developer/wakatime/ingester/lib/ingester/application.ex",
                 is_write: false,
                 language: "Elixir",
                 lineno: nil,
                 lines: 153,
                 operating_system: "darwin-20.3.0-arm64",
                 project: "wako",
                 time: ~U[2021-05-18 14:25:51Z],
                 type: "file"
               }
             ] = Ingester.Repo.all(Ingester.Heartbeat)
    end

    test "with invalid payload", %{conn: conn} do
      payload = %{"this" => "is", "invalid" => "payload"}

      assert_raise Phoenix.ActionClauseError, fn ->
        post(conn, "/heartbeats", payload)
      end

      assert_raise FunctionClauseError, fn ->
        post(conn, "/heartbeats", %{"_json" => payload})
      end

      assert_raise FunctionClauseError, fn ->
        post(conn, "/heartbeats", %{"_json" => [payload]})
      end

      assert_raise MatchError, fn ->
        post(conn, "/heartbeats", %{
          "_json" => [%{"time" => "not a number", "user_agent" => "not a user agent"}]
        })
      end

      assert_raise ArithmeticError, fn ->
        post(conn, "/heartbeats", %{
          "_json" => [%{"time" => "not a number", "user_agent" => @user_agent}]
        })
      end

      assert_raise Postgrex.Error,
                   ~r/violates not-null constraint/,
                   fn ->
                     post(conn, "/heartbeats", %{
                       "_json" => [%{"time" => 123, "user_agent" => @user_agent}]
                     })
                   end

      assert_raise Postgrex.Error,
                   ~r/violates not-null constraint/,
                   fn ->
                     post(conn, "/heartbeats", %{
                       "_json" => [
                         %{"time" => 123, "user_agent" => @user_agent, "entity" => @entity}
                       ]
                     })
                   end

      assert [] = Ingester.Repo.all(Ingester.Heartbeat)
    end
  end
end
