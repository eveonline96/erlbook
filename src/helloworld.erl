%%%-------------------------------------------------------------------
%%% @author wh
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 23. 二月 2018 16:30
%%%-------------------------------------------------------------------
-module(helloworld).
-author("wh").

%% API
-export([
  test/0,
  test/1,
  start/1,
  loop/1
]).

test()->
  io:format("hello idea").

test(Name) ->
  io:format("hello ~w",[Name]).

start(Dir)->
  spawn(helloworld,loop,[Dir]).

loop(Dir) ->
  receive
    {Client,list_dir} ->
      Client!{self(),file:list_dir(Dir)};
    {Client,{get_file,File}}->
      Full=filename:join(Dir,File),
      Client!{self(),file:read_file(Full)}
  end,
  loop(Dir).