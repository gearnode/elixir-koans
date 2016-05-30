-module(atoms).
-export([ truth/0, is_equal/2 ]).

truth() ->
  true =:= true.

is_equal(a, b) ->
  a =:= b.

