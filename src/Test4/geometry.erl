%%%-------------------------------------------------------------------
%%% @author wh
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%(1)计算圆和直角的面积与周长
%%% @end
%%% Created : 24. 二月 2018 17:23
%%%-------------------------------------------------------------------
-module(geometry).
-author("wh").

%% API
-export([area/1,test/0]).

test() ->
	12 = area({rectangle,2,6}),
	144= area({square,12}),
	50 =area({triangle,10,10}),
	test_working.

area({rectangle,Width,Height}) ->
	Width *Height;

area({square,Side}) ->
	Side *Side;

area({triangle,Tri_height,Bottom}) ->
	Tri_height * Bottom* 0.5;

area({round,Radius}) ->
	3.1415* Radius*Radius.

