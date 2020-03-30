defmodule CnpjGenerator do
  def main do
    (0..7)
    |> Enum.map(fn i -> Enum.random(0..9) end)
    |> Enum.join("")
    |> calculate_next_digit("0001")
  end
  def calculate_next_digit(base, previous_digit) when byte_size(base) == 13, do: base <> previous_digit
  def calculate_next_digit(base, previous_digit) do
    new_base = base |> (fn x -> x <> previous_digit end).()
    calculated_digit = new_base
    |> String.graphemes()
    |> cnpj_algorithm()
    |> Enum.sum()
    |> rem(11)
    |> subtract_eleven()
    |> Integer.to_string()
    calculate_next_digit(new_base, calculated_digit)
  end
  def subtract_eleven(n) when n in (0..2), do: n
  def subtract_eleven(n) when n > 2, do: 11 - n
  def factor_c(base) when length(base) == 12, do: [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  def factor_c(base) when length(base) == 13, do: [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]
  def cnpj_algorithm(b) do
    (0..length(b)-1)
    |> Enum.map(fn i -> String.to_integer(Enum.at(b, i)) * Enum.at(factor_c(b), i) end)
  end
end
