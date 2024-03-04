defmodule WordleTest do
  use ExUnit.Case
  # import ExUnit.CaptureIO

  alias Games.Wordle

  describe "feedback/2" do
    test "All green" do
      assert Wordle.feedback("aaaaa", "aaaaa") |> Enum.all?(&(&1 == :green))
    end

    test "All yellow" do
      assert Wordle.feedback("abdce", "edcba") |> Enum.all?(&(&1 == :yellow))
    end


    test "All grey" do
      assert Wordle.feedback("aaaaa", "bbbbb") |> Enum.all?(&(&1 == :grey))
    end

    test "some green, yellow, and grey" do
      assert Wordle.feedback("abcde", "abdcf") == [:green, :green, :yellow, :yellow, :grey]
    end

    test "sassy" do
      assert Wordle.feedback("sassy", "ssyas") == [:green, :yellow, :yellow, :yellow, :yellow]
    end
  end

  describe "play" do
    test "new" do
      assert %Wordle{random_word: _, users_guesses: []} = Wordle.new()
    end

    # I'm certainly confused about how to test with this IO stuff.

    # test "play" do
    #   game = %Wordle{random_word: "trees", users_guesses: []}
    #   assert capture_io(fn ->
    #     IO.write Wordle.play(game, {:error, "input not valid"})
    #   end) =~ "That's not a 5 letter word!"
    # end
  end
end
