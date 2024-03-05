defmodule Games.Wordle do
  @five_letter_words ~w[sassy first score trees scope shout write screw chirp steam]
  defstruct [:random_word, :game_status, :users_guesses]

  @type t :: %__MODULE__{
    random_word: String.t,
    game_status: :not_solved | :win | :lose | :invalid_input,
    users_guesses: [String.t]
  }

  @maximum_guesses 6

  def new do
    %__MODULE__{
      random_word: Enum.random(@five_letter_words),
      game_status: :not_solved,
      users_guesses: []
    }
  end

  def play(game \\ new())

  def play(%__MODULE__{game_status: status} = _game) when status in [:win, :lose], do: Games.main()

  def play(game) do
    guess_prompt()
    |> enter_guess(game)
    |> evaluate_guess()
    |> print_result()
    |> play()
  end

  def guess_prompt do
    IO.gets("#{IO.ANSI.green()}Enter a 5 letter word: #{IO.ANSI.reset()}")
  end

  def enter_guess(guess, game), do:
    %{game | users_guesses: [String.downcase(String.trim(guess)) | game.users_guesses]}

  def evaluate_guess(%__MODULE__{users_guesses: [latest | _rest], random_word: winning_word} = game) when byte_size(latest) != byte_size(winning_word) , do:
    %{game | game_status: :invalid_input}

  def evaluate_guess(%__MODULE__{users_guesses: [latest | _rest], random_word: latest} = game), do:
    %{game | game_status: :win}

  def evaluate_guess(%__MODULE__{users_guesses: guesses} = game) when length(guesses) == @maximum_guesses, do:
    %{game | game_status: :lose}

  def evaluate_guess(%__MODULE__{} = game), do: %{game | game_status: :not_solved}

  def print_result(%__MODULE__{game_status: :win} = game) do
    result = compare_words(game.random_word, game.random_word)

    IO.puts("""
    #{result}
    #{IO.ANSI.green()}
    You WON in #{length(game.users_guesses) + 1} guesses!
    #{IO.ANSI.reset()}
    """)

    game
  end

  def print_result(%__MODULE__{game_status: :not_solved, users_guesses: [latest | _rest]} = game) do
    result = compare_words(game.random_word, latest)

    IO.puts("""
    #{result}

    Keep trying. You have #{@maximum_guesses - length(game.users_guesses)} guesses left.
    """)

    game
  end

  def print_result(%__MODULE__{game_status: :lose, users_guesses: [latest | _rest]} = game) do
    result = compare_words(game.random_word, latest)

    IO.puts("""
      #{result}

      #{IO.ANSI.red()}
      YOU LOSE!
      The winning word was "#{game.random_word}".
      #{IO.ANSI.reset()}\n
      """)
    game
  end

  def print_result(%__MODULE__{game_status: :invalid_input} = game) do
    IO.puts("#{IO.ANSI.red()}That's not a 5 letter word!#{IO.ANSI.reset()}")
    game
  end

  @spec compare_words(String.t, String.t) :: [{atom, String.t}]
  defp compare_words(game_word, users_guess), do: do_evaluation(game_word, game_word, users_guess, [])
  defp do_evaluation(_word_1, "", "", acc), do: acc |> Enum.reverse() |> guess_to_color()
  defp do_evaluation(word_1, <<c1, rest1::binary>>, <<c2, rest2::binary>>, acc) when c1 == c2,
    do: do_evaluation(word_1, rest1, rest2, [{:green, <<c2>>} | acc])
  defp do_evaluation(word_1, <<_c1, rest1::binary>>, <<c2, rest2::binary>>, acc) do
    case String.contains?(word_1, <<c2>>) do
      true -> do_evaluation(word_1, rest1, rest2, [{:yellow, <<c2>>} | acc])
      false -> do_evaluation(word_1, rest1, rest2, [{:grey, <<c2>>} | acc])
    end
  end

  defp guess_to_color(list) do
    Enum.map_join(list, "", fn
      {:green, letter} -> "#{IO.ANSI.green_background()} #{letter} #{IO.ANSI.reset()}"
      {:yellow, letter} -> "#{IO.ANSI.yellow_background()} #{letter} #{IO.ANSI.reset()}"
      {:grey, letter} -> "#{IO.ANSI.light_black_background()} #{letter} #{IO.ANSI.reset()}"
    end)
  end

  # just because the challenge asks for the feedback fn to return a list of atoms
  def feedback(game_word, users_guess), do: do_compare(game_word, game_word, users_guess, [])
  defp do_compare(_word_1, "", "", acc), do: acc |> Enum.reverse()
  defp do_compare(word_1, <<c1, rest1::binary>>, <<c2, rest2::binary>>, acc) when c1 == c2,
    do: do_compare(word_1, rest1, rest2, [:green | acc])
  defp do_compare(word_1, <<_c1, rest1::binary>>, <<c2, rest2::binary>>, acc) do
    case String.contains?(word_1, <<c2>>) do
      true -> do_compare(word_1, rest1, rest2, [:yellow | acc])
      false -> do_compare(word_1, rest1, rest2, [:grey | acc])
    end
  end
end
