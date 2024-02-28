defmodule Games.GuessingGame do

  @typedoc """
    Type represents a GuessingGame struct. This data structure contains the state of the guessing game.
  """
  @type t :: %__MODULE__{
    winning_number: 1..10,
    guesses: [non_neg_integer]
  }

  @enforce_keys [:winning_number, :guesses]
  defstruct [:winning_number, :guesses]

  @spec new :: GuessingGame.t
  def new do
    %__MODULE__{
      winning_number: random_number(),
      guesses: []
    }
  end

  # PUL: This is better, but still the main game loop (which is kind like a REPL, is unclear.
  # It would be better to have here the overview: make_a_guess, evaluate the guess, print the overview, loop to next guess or play_again
  @spec play(GuessingGame.t) :: {GuessingGame.t, {:ok, integer} | {:error, String.t}}
  def play(game \\ new()) do
    guess =
      IO.gets("#{IO.ANSI.magenta_background()} Guess a number between 1 and 10:#{IO.ANSI.reset()} ")
      |> String.trim()

    case valid_guess?(guess) do
      true ->
        handle_guess(game, {:ok, String.to_integer(guess)})
      false ->
        handle_guess(game, {:error, "invalid input"})
    end
  end

  # PUL: Is this correct here? What if the last guess would we the winning one? But surely you have a test for that case ;-)
  # Also: You mixing several concerns (evaluating the guess, adding it to the game, detecting the end of game) in one function
  def handle_guess(%__MODULE__{guesses: guesses}, {:ok, guess}) when length([guess | guesses]) == 5 do
    IO.puts("#{IO.ANSI.red()} Sorry, you lost! You ran out of guesses!")

    play_again()
  end

  def handle_guess(%__MODULE__{winning_number: winning_number, guesses: guesses}, {:ok, winning_number}) do
    IO.puts("""
    #{IO.ANSI.light_green()} You won in #{length(guesses)} #{if length(guesses) == 1, do: "guess!", else: "guesses!"}
    """)

    play_again()
  end

  # The number of left guesses shown is off by one
  def handle_guess(%__MODULE__{winning_number: winning_number, guesses: guesses} = game, {:ok, guess}) do
    position = if guess > winning_number, do: "greater", else: "less"

    IO.puts("""
    #{IO.ANSI.magenta()} Guess is #{position} than winning number.
    Here are your previous guesses #{Enum.join([guess | guesses], ", ")}.
    #{guesses_left(guesses)}
    """)

    game = %{game | guesses: [guess | game.guesses]}
    play(game)
  end

  def handle_guess(%__MODULE__{} = game, {:error, _msg}) do
    IO.puts("That's not a number fool!\n")
    play(game)
  end

  defp valid_guess?(guess), do: String.match?(guess, ~r/([0-9]{1,2})/)

  defp guesses_left(list) do
    guesses_left = length(list)
    "You have #{5 - guesses_left} #{if guesses_left == 1, do: "guess", else: "guesses"} left, try again."
  end

  # Pul: It would be better, if this would just ask the question and return the result.
  # What happens in the third case? Shouldn't it loop?
  # What happens with the user feedback anyway? It looks as if it should be output, but that happens nowhere.
  defp play_again do
    play_again = IO.gets("#{IO.ANSI.blue()}Do you want to play again? Enter Y for yes or N for no. ")
    case String.trim(String.upcase(play_again)) do
      "Y" -> play()
      "N" -> "Ok, later!"
       _ -> "Input not accepted"
    end
  end

  defp random_number do
    Enum.random(1..10)
  end
end
