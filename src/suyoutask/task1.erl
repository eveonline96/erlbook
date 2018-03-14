%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%1、L = [1, 2, 3, 4, 5] ，分别用列表解析和尾递归的方法将列表 L 的每个元素乘以2 。
%%% @end
%%% Created : 14. 三月 2018 16:48
%%%-------------------------------------------------------------------
-module(task1).
-author("Eric").

%% API
-compile(export_all).
%%列表解析
function1() ->
	L = [1, 2, 3, 4, 5],
	_Result = [K*2 || K <- L].
%尾递归
function2() ->
	L = [1, 2, 3, 4, 5],
	function2(L,[]).

function2([H|T],K) ->
	function2(T,[H*2|K]);
function2([],K)->
		lists:reverse(K).