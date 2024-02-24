defmodule Games do
  alias Games.{GuessingGame, RockPaperScissors}


  defdelegate play_guessing_game(), to: GuessingGame, as: :play

  defdelegate play_rock_paper_scissors(), to: RockPaperScissors, as: :play
end
