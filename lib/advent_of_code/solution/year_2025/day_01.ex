defmodule AdventOfCode.Solution.Year2025.Day01 do
  """
  SELECT survey_1, country, category, norm_1, norm_2, final_norm CASE country = 'US' use norm_1, CASE country = 'TW' use norm_2
  """

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
      |> Enum.reduce({0, p1_starting_point()}, &rotate_dial(&1, &2, true))

    password
  end

  def part2(input) do
    {password, _final_position} =
      p1_parse_input(input)
      |> Enum.reduce({0, p1_starting_point()}, &rotate_dial(&1, &2, false))

    password
  end

  """
  The dial starts by pointing at 50.
  The dial is rotated L68 to point at 82; during this rotation, it points at 0 once.
  The dial is rotated L30 to point at 52.
  The dial is rotated R48 to point at 0.
  The dial is rotated L5 to point at 95.
  The dial is rotated R60 to point at 55; during this rotation, it points at 0 once.
  The dial is rotated L55 to point at 0.
  The dial is rotated L1 to point at 99.
  The dial is rotated L99 to point at 0.
  The dial is rotated R14 to point at 14.
  The dial is rotated L82 to point at 32; during this rotation, it points at 0 once.
  """

  defp rotate_dial(rotation, {password, position}, true) do
    {new_position, _tc} = apply_rotation(position, rotation, 0, false)
    {maybe_increment_password(password, new_position), new_position}
  end

  defp rotate_dial({dir, ticks} = rotation, {password, position}, false) do
    {new_position, tc} = apply_rotation(position, rotation, 0, skip_transition?(dir, position))
    new_pw = maybe_increment_password(password, new_position) + tc

    IO.puts(
      "START dir:#{to_string(dir)} ticks:#{ticks} pos:#{position}\nEND tc:#{tc} - pos:#{new_position}\nTOTAL #{password} -> #{new_pw}"
    )

    {maybe_increment_password(password, new_position) + tc, new_position}
  end

  defp skip_transition?(:left, 0), do: true
  defp skip_transition?(_dir, _val), do: false

  defp maybe_increment_password(password, 0), do: password + 1
  defp maybe_increment_password(password, _position), do: password

  defp apply_rotation(0, {_dir, 0}, tc, skip) do
    {current_position, tc}
  end

  defp apply_rotation(current_position, {_dir, 0}, tc, skip) do
    {current_position, tc + 1}
  end

  defp apply_rotation(current_position, {dir, rotations}, transient_count, skip) do
    ticks_until_transition = ticks_until_transition(dir, current_position)

    if rotations < ticks_until_transition do
      new_position = set_position(dir, current_position, rotations)
      {new_position, transient_count}
    else
      left_rotations = rotations - ticks_until_transition
      new_position = transition_position(dir)

      updated_tc =
        transient_count_from_transition(transient_count, new_position, skip, left_rotations)

      # IO.puts(
      #   "FROM #{current_position}, #{rotations}, #{transient_count}\nTO #{new_position}, #{left_rotations}, #{updated_tc}"
      # )

      apply_rotation(new_position, {dir, rotations - ticks_until_transition}, updated_tc, false)
    end
  end

  defp transient_count_from_transition(tc, _pos, _skip, 0) do
    tc
  end

  defp transient_count_from_transition(tc, 0, false, _rot) do
    tc + 1
  end

  defp transient_count_from_transition(tc, 99, false, _rot) do
    tc + 1
  end

  defp transient_count_from_transition(tc, _pos, _skip, _rot) do
    tc
  end
end
