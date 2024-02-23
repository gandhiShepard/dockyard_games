defmodule Games.RockPaperScissors do
  @type t :: %__MODULE__{

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

  def play(game \\ new()) do
    game = %{game | users_choice: choose()}
    IO.puts(game.ai_choice <> " <> " <> game.users_choice)
    win_or_lose(game.ai_choice, game.users_choice)
  end

  def choose do
    users_choice =
      IO.gets("Choose R for rock, P for paper or S for scissors: ")
      |> String.upcase()
      |> String.trim()

    case users_choice in ~w[R P S] do
      true -> initial_to_choice(users_choice)
      false -> IO.puts("Cant to that fucker")
    end
  end

  defp win_or_lose("ROCK", "SCISSORS"), do:
    IO.puts("You lose. AI chose ROCK and you chose SCISSORS")

  defp win_or_lose("PAPER", "ROCK"), do:
    IO.puts("You lose. AI chose PAPER and you chose ROCK")

  defp win_or_lose("SCISSORS", "PAPER"), do:
    IO.puts("You lose. AI chose SCISSORS and you chose PAPER")

  defp win_or_lose(ai_choice, ai_choice), do:
    IO.puts("Draw. You both chose #{ai_choice}")

  defp win_or_lose(ai_choice, users_choice), do:
    IO.puts("You WIN! AI chose #{ai_choice} and you chose #{users_choice}")

  defp initial_to_choice("R"), do: "ROCK"
  defp initial_to_choice("P"), do: "PAPER"
  defp initial_to_choice("S"), do: "SCISSORS"

end
