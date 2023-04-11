defmodule Settle.Parser.Helpers do
  @moduledoc """
  Parser helpers.
  """

  import NimbleParsec

  def whitespace do
    ascii_char([?\s])
    |> label("whitespace")
  end

  def uppercase_or_space do
    ascii_char([?A..?Z, ?\s])
    |> label("uppercase letter or space")
  end

  def zero_or_space do
    ascii_char([?0, ?\s])
    |> label("zero or space")
  end

  def number_or_space do
    ascii_char([?0..?9, ?\s])
    |> label("number or space")
  end

  def two_digit_year do
    integer(max: 2)
  end
end
