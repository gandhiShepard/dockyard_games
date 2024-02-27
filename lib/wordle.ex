defmodule Games.Wordle do
  @five_letter_words ~w[sassy first score trees scope shout write screw chirp steam]
  defstruct [:random_word, :users_guesses]

  @type t :: %__MODULE__{
    random_word: String.t,
    users_guesses: [String.t]
  }

  def new do
    %__MODULE__{
      random_word: Enum.random(@five_letter_words),
      users_guesses: []
    }
  end

  def play(game \\ new())

  def play(%__MODULE__{} = game) do
    users_guess =
      IO.gets("#{IO.ANSI.green()}Enter a 5 letter word: #{IO.ANSI.reset()}")
      |> String.downcase()
      |> String.trim()

    case String.length(users_guess) == 5 do
      true ->
        result = evaluate_guess(game.random_word, users_guess)
        play(
          %{game | users_guesses: [guess_to_color(result) | game.users_guesses]},
          {:ok, win?(result)}
        )
      false ->
        play(game, {:error, "input not valid"})
    end
  end

  def play(%__MODULE__{} = game, {:error, _msg}) do
    IO.puts("#{IO.ANSI.red()}That's not a 5 letter word!#{IO.ANSI.reset()}")
    play(game)
  end

  def play(%__MODULE__{users_guesses: [latest_guess | _previous_guesses]} = game, {:ok, true}) do
    IO.puts("""
    #{latest_guess}
    #{IO.ANSI.magenta_background()} You WON in #{6 - length(game.users_guesses)} guesses!#{IO.ANSI.reset()}
    """)
  end

  def play(%__MODULE__{users_guesses: users_guesses}, {:ok, false}) when length(users_guesses) == 6 do
    IO.puts("#{IO.ANSI.red()} YOU LOSE!#{IO.ANSI.reset()}")
  end

  def play(%__MODULE__{users_guesses: [latest_guess | _previous_guesses]} = game, {:ok, false}) do
    IO.puts("""
    #{latest_guess}
    Keep trying. You have #{6 - length(game.users_guesses)} guesses left.
    """)
    play(game)
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

  @spec evaluate_guess(String.t, String.t) :: [{atom, String.t}]
  defp evaluate_guess(game_word, users_guess), do: do_evaluation(game_word, game_word, users_guess, [])
  defp do_evaluation(_word_1, "", "", acc), do: acc |> Enum.reverse()
  defp do_evaluation(word_1, <<c1, rest1::binary>>, <<c2, rest2::binary>>, acc) when c1 == c2,
    do: do_evaluation(word_1, rest1, rest2, [{:green, <<c2>>} | acc])
  defp do_evaluation(word_1, <<_c1, rest1::binary>>, <<c2, rest2::binary>>, acc) do
    case String.contains?(word_1, <<c2>>) do
      true -> do_evaluation(word_1, rest1, rest2, [{:yellow, <<c2>>} | acc])
      false -> do_evaluation(word_1, rest1, rest2, [{:grey, <<c2>>} | acc])
    end
  end

  defp win?(latest_guess), do: Enum.all?(latest_guess, fn {color, _letter} -> color == :green end)

  defp guess_to_color(list) do
    Enum.map_join(list, "", fn
      {:green, letter} -> "#{IO.ANSI.green_background()} #{letter} #{IO.ANSI.reset()}"
      {:yellow, letter} -> "#{IO.ANSI.yellow_background()} #{letter} #{IO.ANSI.reset()}"
      {:grey, letter} -> "#{IO.ANSI.light_black_background()} #{letter} #{IO.ANSI.reset()}"
    end)
  end
end
