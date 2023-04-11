defmodule Settle.Parser.TLE do
  @moduledoc """
  Parser for two-line elements and optionally three-line elements.
  """

  import NimbleParsec
  import Settle.Parser.Helpers

  # combinator parsers
  classification =
    choice([
      string("U"),
      string("C"),
      string("S")
    ])
    |> label("U, C, or S")
    |> unwrap_and_tag(:classification)

  defparsec(:classification, classification)

  # catalog numbers with less than 5 digits must be aligned to the right and
  # padded with either spaces or zeros
  # catalog number must be five characters in length

  # if a character is a space, all preceding characters must also have been a space,
  # and the next character must be another space or number

  # if a character is a 0 and all preceding characters are a 0, the next
  # character must be a 0 or number
  catalog_number =
    ignore(times(zero_or_space(), max: 4))
    |> ascii_string([?0..?9], min: 1, max: 5)
    |> label("catalog number")
    |> tag(:catalog_number)

  defparsec(:catalog_number, catalog_number)

  intl_designator =
    times(number_or_space(), 2)
    |> times(number_or_space(), 3)
    |> times(uppercase_or_space(), 3)
    |> label("international designator")
    |> tag(:intl_designator)

  defparsec(:intl_designator, intl_designator)

  defparsec(
    :line_zero,
    ignore(ascii_char([?0]))
    |> ignore(ascii_char([?\s]))
    |> times(uppercase_or_space(), max: 24)
    |> label("line zero")
    |> tag(:line_zero)
  )

  defparsec(
    :line_one,
    ignore(ascii_char([?1]))
    |> ignore(ascii_char([?\s]))
    |> concat(catalog_number)
    |> concat(classification)
    |> ignore(ascii_char([?\s]))
    |> concat(intl_designator)
    |> tag(:line_one)
  )

  # validators
end
