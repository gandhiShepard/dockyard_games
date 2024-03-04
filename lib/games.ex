defmodule Games do
  alias Games.{GuessingGame, RockPaperScissors, Wordle}

  def main() do
    choice = IO.gets("""
      What game would you like to play?
      1. Guessing Game
      2. Rock Paper Scissors
      3. Wordle

      enter "stop" to exit
      """)

    case String.trim(choice) do
      "1" -> GuessingGame.play()
      "2" -> RockPaperScissors.play()
      "3" -> Wordle.play()
      # "stop" -> main("--stop=true")
      :else -> IO.puts("Ok")
    end
  end


  # defdelegate play_guessing_game(), to: GuessingGame, as: :play

  # defdelegate play_rock_paper_scissors(), to: RockPaperScissors, as: :play
end
