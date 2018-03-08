%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%(1)计算圆和直角的面积与周长
%%% @end
%%% Created : 08. 三月 2018 11:41
%%%-------------------------------------------------------------------
-module(geometry).
-author("Administrator").

%% API
-export([area/1,test/0]).


test() ->
	12 = area({rectangle,2,6}),
	144= area({square,12}),
	50.0 =area({triangle,10,10}),
	ojbk.


area({rectangle,Width,Height}) ->
	Width * Height	;

area({circle,Radius}) ->
	3.14*Radius*Radius;

area({square,Side}) ->
	Side *Side;

area({triangle,Tri_heigh,Bottom}) ->
	0.5*Tri_heigh*Bottom.