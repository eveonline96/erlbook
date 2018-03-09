%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%（2）.编写一个 map_search_pred(Map, Pred) 函数，
% 让它返回映射组里第一个符合条件的 {Key, Value} 元素
% （条件是 Pred(Key, Vaule) 为 true）。
%%1> mapsearchpred:map_search_pred(#{11 =>11 ,12=>123,13=> 1234},fun(Key,Value)-> Key=:=Value end).
%%{11,11}
%%2> mapsearchpred:map_search_pred(#{11 =>11 ,12=>123,13=> 1234},fun(Key,Value)-> Key=:=200*Value end).
%%not foundok
%%% @end
%%% Created : 08. 三月 2018 16:38
%%%-------------------------------------------------------------------
-module(mapsearchpred).
-author("${Eric}").

%% API
-export([map_search_pred/2]).

map_search_pred(Map, Pred) ->
	map_search_pred(Map,maps:keys(Map),Pred).

map_search_pred(Map,[Key|T],Pred)->
	Value=maps:get(Key,Map) ,
	case Pred(Key,Value) of
		true ->{Key,Value};
		false->map_search_pred(Map,T,Pred)
	end;

map_search_pred(_,[],_)->
	io:format("not found").
