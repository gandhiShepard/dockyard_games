defmodule GuessingGameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # doctest Games.GuessingGame

  alias Games.GuessingGame

  describe "new/0" do
    test "creates a game struct" do
      assert %GuessingGame{} = GuessingGame.new()
    end

    test "initiates the winning_number with a radnom value in the range" do
      assert %GuessingGame{winning_number: winning_number} = GuessingGame.new()
      assert winning_number in 1..10
    end
  end

  describe "guess_prompt/0" do
    test "creates a prompt with a message" do
      assert capture_io(fn ->
        GuessingGame.guess_prompt()
        end) == ">> Guess a number from 1 to 10: "
    end

    test "prompt returns correct input" do
      assert capture_io([input: "4", capture_prompt: false], fn ->
        IO.write GuessingGame.guess_prompt()
        end) == "4"
    end

    test "promt returns invalid input" do
      assert capture_io([input: "asdf", capture_prompt: false], fn ->
        IO.write GuessingGame.guess_prompt()
        end) == "asdf"
    end
  end

  describe "evaluate/2" do
    setup do
      game = %GuessingGame{
        winning_number: 5,
        guess_status: nil,
        guesses: []
      }

      [game: game]
    end

    test "sets :guess_status to :correct, when given the winning number", %{game: game} do
      assert %GuessingGame{guess_status: :correct} = GuessingGame.evaluate_guess("5\n", game)
    end

    test "sets :guess_status to :not_correct, when given a non-winning number", %{game: game} do
      assert %GuessingGame{guess_status: :not_correct} = GuessingGame.evaluate_guess("1\n", game)
    end

    test "sets :guess_status to :invalid_input, when given a letter", %{game: game} do
      assert %GuessingGame{guess_status: :invalid_input} = GuessingGame.evaluate_guess("a\n", game)
    end
  end

  describe "print_result/1" do
    test "should print 'You WON!' when :guess_status is :correct" do
      game = %GuessingGame{
        winning_number: 5,
        guess_status: :correct,
        guesses: []
      }

      assert capture_io(fn ->
        GuessingGame.print_result(game)
      end) == "You WON! 5 is the winning number.\n"
    end


    test "should print 'Nope! Your guess is too low.' when :guess_status is :not_correct" do
      game = %GuessingGame{
        winning_number: 5,
        guess_status: :not_correct,
        guesses: [2]
      }

      assert capture_io(fn ->
        GuessingGame.print_result(game)
      end) == "Nope! Your guess is too low.\n"
    end

    test "should print 'Nope! Your guess is too high.' when :guess_status is :not_correct" do
      game = %GuessingGame{
        winning_number: 5,
        guess_status: :not_correct,
        guesses: [9]
      }

      assert capture_io(fn ->
        GuessingGame.print_result(game)
      end) == "Nope! Your guess is too high.\n"
    end

    test "should print 'Invalid input buddy!' when :guess_status is :not_correct" do
      game = %GuessingGame{
        winning_number: 5,
        guess_status: :invalid_input,
        guesses: [9]
      }

      assert capture_io(fn ->
        GuessingGame.print_result(game)
      end) == "Invalid input buddy!\n"
    end
  end
end
