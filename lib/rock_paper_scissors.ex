defmodule Games.RockPaperScissors do
  @type t :: %__MODULE__{
    ai_choice: String.t,
    users_choice: String.t
  }

  @enforce_keys [:ai_choice, :users_choice]
  defstruct [:ai_choice, :users_choice]

  @spec new :: RockPaperScissors.t
  def new do
    %__MODULE__{
      ai_choice: Enum.random(["ROCK", "PAPER", "SCISSORS"]),
      users_choice: nil
    }
  end

  # Not sure what to put as the typespec
  # because the return value is IO.
  # How do I account for this?
  def play(game \\ new()) do
    game = %{game | users_choice: choose()}
    IO.puts(game.ai_choice <> " <> " <> game.users_choice)
    win_or_lose(game.ai_choice, game.users_choice)
  end

  @spec choose :: String.t
  def choose do
    users_choice =
      IO.gets("Choose #{IO.ANSI.cyan()}R#{IO.ANSI.reset()} for rock, #{IO.ANSI.cyan()}P#{IO.ANSI.reset()} for paper or #{IO.ANSI.cyan()}S#{IO.ANSI.reset()} for scissors: ")
      |> String.upcase()
      |> String.trim()

    case users_choice in ~w[R P S] do
      true -> initial_to_choice(users_choice)
      false -> IO.puts("Can't do that fucker!")
    end
  end

  defp win_or_lose("ROCK", "SCISSORS"), do:
    IO.puts("#{IO.ANSI.red()}You lose.#{IO.ANSI.reset()} AI chose #{IO.ANSI.green_background()}ROCK#{IO.ANSI.reset()} and you chose #{IO.ANSI.red()}SCISSORS#{IO.ANSI.reset()}")

  defp win_or_lose("PAPER", "ROCK"), do:
    IO.puts("#{IO.ANSI.red()}You lose.#{IO.ANSI.reset()} AI chose #{IO.ANSI.green_background()}PAPER#{IO.ANSI.reset()} and you chose #{IO.ANSI.red()}ROCK#{IO.ANSI.reset()} ")

  defp win_or_lose("SCISSORS", "PAPER"), do:
    IO.puts("#{IO.ANSI.red()}You lose.#{IO.ANSI.reset()} AI chose #{IO.ANSI.green_background()}SCISSORS#{IO.ANSI.reset()} and you chose #{IO.ANSI.red()}PAPER#{IO.ANSI.reset()} ")

  defp win_or_lose(ai_choice, ai_choice), do:
    IO.puts("#{IO.ANSI.yellow_background()}Draw.#{IO.ANSI.reset()} You both chose #{IO.ANSI.yellow_background()}#{ai_choice}#{IO.ANSI.reset()}")

  defp win_or_lose(ai_choice, users_choice), do:
    IO.puts("#{IO.ANSI.green()}You WIN!#{IO.ANSI.reset()} AI chose #{IO.ANSI.red()}#{ai_choice}#{IO.ANSI.reset()} and you chose #{IO.ANSI.green_background()}#{users_choice}#{IO.ANSI.reset()}")

  defp initial_to_choice("R"), do: "ROCK"
  defp initial_to_choice("P"), do: "PAPER"
  defp initial_to_choice("S"), do: "SCISSORS"

end
