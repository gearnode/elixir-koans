-module(echo).
%% don't forget to export function.
-export([start/0, loop/0]).

start() ->
  spawn(echo, loop, []).

loop() ->
  receive
    {From, Message} ->
      %% send process to From argument
      From ! Message,
      loop()
  end.

%% start erl => erl
%% compile => c(echo).
%% start process => Pid = echo:start().
%% send instruction to process => {_, ok} = Pid ! {self(), io:fwrite("Hello Process !\n")}
