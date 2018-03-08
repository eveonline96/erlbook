%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%% (2).内置函数 tuple_to_list(T) 能将元组T里的元素转换成一个列表。
%%% 请编写一个名为 my_tuple_to_list() 的函数来做同样的事。
%%% 不要使用内置函数
%%% @end
%%% Created : 08. 三月 2018 13:22
%%%-------------------------------------------------------------------
-module(mytupletolist).
-author("${Eric}").

%% API
-export([my_tuple_to_list/1]).


%%T是元组，F是伐值>=0,L是列表
%%element(N, Tuple) -> term()
%%N = integer() >= 1
%%Tuple = tuple()
%%1..tuple_size(Tuple)
%%Returns the Nth element (numbering from 1) of Tuple, for example:

my_tuple_to_list(T) ->
	K=tuple_size(T), %
	io:format("~w",K),
	my_tuple_to_list(T,K,0,[]). %开始为空的列表

my_tuple_to_list(T,Index,F,L)  when Index > F->
	my_tuple_to_list(T,Index-1,F,[element(Index,T)|L]);  %从0开始到n-1
my_tuple_to_list(_T,Index,F,L) when Index =:=F  ->	%到0时返回列表
	L.



