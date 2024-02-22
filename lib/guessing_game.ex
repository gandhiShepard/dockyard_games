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

  @spec play(GuessingGame.t) :: GuessingGame.t
  def play(game \\ new())
  def play(%__MODULE__{guesses: []} = game) do
    game = %{game | guesses: [guess() | game.guesses]}
    play(game)
  end

  def play(%__MODULE__{winning_number: n, guesses: [n | _t] = gs}) do
    IO.puts("""
    #{IO.ANSI.light_green()} You won in #{length(gs)} #{if length(gs) == 1, do: "guess!", else: "guesses!"}
    """)

    play_again()
  end


  def play(%__MODULE__{guesses: guesses}) when length(guesses) == 5 do
   IO.puts("#{IO.ANSI.red()} Sorry, you lost! You ran out of guesses!")

   play_again()
  end

  def play(%__MODULE__{winning_number: n, guesses: [g | _t] = gs} = game) when g > n do
    IO.puts("""
    #{IO.ANSI.magenta()} Guess is greater than winning number.
    #{guesses_left(gs)}
    """)

    game = %{game | guesses: [guess() | game.guesses]}
    play(game)
  end

  def play(%__MODULE__{winning_number: n, guesses: [g | _t] = gs} = game) when g < n do

    IO.puts("""
    #{IO.ANSI.magenta()} Guess is less than winning number.
    #{guesses_left(gs)}
    """)

    game = %{game | guesses: [guess() | game.guesses]}
    play(game)
  end

  def play_again do
    play_again = IO.gets("#{IO.ANSI.blue()}Do you want to play again? Enter Y for yes or N for no. ")
    case String.trim(String.upcase(play_again)) do
      "Y" -> play()
      "N" -> "Ok, later!"
      _ -> "Input not accepted"
    end
  end


  # @spec guess :: 1..10
  # def guess do
  #   IO.gets("#{IO.ANSI.blue()} Guess a number between 1 and 10: ")
  #   |> String.trim()
  #   |> String.to_integer()
  # end

  def guess do
    guess(IO.gets("#{IO.ANSI.blue()} Guess a number between 1 and 10: "), ~r/([0-9]{1,2})/, "Guess must be a number between 1 and 10: ")
  end

  def guess(name_input, accepted_name, failure) do
    if String.match?(name_input, accepted_name) do
      name_input
      |> String.trim()
      |> String.to_integer()
    else
      guess(IO.gets(failure), accepted_name, failure)
    end
  end


  defp guesses_left(list) do
    guesses_left = length(list)
    "You have #{5 - guesses_left} #{if guesses_left == 1, do: "guess", else: "guesses"} left, try again."
  end

  @spec random_number :: 1..10
  defp random_number do
    Enum.random(1..10)
  end
end
