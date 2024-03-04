defmodule Games.RockPaperScissors do
  @type t :: %__MODULE__{
    ai_choice: choice,
    users_choice: choice,
    game_status: status
  }

  @type game :: t
  @type status ::  nil | :win | :lose | :draw | :invalid_choice
  @type choice :: rock | paper | scissors
  @type rock :: String.t
  @type paper :: String.t
  @type scissors :: String.t
  @type invalid :: String.t

  @enforce_keys [:ai_choice, :users_choice, :game_status]
  defstruct [:ai_choice, :users_choice, :game_status]

  @spec new :: game
  def new do
    %__MODULE__{
      ai_choice: Enum.random(["ROCK", "PAPER", "SCISSORS"]),
      users_choice: nil,
      game_status: nil
    }
  end

  def play(game \\ new())

  def play(game) when game.game_status in [nil, :invalid_choice] do
    choice_prompt()
    |> enter_users_choice(game)
    |> evaluate_choices()
    |> print_result()
    |> play()
  end

  def play(_game), do: Games.main()

  @spec choice_prompt :: String.t
  def choice_prompt do
    IO.gets("""
      Choose:
      #{IO.ANSI.cyan()}R#{IO.ANSI.reset()} for rock
      #{IO.ANSI.cyan()}P#{IO.ANSI.reset()} for paper
      or #{IO.ANSI.cyan()}S#{IO.ANSI.reset()} for scissors:
      """)
  end

  @spec enter_users_choice(choice, game) :: game
  def enter_users_choice(choice, game), do:
    %{game | users_choice: format_choice(choice)}

  @spec evaluate_choices(game) :: game
  def evaluate_choices(%__MODULE__{users_choice: "invalid"} = game), do:
    %{game | game_status: :invalid_choice}

  def evaluate_choices(%__MODULE__{ai_choice: "ROCK", users_choice: "SCISSORS"} = game), do:
    %{game | game_status: :lose}

  def evaluate_choices(%__MODULE__{ai_choice: "PAPER", users_choice: "ROCK"} = game), do:
    %{game | game_status: :lose}

  def evaluate_choices(%__module__{ai_choice: "SCISSORS", users_choice: "PAPER"} = game), do:
    %{game | game_status: :lose}

  def evaluate_choices(%__module__{ai_choice: same, users_choice: same} = game), do:
    %{game | game_status: :draw}

  def evaluate_choices(%__MODULE__{} = game), do:
    %{game | game_status: :win}

  @spec print_result(game) :: game
  def print_result(%__MODULE__{game_status: :invalid_choice} = game) do
    IO.puts("Can't do that fucker! Try again.")
    game
  end

  def print_result(%__MODULE__{game_status: :draw} = game) do
    IO.puts("""
      #{IO.ANSI.yellow()}
      DRAW! You both chose #{game.ai_choice}.
      #{IO.ANSI.reset()}
      """)
    game
  end

  def print_result(%__MODULE__{game_status: :lose} = game) do
  IO.puts("""
    #{IO.ANSI.red()}
    You LOSE!
    AI chose #{game.ai_choice}.
    You chose #{game.users_choice}.
    #{IO.ANSI.reset()}
    """)
    game
  end

  def print_result(%__MODULE__{game_status: :win} = game) do
    IO.puts("""
      #{IO.ANSI.green()}You WIN!
      AI chose #{game.ai_choice}.
      You chose #{game.users_choice}.
      #{IO.ANSI.reset()}
      """)
    game
  end

  defp format_choice(str) do
      str
      |> String.trim()
      |> String.upcase()
      |> then(fn
          "R" -> "ROCK"
          "P" -> "PAPER"
          "S" -> "SCISSORS"
          _invalid -> "invalid"
        end)
    end

end
