defmodule Day06Test do
  use ExUnit.Case

  @test_file "priv/test.txt"
  @input_file "priv/input.txt"

  test "it actually works" do
    assert Day06.part1(@test_file) == 4_277_556
    assert Day06.part1(@input_file) == 4_719_804_927_602
    assert Day06.part2(@test_file) == 3_263_827
    assert Day06.part2(@input_file) == 9_608_327_000_261
  end
end
