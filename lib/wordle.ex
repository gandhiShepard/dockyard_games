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

  def play(game \\ new()) do
    users_guess =
      IO.gets("#{IO.ANSI.green()}Enter a 5 letter word: #{IO.ANSI.reset()}")
      |> String.downcase()
      |> String.trim()

    case String.length(users_guess) == 5 do
      true -> handle_guess(game, {:ok, users_guess})
      false -> handle_guess(game, {:error, "invalid input"})
    end
  end

  defp handle_guess(game, {:ok, users_guess}) when length([users_guess | game.users_guesses]) == 6 do
    IO.puts("#{IO.ANSI.red()} YOU LOSE!#{IO.ANSI.reset()}")
  end

  defp handle_guess(game, {:ok, users_guess}) when game.random_word == users_guess do
    IO.puts("""
    #{IO.ANSI.green_background()}#{users_guess}#{IO.ANSI.reset()}
    #{IO.ANSI.magenta_background()} You WON in #{length(game.users_guesses) + 1} guesses!#{IO.ANSI.reset()}
    """)
  end

  defp handle_guess(game, {:ok, users_guess}) do
    result = evaluate_guess(game.random_word, users_guess)
    game = %{game | users_guesses: [result | game.users_guesses]}

    IO.puts("""
    #{result}
    Keep trying. You have #{5 - length(game.users_guesses)} guesses left.
    """)

    play(game)
  end

  defp handle_guess(game, {:error, _msg}) do
    IO.puts("#{IO.ANSI.red()}That's not a 5 letter word!#{IO.ANSI.reset()}")
    play(game)
  end

  @spec evaluate_guess(String.t, String.t) :: [{atom, String.t}]
  defp evaluate_guess(game_word, users_guess), do: do_evaluation(game_word, game_word, users_guess, [])
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
