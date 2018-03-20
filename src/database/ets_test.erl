%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%
%%% @end
%%% Created : 20. 三月 2018 16:33
%%%-------------------------------------------------------------------
-module(ets_test).
-author("Eric").

%% API
-compile([export_all]).

start() ->
	lists:foreach(fun test_ets/1,
		[set,ordered_set,bag,duplicate_bag]).

test_ets(Mode) ->
	TableId =ets:new(test,[Mode]),
	ets:insert(TableId,{a,1}),
	ets:insert(TableId,{b,1}),
	ets:insert(TableId,{a,1}),
	ets:insert(TableId,{a,3}),
	List =ets:tab2list(TableId),
	io:format("~-13w => ~p~n",[Mode,List]),
	ets:delete(TableId).
























