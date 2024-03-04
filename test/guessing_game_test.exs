defmodule GuessingGameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # doctest Games.GuessingGame

  alias Games.GuessingGame

  # Pul: Now the tests get even fewer... That is no good sign
  # Bad testability could indicate, that you haven't separated the concerns clearly enough
  # For example: Shouldn't the game itself be a functional abstraction which could be unit-tested without IO?
  # That would also help the design of your solution overall

    describe "new/0" do
      test "creates a game struct" do
        assert %GuessingGame{} = GuessingGame.new()
      end

      test "initiates the winning_number with a radnom value in the range" do
        assert %GuessingGame{winning_number: winning_number} = GuessingGame.new()
        assert winning_number in 1..10
      end
    end

    describe "guess_prompt" do
      test "creates a prompt to enter a number between 1 and 10" do
        assert capture_io([input: "4", capture_prompt: false], fn ->
          IO.write GuessingGame.guess_prompt()
          end) == "4"
      end
    end


    describe "evaluate/2" do
      test "sets :guessed to :correct, if given the winning number" do
        game = %GuessingGame{
          winning_number: 5,
          guess_status: nil,
          guesses: []
        }
        assert %GuessingGame{guess_status: :correct} = GuessingGame.evaluate_guess("5\n", game)
      end

      test "sets :guessed to :not_correct, if given a non-winning number" do
        game = %GuessingGame{
          winning_number: 5,
          guess_status: nil,
          guesses: []
        }
        assert %GuessingGame{guess_status: :not_correct} = GuessingGame.evaluate_guess("1\n", game)
      end

      test "sets :guess_status to :invalid_input, if given a letter" do
        game = %GuessingGame{
          winning_number: 5,
          guess_status: nil,
          guesses: []
        }
        assert %GuessingGame{guess_status: :invalid_input} = GuessingGame.evaluate_guess("a\n", game)
      end

    end

    # def evaluate_guess(guess, game) do
    #   case Integer.parse(guess) do
    #     {int, _} when int == game.winning_number -> %{game | guess_status: :correct}
    #     {int, _} ->  %{game | guess_status: :not_correct, guesses: [int | game.guesses]}
    #     :error ->  %{game | guess_status: :invalid_input}
    #   end
    # end


end
