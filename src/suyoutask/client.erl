%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%  客户端
%%% @end
%%% Created : 16. 三月 2018 13:38
%%%-------------------------------------------------------------------
-module(client).
-author("Eric").

%% API
-compile([export_all]).



%用户登录命令 先检查用户自身是否在系统中注册运行
login(Name) ->
	case whereis(client) of
		  undefined->
				register(client,spawn(chat_client,client_process,[servernode(),Name]));
		  _Pid ->  logged_in
	end.

% 服务器地址
servernode() ->
	server@PC20180304.

%客户端进程
client_process(Server_Node,Name) ->
	{messager,Server_Node}!{self(),login,Name},
	await_server(),
	client_process(Server_Node).


await_server() ->
	receive
		{messenger,stop,Why} ->
			io:format("~p~n",[Why]),
			exit(normal);
		{messager,What} ->
			io:format("~p~n",[What])
	end.


client_process(Server_Node) ->
	receive
		logout ->
			{messenger,Server_Node} !{self(),logout},
			exit(normal);
		{mesg_to,ToName,Message} ->
			{messenger,Server_Node}!{self(),message_to,ToName,Message},
			await_server();
		{mesg_from,FromName,Message} ->
			io:format("Message from ~p:~p~n",[FromName,Message])

	end,
	client_process(Server_Node)	.



%%用户登出
logout() ->
	client!logout.

%发送消息
send(ToName,Message) ->
	case whereis(client) of
		  undefined-> io:format("not login");
		  _Pid  ->client!{message_to,ToName,Message}
	end.


























