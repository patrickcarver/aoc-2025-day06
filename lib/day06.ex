defmodule Day06 do
  def part1(file_name) do
    {nums, ops} = parse(file_name)

    nums
    |> Stream.map(&split_line/1)
    |> pivot()
    |> Enum.zip(ops)
    |> Enum.reduce(0, &add_op_result_to_total/2)
  end

  def part2(file_name) do
    {nums, ops} = parse(file_name)

    longest_num = length(nums)

    nums
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> trail_pad_graphemes(longest_num)
    end)
    |> pivot()
    |> reform_nums()
    |> Enum.zip(ops)
    |> Enum.reduce(0, &add_op_result_to_total/2)
  end

  def add_op_result_to_total({nums, op}, total) do
    total + perform_op(nums, op)
  end

  def parse(file_name) do
    lines = lines(file_name)
    [ops | nums] = Enum.reverse(lines)

    ops = split_line(ops)
    nums = Enum.reverse(nums)

    {nums, ops}
  end

  def trail_pad_graphemes(graphemes, longest_num) do
    list_size = length(graphemes)
    needed_padding = rem(list_size, longest_num)
    needed_padding = if needed_padding == 0, do: 0, else: longest_num - needed_padding
    padding = List.duplicate(" ", needed_padding)
    graphemes ++ padding
  end

  def reform_nums(nums) do
    nums
    |> Enum.map(fn list -> list |> Enum.join() |> String.trim() end)
    |> Enum.chunk_by(fn item -> item == "" end)
    |> Enum.reject(fn item -> item == [""] end)
  end

  def perform_op(nums, op) do
    nums
    |> Enum.intersperse(op)
    |> Enum.join()
    |> Code.eval_string()
    |> elem(0)
  end

  def split_line(line) do
    String.split(line, " ", trim: true)
  end

  def lines(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  def pivot(list) do
    list
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
