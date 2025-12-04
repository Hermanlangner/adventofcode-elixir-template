defmodule AdventOfCode.Solution.Year2025.Day01 do
  require IEx

  defp p1_lower_limit, do: 0
  defp p1_upper_limit, do: 99
  defp p1_starting_point, do: 50

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
    {pw, _final_pos} =
      p1_parse_input(input)
      |> Enum.reduce({0, p1_starting_point()}, fn rotation, {pw, position} ->
        new_position = rotate_dial(position, rotation)

        case new_position do
          0 -> {pw + 1, new_position}
          _other -> {pw, new_position}
        end
      end)

    pw
  end

  defp rotate_dial(0, {:right, 0}), do: 0

  defp rotate_dial(0, {:right, rotations}) do
    ticks_until_limit = p1_upper_limit() + 1

    cond do
      rotations < ticks_until_limit ->
        IO.puts(
          "Rotations from upper limit, does not exceed new cycle with #{rotations}, returning #{0 + rotations}"
        )

        0 + rotations

      true ->
        IO.puts(
          "Right Rotation: current_position: #{0}, rotations #{rotations} exceeded limit #{100} so continueing upper limit with rotations at #{rotations - 100}"
        )

        rotate_dial(p1_lower_limit(), {:right, rotations - ticks_until_limit})
    end
  end

  defp rotate_dial(current_position, {:right, rotations}) do
    ticks_until_upper_limit = p1_upper_limit() - current_position + 1
    IO.puts("Right limit #{ticks_until_upper_limit}")

    cond do
      rotations < ticks_until_upper_limit ->
        IO.puts(
          "Right Rotation: current position: #{current_position} Fewer rotations #{rotations} than limit #{ticks_until_upper_limit} so returning: #{current_position - rotations}"
        )

        current_position - rotations

      ticks_until_upper_limit == 1 ->
        IO.puts(
          "Right Rotation: Fewer rotations #{rotations} than limit #{ticks_until_upper_limit} so returning: #{current_position - rotations}"
        )

        rotate_dial(p1_lower_limit(), {:right, rotations - ticks_until_upper_limit})

      true ->
        IO.puts(
          "Right Rotation: current_position: #{current_position}, rotations #{rotations} exceeded limit #{ticks_until_upper_limit} so continueing upper limit with rotations at #{rotations - ticks_until_upper_limit}"
        )

        rotate_dial(p1_lower_limit(), {:right, rotations - ticks_until_upper_limit})
    end
  end

  defp rotate_dial(99, {:left, 0}), do: 99

  defp rotate_dial(99, {:left, rotations}) do
    ticks_until_limit = p1_upper_limit() + 1

    cond do
      rotations < ticks_until_limit ->
        IO.puts(
          "Rotations from upper limit, does not exceed new cycle with #{rotations}, returning #{99 - rotations}"
        )

        99 - rotations

      true ->
        IO.puts(
          "Left Rotation: current_position: #{99}, rotations #{rotations} exceeded limit #{100} so continueing upper limit with rotations at #{rotations - 100}"
        )

        rotate_dial(p1_upper_limit(), {:left, rotations - ticks_until_limit})
    end
  end

  defp rotate_dial(current_position, {:left, rotations} = left_rota) do
    ticks_until_upper_limit = current_position + 1

    cond do
      rotations < ticks_until_upper_limit ->
        IO.puts(
          "Left Rotation: current position: #{current_position} Fewer rotations #{rotations} than limit #{ticks_until_upper_limit} so returning: #{current_position - rotations}"
        )

        current_position - rotations

      ticks_until_upper_limit == 1 ->
        IO.puts(
          "Left Rotation: Fewer rotations #{rotations} than limit #{ticks_until_upper_limit} so returning: #{current_position - rotations}"
        )

        rotate_dial(p1_upper_limit(), {:left, rotations - ticks_until_upper_limit})

      true ->
        IO.puts(
          "Left Rotation: current_position: #{current_position}, rotations #{rotations} exceeded limit #{ticks_until_upper_limit} so continueing upper limit with rotations at #{rotations - ticks_until_upper_limit}"
        )

        rotate_dial(p1_upper_limit(), {:left, rotations - ticks_until_upper_limit})
    end
  end

  defp apply_rotation(current_position, {direction, rotations}, limit) do
    if rotations <= limit do
      IO.puts("Returning #{current_position - rotations}")
      current_position - rotations
    else
      leftover_rotations = rotations - limit
      IO.puts("#{to_string(direction)} Leftovers #{leftover_rotations}")
      rotate_dial(p1_lower_limit(), {direction, leftover_rotations})
    end
  end

  def part2(_input) do
  end
end
