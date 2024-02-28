defmodule GuessingGameTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  # doctest Games.GuessingGame

  alias Games.GuessingGame

  test "creates new Guessing Game struct" do
    assert %GuessingGame{guesses: [], winning_number: _random_number} = GuessingGame.new()
  end

  # test "User can enter a random number between 1 and 10" do
  #   assert capture_io("1", fn ->
  #     IO.write GuessingGame.play()
  #   end) =~ "Guess a number between 1 and 10: "
  # end

  # test "User says No to playing another winning game" do
  #   game = %GuessingGame{guesses: [1], winning_number: 1}
  #   assert capture_io("n", fn ->
  #     IO.write GuessingGame.play(game)
  #   end) =~ "Ok, later!"
  # end

  # test "User loses a game" do
  #   game = %GuessingGame{guesses: [2,3,4,5,6], winning_number: 1}
  #   assert capture_io("n", fn ->
  #     IO.write GuessingGame.play(game)
  #   end) =~ "Sorry, you lost!"
  # end

end
