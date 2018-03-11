%%%-------------------------------------------------------------------
%%% @author wh
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%

%%从元组列表 TupleList 里查找元组的第 N 个值跟 Key 是一样的元素，如果找到这个元素，
%% 则把这个元素从列表里提取出来，最后返回被提取的元素和提取后的元组列表
%%% @end
%%% Created : 11. 三月 2018 12:58
%%%-------------------------------------------------------------------
-module(preparation).
-author("wh").

%% API
-compile(export_all).

-spec keytake(Key, N, TupleList1) -> {value, Tuple, TupleList2} | false when
	Key :: term(),
	N :: pos_integer(),  %pos_integer() 内置函数 从1 整数开始
	TupleList1 :: [tuple()],
	TupleList2 :: [tuple()],
	Tuple :: tuple().

keytake(Key, N, L) when is_integer(N), N > 0 ->
	keytake(Key, N, tuple_to_list(L), []).

keytake(Key, _N, [H|T], L) when H =:= Key ->
	{value, H, lists:reverse(L, T)};
keytake(Key, N, [H|T], L) ->
	keytake(Key, N, T, [H|L]);
keytake(_K, _N, [], _L) -> false.





%%keytake(Key, N, TupleList1) ->
%%	keytake(Key, N, TupleList1, []).

%%keytake(_Key, _N, [], _Acc) ->
%%	false;
%%keytake(Key, N, [Tuple | Rest], Acc) ->
%%	Value = element(N, Tuple) ,
%%	if
%%		Value =:= Key ->
%%			{value, Tuple, lists:reverse(Acc) ++ Rest};
%%		true ->
%%			keytake(Key, N, Rest, [Tuple | Acc])
%%	end.







loop() ->
	receive
		apple ->
			io:format("Apple~n"),
			loop();
		android ->
			io:format("Android~n"),
			loop();
		wp ->
			io:format("Wp~n")
	end.


test() ->
	PID = spawn(fun() -> loop() end),
	PID ! apple,
	PID ! android,
	PID ! wp,
	io:format("Over!~n").

%%1、写一个函数，功能如下：
%%0 返回 white
%%1 返回 green
%%2 返回 blue
%%其他 返回 yellow
%%分别用function clause, case clause, if clause 实现

color1(0) ->
	white;
color1(1) ->
	green;
color1(2) ->
	blue;
color1(_) ->
	yellow.


color2(C) ->
	case C of
		  0->white;
		  1 ->green;
		 2 ->blue;
		_ ->yellow
end.



color3(C) ->
	if
		C=:=0 ->white ;
		C=:=1 ->green ;
		C=:=2 ->blue;
		true -> yellow
	end.


%%2、尾递归实现 1+2+3+……+100

sum(N) when is_integer(N),N>0->
	N+sum(N-1);
sum(0) ->0.

