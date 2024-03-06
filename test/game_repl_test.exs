defmodule GameReplTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  defmodule Games.Repl do

    # def run(%{__struct__: callback_module} game)
    # Interesting!! I found this to work as well
    def run(%callback_module{} = game) do
      with(
        prompt <- callback_module.prompt(game),
        input <- read(prompt),
        game <- callback_module.evaluate(game, input),
        output <- callback_module.print(game),
        # loop
        do: print(output)
      )
    end

    defp read({prompt, :string}), do: IO.gets(prompt)
    defp read({prompt, 1..10}), do: IO.gets(prompt)

    defp print(output), do: IO.puts(output)
  end

  alias Games.Repl

  defmodule TestHello do
    defstruct name: nil

    # no need to initialize anything
    def new, do: %__MODULE__{}

    # ok, so this is a tagged tuple right?
    # And we are doing this as we will be handling diffenert data from different games right?
    def prompt(%__MODULE__{name: nil}), do: {"Enter your name:\n", :string}

    def evaluate(%__MODULE__{name: nil} = game, name), do: %{game | name: name}

    def print(%__MODULE__{name: name}), do: "Hello #{name}"
  end

  defmodule GuessingGame do
    defstruct random_number: nil, guess: nil

    def new, do: %__MODULE__{}

    # prompt
    def prompt(%__MODULE__{random_number: _, guess: _}), do: {">> Guess a number from 1 to 10", 1..10}

    # evaluate
    def evaluate(%__MODULE__{random_number: nil, guess: nil} = game, guess), 
      do: %{game | random_number: Enum.random(1..10), guess: guess}

    def evaluate(%__MODULE__{random_number: _, guess: _} = game, guess), 
      do: %{game | guess: String.to_integer(String.trim(guess))}

    # print
    def print(%__MODULE__{random_number: random_number, guess: random_number}),
      do: "You WIN!"
      
    def print(%__MODULE__{random_number: random_number, guess: guess}), 
      do: "Your guess is too #{if guess > random_number, do: "high", else: "low"}."
  end


  describe "run/1" do
    test "can run a simple dialog without loop" do
      assert capture_io("Ben", fn -> Repl.run(TestHello.new()) end) == "Enter your name:\nHello Ben\n"
    end

    test "can run a GuessingGame without a loop" do
      assert capture_io("5", fn -> Repl.run(GuessingGame.new()) end) =~ ">> Guess a number from 1 to 10"
    end
  end
end
