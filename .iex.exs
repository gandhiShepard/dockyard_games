# aliases for module usage
# import Ecto.Query

alias Games.{GuessingGame, RockPaperScissors, Wordle}

# Custom IEX
# https://github.com/blackode/elixir-tips/blob/master/part1.md
# https://www.adiiyengar.com/blog/20180709/my-iex-exs
# https://samuelmullen.com/articles/customizing_elixirs_iex/
# https://samuelmullen.com/articles/customizing_elixirs_iex
# https://alchemist.camp/episodes/iex-exs
#

# :light_black is dark grey, :white is light grey, and :light_white is actually white.

Application.put_env(:elixir, :ansi_enabled, true)

counter = IO.ANSI.green() <> "%counter" <> IO.ANSI.reset()
yay     = IO.ANSI.green() <> "(ノ＾ω＾)ノ" <> IO.ANSI.red() <> "❤ " <> IO.ANSI.reset()
emo     = IO.ANSI.green() <> "(///_^)" <> IO.ANSI.reset()
oops    = "(╯°□°）╯"
kiss    = "( ˘ ³˘)~"
cat     = "/ᐠ。ꞈ。ᐟ\~"
monster = "|°▿▿▿▿°|"
happy   = "ツ"

alive   = IO.ANSI.bright() <> IO.ANSI.yellow() <> IO.ANSI.blink_rapid() <> "⚡" <> IO.ANSI.reset()

default_prompt = yay <> counter
alive_prompt   = emo <> counter <> alive

inspect_limit = 5_000
history_size  = 100

eval_result = [:green, :bright]
eval_error  = [[:red, :bright], oops]
eval_info   = [:blue, :bright]

IEx.configure [
    inspect: [
    limit: inspect_limit,
    charlists: :as_lists,
    pretty: true,
    binaries: :as_strings,
    printable_limit: :infinity
  ],
  history_size: history_size,
  colors: [
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_black,
      boolean: :red,
      nil: [:magenta, :bright],
    ],

    eval_result: eval_result,
    eval_error: eval_error,
    eval_info: eval_info,

    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline],
  ],
  default_prompt: default_prompt,
  alive_prompt: alive_prompt,
]
