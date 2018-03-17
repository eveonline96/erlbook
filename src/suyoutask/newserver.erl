%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%  服务端
%%% @end
%%% Created : 17. 三月 2018 11:50
%%%-------------------------------------------------------------------
-module(newserver).
-author("Eric").

%% API
-compile(export_all).
start() ->register(ser,spawn(newserver,server,[[]])).
%%	register(login1,spawn(newserver,login,[[]])).

%%  服务端连接
server(UserList) ->
	receive
		{login,From,Name}  ->
			login(From,Name,UserList),
			server(UserList);
		{logout,From} ->
			logout(From,UserList),
			server(UserList);
		{tansfer,From,To,Mesg} ->
			transfer(From,To,Mesg,UserList),
			server(UserList)
	end.

%%  login
login(From,Name,UserList)->
	case lists:keymember(Name,2,UserList) of
		true  ->
			From!{ser,clinet_is_logged_in},
			UserList;
		false ->
			From!{ser,login},
			[{From,Name},UserList]
	end.

%%  logout
logout(From,UserList) ->
	lists:keydelete(From,1,UserList).


%% transfer
transfer(From,To,Mesg,UserList) ->
	case lists:keysearch(To,2,UserList) of
		false->
			From!{ser,client_not_lonin};
		{value,{ToPid,To}}->
			From!{ser,send_ok}
	end.














