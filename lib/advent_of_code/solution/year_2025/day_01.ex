defmodule AdventOfCode.Solution.Year2025.Day01 do
  require IEx

  defp p1_lower_limit, do: 0
  defp p1_upper_limit, do: 99
  defp p1_starting_point, do: 50

  defp transition_position(:left), do: p1_upper_limit()
  defp transition_position(:right), do: p1_lower_limit()

  defp ticks_until_transition(:left, pos), do: pos + 1
  defp ticks_until_transition(:right, pos), do: p1_upper_limit() - pos + 1

  defp set_position(:left, pos, rotations), do: pos - rotations
  defp set_position(:right, pos, rotations), do: pos + rotations

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
    {password, _final_position} =
      p1_parse_input(input)
      |> Enum.reduce({0, p1_starting_point()}, &rotate_dial(&1, &2))

    password
  end

  defp rotate_dial(rotation, {password, position}) do
    new_position = apply_rotation(position, rotation)

    case new_position do
      0 -> {password + 1, new_position}
      _other -> {password, new_position}
    end
  end

  defp apply_rotation(current_position, {_dir, 0}), do: current_position

  defp apply_rotation(current_position, {dir, rotations}) do
    ticks_until_transition = ticks_until_transition(dir, current_position)

    if rotations < ticks_until_transition do
      set_position(dir, current_position, rotations)
    else
      apply_rotation(transition_position(dir), {dir, rotations - ticks_until_transition})
    end
  end

  def part2(_input) do
  end
end
