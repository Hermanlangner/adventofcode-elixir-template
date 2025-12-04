defmodule AdventOfCode.Solution.Year2025.Day02 do
  require IEx

  def part1(input) do
    require IEx

    parse_input(input)
    |> Enum.reduce([], fn range, range_acc ->
      Enum.reduce(range, range_acc, &find_invalid_code(&1, &2))
    end)
    |> Enum.sum()
  end

  defp find_invalid_code(number, acc) do
    s_number = to_string(number)
    length = String.length(s_number)
    split_index = div(length, 2)

    {first, last} = String.split_at(s_number, split_index)

    if even?(length) and first == last do
      [number | acc]
    else
      acc
    end
  end

  defp even?(num), do: rem(num, 2) == 0

  def part2(input) do
    # IO.puts(input)

    parse_input(input)
    |> Enum.reduce([], fn range, range_acc ->
      Enum.reduce(range, range_acc, &find_invalid_code_p2(&1, &2))
    end)

    # find_invalid_code_p2(6_161_616_161, [])
    |> Enum.sum()
  end

  defp find_invalid_code_p2(number, acc) do
    s_number = to_string(number)

    if valid?(s_number) do
      acc
    else
      [number | acc]
    end
  end

  defp valid?(number) do
    {valid, _char} =
      String.split(number, "", trim: true)
      |> Enum.reduce_while({true, ""}, fn
        c, {v, ""} ->
          if exact_match?(number, c) && multiple_matches(number, c) do
            IO.puts("Found: #{c} in #{number}")
            {:halt, {false, c}}
          else
            # IO.puts("Have not Found: #{c} in #{number}")
            {:cont, {v, c}}
          end

        c, {v, acc} ->
          new_acc = acc <> c

          if exact_match?(number, new_acc) && multiple_matches(number, new_acc) do
            {:halt, {false, acc}}
          else
            # IO.puts("Have not Found: #{c} in #{number}")
            {:cont, {v, new_acc}}
          end
      end)

    valid
  end

  defp exact_match?(number, pattern) do
    String.split(number, pattern, trim: true) == []
  end

  defp multiple_matches(number, pattern) do
    div(String.length(number), String.length(pattern)) >= 2
  end

  defp parse_input(input) do
    String.replace(input, "\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      [start_index, end_index] = String.split(range, "-")
      Enum.into(String.to_integer(start_index)..String.to_integer(end_index), [])
    end)
  end
end
