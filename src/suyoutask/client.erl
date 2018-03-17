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


get_servernode() ->
	server@PC20180304.

% 用户命令
logon(Name) ->
% 首先检查用户自身是否在系统中运行（是否可以查找到 mess_client 进程）
	case whereis(mess_client) of
		undefined ->
			register(mess_client,
				spawn(client, client, [get_servernode(), Name]));
		_ -> already_logged_on
	end.

logoff() ->
	mess_client ! logoff.

%如果用户存在则将消息发送给 mess_client：
send(ToName, Message) ->
	case whereis(mess_client) of
		undefined ->
			not_logged_on;
		_ -> mess_client ! {message_to, ToName, Message}

	end.

% 在每个节点上运行的客户端进程
client(Server_Node, Name) ->
	{messenger, Server_Node} ! {self(), logon, Name},%检查是否已登陆
	await_result(),
	client(Server_Node).

client(Server_Node) ->
	receive
		logoff ->
			{messenger, Server_Node} ! {self(), logoff},
			exit(normal);
		{message_to, ToName, Message} ->
			{messenger, Server_Node} ! {self(), message_to, ToName, Message},
			await_result();
		{message_from, FromName, Message} ->
			io:format("Message from ~p: ~p~n", [FromName, Message])
	end,
	client(Server_Node).

% 等待服务器响应
await_result() ->
	receive
		{messenger, stop, Why} -> % 停止客户端
			io:format("~p~n", [Why]),
			exit(normal);
		{messenger, What} ->  % 正常响应
			io:format("~p~n", [What])
	end.








