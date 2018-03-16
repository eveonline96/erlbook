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


%服务器启动程序
server_start() ->
	register(messenger,spawn(messenger,server,[[]])).

% 服务器进程
server(UserList) ->
	receive
		{From,login,Name} ->
			NewUserList = server_login(From,Name,UserList),
			server(NewUserList);
		{From,logout} ->
			NewUserList= server_logout(From,UserList),
			server(NewUserList);
		{From,message_to,To,Message,UserList} ->
			server_tran(From,To,Message,UserList),
			server(UserList)
	end.

%客户端登录验证
server_login(From,Name,UserList) ->
	case lists:keymember(Name,2,UserList) of
		  true->
				From!{messager,stop,"user existed"};
		  false ->
			  From!{messager,login},
			  [{From,Name} | UserList]
	end.

%客户端退出
server_logout(From, UserList) ->
	lists:keydelete(From,1,UserList).

% 服务端传输
server_tran(From,To, Message, UserList) ->
	case  lists:keysearch(From,1,UserList) of
		false->
			  From!{messager,stop,login_false} ;
		{value,{From,Name}} ->
			  server_tran(From,Name,To,Message,UserList)
	end.


%如果客户端进程存在,则进行消息收发
server_tran(From,Name,To,Message,UserList) ->
	case lists:keysearch(To,2,UserList) of
		  false->
			  From!{messenger,reveiver_not_find};
		{value,{ToPid,To}} ->
			ToPid !{mesg_from,Name,Message},
			From!{messenger,sent}
	end.








































