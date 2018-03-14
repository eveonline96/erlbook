%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%4、实现一个简单的聊天系统，具备登录、登出、聊天、广播四个功能。
% (提示：每个玩家各自一个进程，聊天服务器独立一个进程，
% 玩家向服务器发出登录请求时，服务器将该玩家信息（名称、pid）存储起来，以便后续向该玩家进程发送消息。
% 当A玩家与B玩家聊天时将A, B玩家的名字及聊天内容发送到服务器，服务器收到消息后将聊天内容转发给B玩家)
%%% @end
%%% Created : 14. 三月 2018 17:20
%%%-------------------------------------------------------------------
-module(task4_server).
-author("Eric").

%% API
-compile(export_all).


start()   ->spawn(task4_server,login_loop,[]).

login_loop() ->
	receive
		{From, {name, Name}} ->

			case whereis(Name) of
			undefined ->
				From!{self(),"this Name is accept  ~n"} ,
				register(Name,From);
				_Pid ->
					From ! {self()," this name  is Exist ~n"}
			end,
			login_loop()
	end.



logout() ->
	receive
	{Pid, {logout,Response}} ->
		Response
	end.
%%chat() ->
%%	.
%%
%%
%%broadcast() _>
%%	.











