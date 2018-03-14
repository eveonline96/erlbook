%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%%%3、[{A,B,C} || A <- lists:seq(1,N),
%%B <- lists:seq(1,N),
%%C <- lists:seq(1,N),
%%A+B+C =< N,
%%A*A+B*B =:= C*C] 的结果是什么？
%%(lists:seq(1, N) 返回 1 到 N 之间的整数组成的列表，
%%如 lists:seq(1, 3) = [1, 2, 3])

%%  这个列表推导输出符合所有条件(A,B,C)的值。 A,B,C提取从1到N的所有可能的值，条件是A+B+C小于等于N并且A*A+B*B等于C*C
%%2> task3:pythag(16).
%%[{3,4,5},{4,3,5}]
%%% @end
%%% Created : 14. 三月 2018 17:07
%%%-------------------------------------------------------------------
-module(task3).
-author("Eric").

%% API
-export([pythag/1]).
pythag(N) ->
	[{A,B,C} ||
		A <- lists:seq(1,N),
		B <- lists:seq(1,N),
		C <- lists:seq(1,N),
		A+B+C =< N,
		A*A+B*B =:= C*C
	].

