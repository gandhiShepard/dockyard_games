defmodule Games.GuessingGame do
  alias Games

  @typedoc """
    Type represents a GuessingGame struct. This data structure contains the state of the guessing game.
  """
  @type t :: %__MODULE__{
    winning_number: 1..10,
    guess_status: nil | :win | :not_correct | :invalid_input | :lose,
    guesses: [non_neg_integer]
  }

  @enforce_keys [:winning_number, :guess_status, :guesses]
  defstruct [:winning_number, :guess_status, :guesses]

  @spec new :: GuessingGame.t
  def new do
    %__MODULE__{
      winning_number: random_number(),
      guess_status: nil,
      guesses: []
    }
  end

  def play(game \\ new())

  def play(%__MODULE__{guess_status: status} = _game) when status in [:win, :lose], do: Games.main()

  def play(game) do
    guess_prompt()
    |> evaluate_guess(game)
    |> print_result()
    |> play()
  end

  def guess_prompt, do: IO.gets(">> Guess a number from 1 to 10: ")

  def evaluate_guess(guess, game) do
    case Integer.parse(guess) do
      {int, _} when int == game.winning_number -> %{game | guess_status: :win}
      {_int, _} when length(game.guesses) == 4 ->  %{game | guess_status: :lose}
      {int, _} ->  %{game | guess_status: :not_correct, guesses: [int | game.guesses]}
      :error ->  %{game | guess_status: :invalid_input}
    end
  end

  def print_result(%__MODULE__{guess_status: :win} = game) do
    IO.puts("#{IO.ANSI.green()}You WON! #{game.winning_number} is the winning number.#{IO.ANSI.reset()}")
    game
  end

  def print_result(%__MODULE__{guess_status: :lose} = game) do
    IO.puts("#{IO.ANSI.red}You LOSE! The winning number is #{game.winning_number}#{IO.ANSI.reset()}")
    game
  end

  def print_result(%__MODULE__{guess_status: :not_correct, guesses: [latest_guess | _]} = game) do
    IO.puts("#{IO.ANSI.yellow}Nope! Your guess is too #{if latest_guess > game.winning_number, do: "high", else: "low"}.#{IO.ANSI.reset()}")
    game
  end

  def print_result(%__MODULE__{guess_status: :invalid_input} = game) do
    IO.puts("Invalid input buddy!")
    game
  end

  defp random_number do
    Enum.random(1..10)
  end
end
