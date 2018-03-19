%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc

%%% @end
%%% Created : 17. 三月 2018 16:12
%%%-------------------------------------------------------------------
-module(newclient).
-author("Eric").
%%	客户端
%% API
-compile([export_all]).

%%login  :检查自身进程是否注册
login(Name) ->
	case whereis(cli) of
		undefined ->
			register(cli,spawn(newclient,client,[sernode(),Name]));
		_Pid ->  already_login
	end.

sernode() ->
	server@PC20180304.

%%{Pid,Node}!{self(),XX }
%%Pid !{self(),XX}
%%client 不同参数算作重载嘛    调用时是不是不同的Pid
client(SerNode,Name) ->
	waitserver(SerNode,Name),
	client(SerNode).

client(SerNode) ->
	receive
		logout ->
			{ser,SerNode} !{logout,self()},
			exit(normal);
		{transfer,ToName,Mesg}  ->
			{ser,SerNode} !{transfer,self(),ToName,Mesg};
		{msgfrom,FromName,Mesg}  ->
			io:format("Message from ~p:~p~n",[FromName,Mesg]);
		{ser,What} ->
			io:format("ser say:~p~n",[What])
	end,
	client(SerNode).

%%-----------------------------------------------------------------

%%等待服务器响应
waitserver(SerNode,Name) ->
	{ser,SerNode} ! {login,self(),Name},
	receive
		{stop,ser,Why} ->
			io:format("~p~n",[Why]),
			exit(normal);
		{ser,What} ->
			io:format("~p~n",[What])
	end.

%%--------------------------------------------------------------

%%send  :检查自身进程,然后发送给自己进程的客户端接收
send(ToName,Mesg) ->
	case whereis(cli) of
		  undefined->
				client_not_login;
		  _ ->
			  cli !{transfer,ToName,Mesg}
	end.
%%---------------------------------------------------------------

%%退出:给自身进程发送一条logout的消息
logout() ->
	cli ! logout.






















