defmodule RockPaperScissorsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Games.RockPaperScissors

  describe "new/0" do
    test "creates a game struct" do
      assert %RockPaperScissors{} = RockPaperScissors.new()
    end

    test "initiates the ai_choice with a random choice" do
      assert %RockPaperScissors{ai_choice: choice} = RockPaperScissors.new()
      assert choice in ~w[ROCK PAPER SCISSORS]
    end
  end

  describe "choice_prompt/0" do
    test "should prompt a message" do
      assert capture_io(fn ->
        RockPaperScissors.choice_prompt()
      end) =~ "Choose"
    end

    test "should return any string input" do
      assert capture_io([input: "r", capture_prompt: false], fn ->
        IO.write RockPaperScissors.choice_prompt()
      end) == "r"

      assert capture_io([input: "boo", capture_prompt: false], fn ->
        IO.write RockPaperScissors.choice_prompt()
      end) == "boo"

    end
  end

  describe "evaluate_choices/1 where AI wins and User loses" do
    test "if :ai_choice ROCK and :users_choice SCISSORS, then :game_status is set to :lose" do
      game =  %RockPaperScissors{
        ai_choice: "ROCK",
        users_choice: "SCISSORS",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :lose} = RockPaperScissors.evaluate_choices(game)
    end

    test "if :ai_choice PAPER and :users_choice ROCK, then :game_status is set to :lose" do
      game =  %RockPaperScissors{
        ai_choice: "PAPER",
        users_choice: "ROCK",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :lose} = RockPaperScissors.evaluate_choices(game)
    end

    test "if :ai_choice SCISSORS and :users_choice PAPER, then :game_status is set to :lose" do
      game =  %RockPaperScissors{
        ai_choice: "SCISSORS",
        users_choice: "PAPER",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :lose} = RockPaperScissors.evaluate_choices(game)
    end
  end

  describe "evaluate_choices/1 where AI loses and User wins" do
    test "if :ai_choice SCISSORS and :users_choice ROCK, then :game_status is set to :win" do
      game =  %RockPaperScissors{
        ai_choice: "SCISSORS",
        users_choice: "ROCK",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :win} = RockPaperScissors.evaluate_choices(game)
    end

    test "if :ai_choice ROCK and :users_choice PAPER, then :game_status is set to :win" do
      game =  %RockPaperScissors{
        ai_choice: "ROCK",
        users_choice: "PAPER",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :win} = RockPaperScissors.evaluate_choices(game)
    end

    test "if :ai_choice PAPER and :users_choice SCISSORS, then :game_status is set to :win" do
      game =  %RockPaperScissors{
        ai_choice: "PAPER",
        users_choice: "SCISSORS",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :win} = RockPaperScissors.evaluate_choices(game)
    end
  end

  describe "evaluate_choices/1 when there is a draw or invalid choice" do
    test "if :ai_choice and :users_choice are the same, then :game_status is set to :draw" do
      game =  %RockPaperScissors{
        ai_choice: "PAPER",
        users_choice: "PAPER",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :draw} = RockPaperScissors.evaluate_choices(game)
    end

    test "if :users_choice is 'invalid', then :game_status is set to :invalid_choice" do
      game =  %RockPaperScissors{
        ai_choice: "PAPER",
        users_choice: "invalid",
        game_status: nil
      }
      assert %RockPaperScissors{game_status: :invalid_choice} = RockPaperScissors.evaluate_choices(game)
    end

  end

  describe "print_result/1" do
    test "when :game_status is :win" do
      game =  %RockPaperScissors{
             ai_choice: "PAPER",
             users_choice: "SCISSORS",
             game_status: :win
           }
      assert capture_io(fn ->
          RockPaperScissors.print_result(game)
        end) =~ "You WIN!"
    end

    test "when :game_status is :invalid_choice" do
      game =  %RockPaperScissors{
             ai_choice: "PAPER",
             users_choice: "invalid",
             game_status: :invalid_choice
           }
      assert capture_io(fn ->
          RockPaperScissors.print_result(game)
        end) =~ "Can't do that fucker"
    end

    test "when :game_status is :lose" do
      game =  %RockPaperScissors{
             ai_choice: "PAPER",
             users_choice: "ROCK",
             game_status: :lose
           }
      assert capture_io(fn ->
          RockPaperScissors.print_result(game)
        end) =~ "You LOSE!"
    end

    test "when :game_status is :draw" do
      game =  %RockPaperScissors{
             ai_choice: "PAPER",
             users_choice: "PAPER",
             game_status: :draw
           }
      assert capture_io(fn ->
          RockPaperScissors.print_result(game)
        end) =~ "DRAW!"
    end

  end
end
