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

  test "adding element begin of list" do
    a = [1, 2, 3, 4, 5]

    assert [0|a] == [0, 1, 2, 3, 4, 5]
  end

  test "pin operator" do
    x = 1

    assert (^x = 1) == 1
    assert_raise MatchError, fn ->
      ^x = 0
    end
    assert_raise MatchError, fn ->
      ^x = 2
    end

    assert_raise MatchError, fn ->
      {x, x} = {2, 0}
    end
  end

  test "unsed var" do
    [h|_] = [1, 2, 3]

    assert h == 1
  end

  test "FizzBuzz" do
    fizzbuzz = fn
        number when rem(number, 3) == 0 and rem(number, 5) == 0 -> "FizzBuzz"
        number when rem(number, 3) == 0 -> "Fizz"
        number when rem(number, 5) == 0 -> "Buzz"
        number -> number
    end

    assert fizzbuzz.(15) == "FizzBuzz"
    assert fizzbuzz.(3) == "Fizz"
    assert fizzbuzz.(5) == "Buzz"
    assert fizzbuzz.("hello") == "hello"
  end

  test "Function context" do
    name = "Gearnode"
    f = fn -> name end
    name = "World"

    assert f.() == "Gearnode"
    assert f.() != name

    f = fn (from) ->
      fn (to) -> "Hello #{to} from #{from}" end
    end

    x = f.("John")
    assert x.("Emilie") == "Hello Emilie from John"
  end

  test "Parameterized functions" do
    prefix = fn (the_prefix) ->
      fn (the_string) ->
        "#{the_prefix} #{the_string}"
      end
    end

    mrs = prefix.("Mrs")
    assert mrs.("Smith") == "Mrs Smith"
    assert prefix.("Elixir").("Rocks") == "Elixir Rocks"
  end

  test "Passing functions as arguments" do
    time_2 = fn (x) -> x * 2 end
    apply = fn(func, value) -> func.(value) end

    assert apply.(time_2, 7) == 14
  end

  test "The & notation" do
    x = &(&1 * 2 + &2)

    assert x.(7, 1) == 15

    return = &(&1)
    assert return.("hello") == "hello"
  end

  test "Tuples functions" do
    divrem = fn (a, b) -> { div(a, b), rem(a, b) } end
    assert divrem.(10, 3) == { 3, 1 }

    short_divrem = &{div(&1, &2), rem(&1, &2)}
    assert short_divrem.(10, 3) == { 3, 1 }
  end

  test "Keyword lists" do
    # List of tuples
    # Don't use to store data
    # Use list of tuples for options parameters
    list = [a: 1, b: 2]
    assert list == [{:a, 1}, {:b, 2}]
    assert list[:a] == 1

    new_list = [a: 0] ++ list
    # Keys can be given more than once !!!
    # Keyword list is use for create custom DSL
    assert new_list == [a: 0, a: 1, b: 2]
  end

  test "Maps or Hash in Ruby" do
    user = %{
      id: 1,
      first_name: "John",
      last_name: "Doe",
      language: :french
    }

    assert user[:id] == 1
    assert user[:language] == :french
  end
end
