defmodule GameReplTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  defmodule Games.Repl do

    def run(game = %{__struct__: callback_module}) do
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

    defp print(output), do: IO.puts(output)
  end

  alias Games.Repl

  defmodule TestHello do
    defstruct name: nil

    # no need to initialize anything
    def new, do: %__MODULE__{}

    def prompt(%__MODULE__{name: nil}), do: {"Enter your name:\n", :string}

    def evaluate(%__MODULE__{name: nil} = game, name), do: %{game | name: name}

    def print(%__MODULE__{name: name}), do: "Hello #{name}"

  end

  describe "run/1" do
    test "can run a simple dialog without loop" do
      assert capture_io("Ben", fn ->
        Repl.run(TestHello.new())
      end) == "Enter your name:\nHello Ben\n"
    end
  end
end
