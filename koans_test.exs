ExUnit.start
ExUnit.configure trace: true

defmodule KoansTest do
  # Run unit test on concurrently with other tests
  use ExUnit.Case, async: true

  test "concatenation of two string" do
    say_hello = fn (name) -> "hello " <> name end

    assert say_hello.("world") == "hello world"
  end

  test "sum two numbers" do
    sum = fn (a, b) -> a + b end

    assert sum.(1, 1) == 2
  end

  test "concatenation of two list" do
    concatenation = fn (list1, list2) -> list1 ++ list2  end

    assert concatenation.([3], [1, 2]) == [3, 1, 2]
  end
end
