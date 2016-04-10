ExUnit.start
ExUnit.configure trace: true

defmodule KoansTest do
  # Run unit test on concurrently with other tests
  use ExUnit.Case, async: true

  test "Exercice: Functions-1" do
    list_concat = fn l1, l2 -> l1 ++ l2 end
    assert list_concat.([:a, :b], [:c, :d]) == [:a, :b, :c, :d]

    sum = &(&1 + &2)
    assert sum.(2, 5) == 7

    pair_tuple_to_list = fn {a, b} -> [a, b] end
    assert pair_tuple_to_list.({1234, 5678}) == [1234, 5678]
  end

  test "One Function, Multiple Bodies" do
    handle_open = fn
      {:ok, file} -> "Read data #{IO.read(file, :line)}"
      {_, error} -> "Erro: #{:file.format_error(error)}"
    end

    assert handle_open.(File.open("README.md")) == "Read data # elixir-koans\n"
    assert handle_open.(File.open("nonexistent")) == "Erro: no such file or directory"
  end

  test "Exercice: Functions-2 && Functions-3" do
    fizzbuzz = fn
      (0, 0, _) -> "FizzBuzz"
      (0, _, _) -> "Fizz"
      (_, 0, _) -> "Buzz"
      (_, _, a) -> a
    end

    assert fizzbuzz.(0, 0, 4) == "FizzBuzz"
    assert fizzbuzz.(0, 'hello', :ok) == "Fizz"
    assert fizzbuzz.(1.2, 0, [1,2,3]) == "Buzz"
    assert fizzbuzz.(9, false, 'test') == 'test'

    final_fizzbuzz = fn n ->
      fizzbuzz.(rem(n, 3), rem(n, 5), n)
    end
    result = Enum.map(10..16, final_fizzbuzz)

    assert result == ["Buzz", 11, "Fizz", 13, 14, "FizzBuzz", 16]
  end

  test "Function can return functions" do
    fn1 = fn ->
      fn ->
        "Hello"
      end
    end
    other = fn1.()

    assert other.() == "Hello"
  end

  test "Functions remenber their original environment" do
    greeter = fn name -> fn -> "#{name}" end end
    john_greeter = greeter.("John")

    assert john_greeter.() == "John"
  end

  test "Parameterized Functions" do
    add_n = fn n -> fn other -> n + other end end
    add_two = add_n.(3)
    add_five = add_n.(5)

    assert add_two.(2) == 5
    assert add_five.(7) == 12
  end

  test "Exercice: Functions-4" do
    prefix = fn pre -> fn value -> pre <> " " <> value end end
    mrs = prefix.("Mrs")

    assert mrs.("Smith") == "Mrs Smith"
    assert prefix.("Elixir").("Rocks") == "Elixir Rocks"
  end

  test "Passing Functions As Arguments" do
    time_2 = fn n -> n * 2 end
    apply = fn fun, value -> fun.(value) end

    assert apply.(time_2, 7) == 14
  end

  test "The & Notation" do
    square = &(&1*&1)

    assert square.(4) == 16

    divrem = &{ div(&1, &2), rem(&1, &2) }

    assert divrem.(13, 5) == {2, 3}

    # Other syntax
    # This same result
    # &(IO.puts(&1)) == &IO.puts/1
  end

  test "Exercice: Functions-5" do
    list = [1,2,3,4]

    map = fn x -> x + 2 end
    min_map = &(&1+2)

    assert Enum.map(list, map) == Enum.map(list, min_map)

    each = fn x -> IO.inspect(x) end
    #min_each = &IO.inspect/1

    #assert Enum.each(list, each) == Enum.each(list, min_each)
  end

  defmodule Times do
    def double(n), do: n*2
    def triple(n), do: n*3
    def quadruple(n), do: double(n)*2
  end

  test "Exercie: ModulesAndFunctions-1" do
    assert Times.triple(3) == 9
    assert Times.quadruple(2) == 8
  end

  defmodule RecurMaths do
    def sum(0), do: 0
    def sum(n), do: n + sum(n-1)

    def gcd(x,0), do: x
    def gcd(x,y), do: gcd(y, rem(x,y))
  end

  test "Module & Recursion" do
    assert RecurMaths.sum(0) == 0
    assert RecurMaths.sum(5) == 15
    assert RecurMaths.gcd(20,0) == 20
    assert RecurMaths.gcd(20,15) == 5
  end

  defmodule Guard do
    def what_is(element) when is_number(element) do
      "#{element} is number"
    end

    def what_is(element) when is_atom(element) do
      "#{element} is atom"
    end

    def what_is(element) when is_list(element) do
      "#{element} is list"
    end
  end

  test "Guard Clauses" do
    assert Guard.what_is(:cat) == "cat is atom"
    assert Guard.what_is(99) == "99 is number"
  end

  test "The Pipe Operator" do
    word = "Hello"

    assert word |> String.length == String.length(word)
  end
  test "Module Name is Atom" do
    assert is_atom IO == true
    assert to_string IO == "Elixir.IO"
    assert (:"Elixir.IO" === IO) == true
    assert :"Elixir.IO".puts "hello" == :ok
  end

  # 1. :io_lib.format("~.2f", [1.2])
  # 2. System.get_env "SHLVL"
  # 3. Path.extname("un_truc.iex")
  # 4. System.cwd
  # 5. System.cmd "ls"

  defmodule MyList do
    def len([]), do: 0
    def len([ _ | tail ]), do: 1 + len(tail)

    def square([]), do: []
    def square([ head | tail ]), do: [ head*head | square(tail) ]

    def add_1([]), do: []
    def add_1([ head | tail ]), do: [ head+1 | add_1(tail) ]

    def map([], _func), do: []
    def map([ head | tail ], func), do: [ func.(head) | map(tail, func) ]

    def sum(list) when is_list([]), do: do_sum(list, 0)
    defp do_sum([], total), do: total
    defp do_sum([ head | tail ], total), do: do_sum(tail, total+head)

    def sum2([]), do: 0
    def sum2([ head | tail ]), do: head + sum(tail)

    def reduce([], value, _), do: value
    def reduce([ head | tail ], value, func) do
      reduce(tail, func.(head, value), func)
    end

    def mapsum([], _), do: 0
    def mapsum([ head | tail ], func) do
      func.(head) + mapsum(tail, func)
    end

    def max([x]), do: x
    def max([ head | tail ]), do: Kernel.max(head, max(tail))
  end

  defmodule Swapper do
    def swap([]), do: []
    def swap([ a, b | tail ]), do: [ b, a | swap(tail) ]
    def swap([_]), do: raise "Can't swap this list"
  end

  defmodule MyList do
    def span(from, to) do
      do_span(from, to, 0)
    end

    defp do_span(from, to, _total) when from > to, do: raise "from can't > to"
    defp do_span(from, to, total) when from == to, do: total
    defp do_span(from, to, total) when from < to do
      do_span(from + 1, to, total + 1)
    end
  end

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
    assert user[:something] == nil
    # Equal fetch on Ruby
    assert_raise KeyError, fn ->
      user.something
    end
  end
end
