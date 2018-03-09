%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%如果想定义自己的命令

%%% @end
%%% Created : 09. 三月 2018 16:54
%%%-------------------------------------------------------------------
-module(user_default).
-author("${Eric}").

%% API
-compile(export_all).

hello() ->
	"Hello ,fuck you  erlang".

away(Time) ->
	io:format("Joe is away will be back in ~w minutes~n ",[Time]).

