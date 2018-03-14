%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%
%%% @end
%%% Created : 13. 三月 2018 15:00
%%%-------------------------------------------------------------------
-module(area_server_final).
-author("Eric").

%% API
-compile(export_all).
start() ->spawn(area_server_final,loop,[]) .

area(Pid,What) ->
	rpc(Pid,What).


rpc(Pid, Request) ->
	Pid ! {self(), Request},
	receive
		{Pid, Response} ->
			Response
	end.

loop() ->
	receive
		{From, {rectangle, Width, Ht}} ->
			From ! {self(), Width * Ht},
			loop();
		{From, {circle, R}} ->
			From !  {self(), 3.14159 * R * R},
			loop();
		{From, Other} ->
			From ! {self(), {error,Other}},
			loop()
	end.




















