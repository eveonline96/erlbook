%%%-------------------------------------------------------------------
%%% @author wh
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%(5).编写一个名为 math_functions.erl 的模块，并导出函数 even/1 和 odd/1。
%% even(X) 函数应当是偶整数时返回 true，否则返回false。
%% odd(X)应当在 X 是奇整数时返回 flase
%%% @end
%%% Created : 27. 二月 2018 0:38
%%%-------------------------------------------------------------------
-module(math_functions).
-author("wh").

%% API
-export([even/1,odd/1,filter/2,split/1,split_1/1]).


%%even(X) when X rem 2=:=0-> ture;
%%even(X) when X rem 2=/=0-> false
%%	.
%%
%%odd(X) when X rem 2=:=0-> false;
%%odd(X) when X rem 2=/=0-> true
%%.

even(X) when is_integer(X) ->
	case (X rem 2 =:= 0) of
		true -> true;
		false -> false
	end.


odd(X) when is_integer(X)->
	case (X rem 2=/=0)  of
		true->true;
		false ->false
end.


% (6).向 math_functions.erl 添加一个名为 filter(F, L) 的高阶函数，
% 它返回 L 里所有符合条件的元素 X (条件是F(X)为true)
%1> math_functions:filter(fun(X) -> X rem 2 =:=0 end,[1,2,3,4,5,6,7]).
%%[2,4,6]
filter(F, L) ->
	[X || X<-L , F(X) =:=true ].


% (7).向 math_functions.erl 添加一个返回{Even，Odd}的split(L)函数，
% 其中 Even 是一个包含 L 里所有偶数的列表，Odd是一个包含L里所有奇数的列表。
% 请用两种不同的方式编写这个函数，一种使用归集器，另一种使用在练习6中编写的filter函数。
split(L) ->
	split_acc(L,[],[]).

split_acc([H|T],Evens,Odds)->
	case (H rem 2=:=0) of
		  true -> split_acc(T,[H|Evens],Odds);
			false-> split_acc(T,Evens,[H|Odds])
end;
split_acc([],Evens,Odds) ->
	{lists:reverse(Evens),lists:reverse(Odds)}
.

%遍历两边效率低
split_1(L) ->
	Evens= [X || X<-L , (X rem 2 ) =:=0 ],
	Odds = [X || X<-L , (X rem 2 ) =:=1 ],
	{Evens,Odds}.


