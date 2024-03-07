defmodule GameReplTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  defmodule Games.Repl do
    @callback prompt(struct) :: {String.t, atom}
    @callback evaluate(struct, input :: any) :: struct
    @callback print(struct) :: String.t 

    # def run(%{__struct__: callback_module} game)
    # Interesting!! I found this to work as well
    def run(%callback_module{} = game) do
      with(
        prompt <- callback_module.prompt(game),
        input <- read(prompt),
        game <- callback_module.evaluate(game, input),
        output <- callback_module.print(game),
        print(output),
        loop? <- callback_module.loop?(game),
        do: if(loop?, do: run(game), else: game)
      )
    end

    defp read({prompt, :string}), do: IO.gets(prompt) |> String.trim()

    defp read({prompt, :integer}) do
      case Integer.parse(IO.gets(prompt) |> String.trim()) do
        :error -> read({"Yikes! That's not an integer! Try again." , :integer})
        {int, _} -> int
      end
    end

    defp print(output), do: IO.puts(output)
  end

  alias Games.Repl

  defmodule TestHello do
    @behaviour Games.Repl

    defstruct name: nil

    # no need to initialize anything
    def new, do: %__MODULE__{}

    @impl true
    def prompt(%__MODULE__{name: nil}), do: {"Enter your name:\n", :string}

    @impl true
    def evaluate(%__MODULE__{name: nil} = game, name), do: %{game | name: name}

    @impl true
    def print(%__MODULE__{name: name}), do: "Hello #{name}"

    def loop?(_), do: false
  end

  # defmodule GuessingGame do
  #   defstruct random_number: nil, guess: nil, status: nil

  #   def new, do: %__MODULE__{random_number: Enum.random(1..10)}

  #   def prompt(%__MODULE__{random_number: _, guess: _}), do: {">> Guess a number from 1 to 10", :integer, 1..10}

  #   def evaluate(%__MODULE__{random_number: nil, guess: nil} = game, guess), 
  #     do: %{game | guess: guess}

  #   def print(%__MODULE__{random_number: random_number, guess: random_number}),
  #     do: "You WIN!"
      
  #   def print(%__MODULE__{random_number: random_number, guess: guess}), 
  #     do: "Your guess is too #{if guess > random_number, do: "high", else: "low"}."
  # end

  defmodule AskPlayerNames do
    defstruct current_player: 1, player_count: nil, names: []

    def new, do: %__MODULE__{}

    def prompt(%__MODULE__{player_count: nil}), do: {"How many players are there?", :integer}
    def prompt(%__MODULE__{current_player: current_player}), do: {"Enter name of player #{current_player}:", :string}

    def evaluate(%__MODULE__{player_count: nil} = game, player_count),
      do: %{game | player_count: player_count}

    def evaluate(%__MODULE__{current_player: current_player, names: names} = game, name),
      do: %{game | names: names ++ [name], current_player: current_player + 1}

    def print(%__MODULE__{player_count: player_count, names: names}) when length(names) == player_count, 
      do: "Hello #{Enum.join(names, " and ")}, nice to meet you!"

    def print(_), do: nil

    def loop?(%__MODULE__{player_count: player_count, names: names}), do: length(names) != player_count
  end


  describe "run/1" do
    test "can run a simple dialog without loop" do
      assert capture_io("Ben", fn -> Repl.run(TestHello.new()) end) == "Enter your name:\nHello Ben\n"
    end

    test "can run a looping dialog 2" do
      assert capture_io("2\nBen\nPul", fn -> Repl.run(AskPlayerNames.new()) end) == 
        "How many players are there?\nEnter name of player 1:\nEnter name of player 2:Hello Ben and Pul, nice to meet you!\n"
    end 
    # test "can run a GuessingGame without a loop" do
    #   assert capture_io("5", fn -> Repl.run(GuessingGame.new()) end) =~ ">> Guess a number from 1 to 10"
    # end
  end
end
