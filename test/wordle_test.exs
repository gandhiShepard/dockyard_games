defmodule WordleTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias Games.Wordle

  describe "new/0" do
    test "creates a new wordle struct" do
      assert %Wordle{} = Wordle.new()
    end

    test "initiates :random_word with a random word" do
      assert %Wordle{random_word: _random_word} = Wordle.new()
    end
  end

  describe "guess_prompt/0" do
    test "prompts user with a message to make a guess" do
      assert capture_io(fn ->
        Wordle.guess_prompt()
        end) =~ "Enter a 5 letter word:"
    end

    test "propmt returns any input" do
      assert capture_io([input: "hello", capture_prompt: false], fn ->
        IO.write Wordle.guess_prompt()
        end) == "hello"
    end
  end

  describe "enter_guess/2" do
    setup do
      game = %Wordle{
        random_word: "rando",
        game_status: :not_solved,
        users_guesses: []
      }

      [game: game]
    end

    test "enters a guess into :users_guesses", %{game: game} do
      assert %Wordle{users_guesses: ["hello"]} = Wordle.enter_guess("hello", game)
    end
  end

  describe "evaluate_guess/1" do
    test "if latest guess matches :random_word, then :game_status is :win" do
      game = %Wordle{
        random_word: "rando",
        game_status: :not_solved,
        users_guesses: ["rando"]
      }

      assert %Wordle{game_status: :win} = Wordle.evaluate_guess(game)
    end

    test "if guess does not matche :random_word, then :game_status is :not_solved" do
      game = %Wordle{
        random_word: "rando",
        game_status: :not_solved,
        users_guesses: ["blame"]
      }

      assert %Wordle{game_status: :not_solved} = Wordle.evaluate_guess(game)
    end


    test "if user can't guess the correct word in 6 guesses, then :game_status is :lose" do
      game = %Wordle{
        random_word: "rando",
        game_status: :not_solved,
        users_guesses: ["blame", "score", "trees", "rambo", "sheet", "wrong"]
      }

      assert %Wordle{game_status: :lose} = Wordle.evaluate_guess(game)
    end


    test "if guess is invalid, then :game_status is :invalid_input" do
      game = %Wordle{
        random_word: "rando",
        game_status: :not_solved,
        users_guesses: ["metaprogramming"]
      }

      assert %Wordle{game_status: :invalid_input} = Wordle.evaluate_guess(game)
    end




  end

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
end
