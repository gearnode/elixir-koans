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

  test "is in range" do
    is_in_range = fn (range, somthing) -> somthing in range end

    assert is_in_range.(1..5, 5) == true
    assert is_in_range.(1..5, 6) == false
  end

  test "match on tuples" do
    {a, b, c} = {1, "world", :atom}

    assert a == 1
    assert b == "world"
    assert c == :atom
  end

  test "match on list" do
    [a, b, c] = [1, 2, "hello"]

    assert a == 1
    assert b == 2
    assert c == "hello"
  end

  test "match tuples with atom" do
    {:ok , a} = {:ok, :valid}

    assert :ok == :ok
    assert a == :valid

    assert_raise MatchError, fn ->
      {:ok, result} = {:error, :oops}
    end
  end

  test "match with pipe" do
    [head | tail] = [1, 2, 3, 4, 5]

    assert head == 1
    assert tail == [2, 3, 4, 5]

    assert_raise MatchError, fn ->
      [head | tail] = []
    end
  end
end
