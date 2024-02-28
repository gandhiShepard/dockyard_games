defmodule RockPaperScissorsTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Games.RockPaperScissors

  test "new create a new RPS game" do
    assert %RockPaperScissors{ai_choice: _, users_choice: nil} = RockPaperScissors.new()
  end

  # test "user can choose R" do
  #   assert capture_io([input: "R", capture_prompt: false], fn ->
  #     IO.write RockPaperScissors.choose()
  #   end) == "ROCK"
  # end

  # test "user can choose P" do
  #   assert capture_io([input: "P", capture_prompt: false], fn ->
  #     IO.write RockPaperScissors.choose()
  #   end) == "PAPER"
  # end

  # test "user can choose S" do
  #   assert capture_io([input: "S", capture_prompt: false], fn ->
  #     IO.write RockPaperScissors.choose()
  #   end) == "SCISSORS"
  # end
end
