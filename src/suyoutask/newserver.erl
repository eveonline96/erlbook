%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%  服务端 :
%%% 用户列表格式：[{ClientPid1,Name1},{ClientPid2,Name2}...]
%%% @end
%%% Created : 17. 三月 2018 11:50
%%%-------------------------------------------------------------------
-module(newserver).
-author("Eric").

%% API
-compile(export_all).
start() ->
	register(ser,spawn(newserver,server,[[]])).

%%  服务端连接
server(UserList) ->
	receive
		{login,From,Name}  ->
			login(From,Name,UserList),
			server(UserList);
		{logout,From} ->
			logout(From,UserList),
			server(UserList);
		{transfer,From,To,Mesg} ->
			transfer(From,To,Mesg,UserList),
			server(UserList)
	end.
%%------------------------------------------------------------
%%  login  服务器将新用户添加到用户列表
login(From,Name,UserList)->
	case lists:keymember(Name,2,UserList) of
		true  ->
			From!{ser,exit},
			UserList;
		false ->
			From!{ser,login},
			[{From,Name} | UserList]
	end.
%%--------------------------------------------------------
%%  logout
logout(From,UserList) ->
	lists:keydelete(From,1,UserList),
	UserList.

%%------------------------------------------------------

%% transfer   % 检查用户是否登录以及是谁
transfer(From,To,Mesg,UserList) ->
	case lists:keysearch(From,1,UserList) of
		  false->
			From! {stop,ser,Mesg};
		{value,{From,FromName}} ->
			transfer(From,FromName,To,Mesg,UserList)
	end.
%   检查传送对象,然后进行数据传输
transfer(From,FromName,To,Mesg,UserList)->
	case lists:keysearch(To,2,UserList) of
		false->
			From!{ser,client_not_exist};
		{value,{ToPid,To}}->
			ToPid!{msgfrom,FromName,Mesg},
			From!{ser,send_ok}
	end.














