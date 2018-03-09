%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%% 编写一个函数来反转某个二进制型里的字节顺序
%%   用到递归的思想
%%
%%% @end
%%% Created : 08. 三月 2018 19:34
%%%-------------------------------------------------------------------
-module(reversebinarystring).
-author("${Eric}").

%% API
-export([reverse_byte/1]).

%%byte_size(Bin) ->Size  返回二进制的字节数
%%list_to_binary(L) ->B   返回一个二进制型通过把列表里的所有元素压扁后形成的(去掉括号)
%%spilt_binary(BIn,Pos) ->{Bin1,Bin2}  在pos处把二进制型一分为二
%%term_to_binary(term) ->Bin   把任何erlang类型变成二进制型

reverse_byte(Bin) ->
	reverse_byte(Bin,<<>>,1).  %被切割前的二进制型,生成的结果,位置
reverse_byte(Bin,Bin_result,Pos) when Pos =< byte_size(Bin)->  %1  到  N
	{Bin1,Bin2} =split_binary(Bin,Pos),
	K=list_to_binary([Bin1,Bin_result]),
	reverse_byte(Bin2,K,Pos);

reverse_byte(Bin,Bin_result,Pos) when Pos > byte_size(Bin)->
	Bin_result.




























