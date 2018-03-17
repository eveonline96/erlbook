%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%  服务端

%%keymember（Key，N，TupleList） - > boolean（）
%%Key = term()
%%N = integer() >= 1
%%TupleList = [Tuple]
%%Tuple = tuple()
%%1..tuple_size（元组）
%%返回true是否存在一个元素，TupleList 其N元素th元素等于Key，否则返回 false。
%%% @end
%%% Created : 16. 三月 2018 13:35
%%%-------------------------------------------------------------------
-module(server).
-author("Eric").

%% API
-compile([export_all]).


% 启动服务器
start() ->
	register(ser, spawn(server, server, [[]])).

%服务器进程
%用户列表格式：[{ClientPid1,Name1},{ClientPid2,Name2}...]
server(UserList) ->
	receive
		{From, login, Name} ->
			NewUserList = clilogin(From, Name, UserList),
			server(NewUserList);
		{From, logout} ->
			NewUserList = clilogout(From, UserList),
			server(NewUserList);
		{From, sendto, To, Mesg} ->
			clitran(From, To, Mesg, UserList),
			io:format("Now list is : ~p~n", [UserList]),
			server(UserList)
	end.



% 服务器将新用户添加到用户列表
clilogin(From, Name, UserList) ->
	% 检查是否在其他地方登录
	case lists:keymember(Name, 2, UserList) of
		true ->
			From ! {ser, stop, user_exists_at_other_node},  %拒绝登陆
			UserList;
		false ->
			From ! {ser, logged_on},
			[{From, Name} | UserList]        %想列表中添加用户
	end.

% 服务器从用户列表中删除用户
clilogout(From, UserList) ->
	lists:keydelete(From, 1, UserList).

% 服务器在用户之间传输消息
clitran(From, To, Mesg, UserList) ->
	% 检查用户是否登录以及他是谁
	case lists:keysearch(From, 1, UserList) of
		false ->
			From ! {ser, stop, you_are_not_logged_on};
		{value, {From, Name}} ->
			clitran(From, Name, To, Mesg, UserList)
	end.
% 如果用户存在，则发送消息
clitran(From, Name, To, Mesg, UserList) ->
	% 找到接收者并发送消息
	case lists:keysearch(To, 2, UserList) of
		false ->
			From ! {ser, receiver_not_found};
		{value, {ToPid, To}} ->
			ToPid ! {msg, Name, Mesg},
			From ! {ser, sent}
	end.







































