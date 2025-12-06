defmodule Day06 do
  def part1(file_name) do
    file_name
    |> simple_parse()
    |> pivot()
    |> Enum.reduce(0, fn list, total ->
      [op | nums] = list |> Enum.reverse()

      {result, []} =
        nums |> Enum.intersperse(op) |> Enum.join() |> Code.eval_string()

      total + result
    end)
  end

  def part2(file_name) do
    lines = lines(file_name)
    [ops | nums] = Enum.reverse(lines)

    ops = String.split(ops, " ", trim: true)
    nums = Enum.reverse(nums)

    longest_num =
      nums |> Enum.map(&longest_number/1) |> Enum.max()

    nums
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> then(fn graphemes ->
        list_size = length(graphemes)
        needed_padding = rem(list_size, longest_num)
        needed_padding = if needed_padding == 0, do: 0, else: longest_num - needed_padding
        padding = List.duplicate(" ", needed_padding)
        graphemes ++ padding
      end)
    end)
    |> pivot()
    |> Enum.map(fn list -> list |> Enum.join() |> String.trim() end)
    |> Enum.chunk_by(fn item -> item == "" end)
    |> Enum.reject(fn item -> item == [""] end)
    |> Enum.zip(ops)
    |> Enum.reduce(0, fn {nums, op}, total ->
      {result, []} =
        nums |> Enum.intersperse(op) |> Enum.join() |> Code.eval_string()

      total + result
    end)
  end

  def longest_number(line) do
    Regex.scan(~r/\d+/, line, capture: :all)
    |> List.flatten()
    |> Enum.sort_by(&String.length/1, :desc)
    |> hd()
    |> String.length()
  end

  def lines(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(&String.trim_trailing/1)
  end

  def simple_parse(file_name) do
    file_name
    |> File.stream!()
    |> Stream.map(fn line ->
      line
      |> String.trim_trailing()
      |> String.split(" ", trim: true)
    end)
  end

  def pivot(list) do
    list
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end
end
