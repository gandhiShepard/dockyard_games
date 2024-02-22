defmodule GuessingGameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # doctest Games.GuessingGame

  alias Games.GuessingGame

  # test "Random generates a number between 1 and 10 inclusive" do
  #   random = GuessingGame.random_number()
  #   assert GuessingGame.guess() in 1..10
  # end

  test "creates new Guessing Game struct" do
    assert %GuessingGame{guesses: [], winning_number: _random_number} = GuessingGame.new()
  end

  test "User can enter a random number between 1 and 10" do
    random = Enum.random(1..10)
    assert capture_io("#{random}", fn ->
      IO.write GuessingGame.guess()
    end) == "#{IO.ANSI.blue()} Guess a number between 1 and 10: #{random}"
  end

  test "User says No to playing another winning game" do
    game = %GuessingGame{guesses: [], winning_number: 1}
    assert capture_io("2", fn ->
      IO.write GuessingGame.play(game)
    end) == """
    #{IO.ANSI.blue()} Guess a number between 1 and 10: 2
    #{IO.ANSI.magenta()} Guess is greater than winning number.
    You have 4 guess left, try again.

   #{IO.ANSI.blue()} Guess a number between 1 and 10:
    """ |> String.trim()
  end

  test "User says No to playing another winning game" do
    game = %GuessingGame{guesses: [2], winning_number: 2}
    assert capture_io("n", fn ->
      IO.write GuessingGame.play(game)
    end) == """
    #{IO.ANSI.light_green()} You won in 1 guess!

    #{IO.ANSI.blue()}Do you want to play again? Enter Y for yes or N for no. Ok, later!
    """ |> String.trim()
  end

end
