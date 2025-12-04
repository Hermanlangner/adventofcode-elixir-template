defmodule AdventOfCode.Solution.Year2025.Day01 do
  defp p1_parse_input(input) do
    input
    |> String.split("\n")
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(fn
      "L" <> rotations -> {:left, String.to_integer(rotations)}
      "R" <> rotations -> {:right, String.to_integer(rotations)}
    end)
  end

  def part1(input) do
    p1_parse_input(input)
    |> Enum.reduce({0, 50}, fn tick, {count, position} ->
      new_position = rem(tick + position, 100)

      cond do
        new_position == 0 -> {count + 1, new_position}
        new_position < 0 -> {count, new_position + 100}
        true -> {count, new_position}
      end
    end)
  end

  def part2(input) do
    p1_parse_input(input)
    |> Enum.reduce({0, 50}, fn tick, {count, position} ->
      totals = tick + position

      new_position = rem(totals, 100)
      turns = div(totals, 100) |> abs

      turns =
        if tick + position < 100 and tick + position <= 0 and position != 0 do
          turns + 1
        else
          turns
        end

      cond do
        new_position == 0 && turns > 0 -> {count + turns, new_position}
        new_position == 0 -> {count + 1, new_position}
        new_position < 0 -> {count + turns, new_position + 100}
        true -> {count + turns, new_position}
      end
    end)
    |> elem(0)
  end
end
