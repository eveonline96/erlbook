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

-record(user, {name,socket,online,pwd,text}).
-define(TCP_OPTIONS, [binary, {packet, 0}, {active, true}, {reuseaddr, true}]).
-define (tabInfo, tabinfo).
-define (clInfo, clinfoSpawn).
-define (seInfo, serverInfo).

str() ->
	str(999).

str(Port) ->
	register(?seInfo,spawn_link(fun() -> connect(Port) end)),
	register(?clInfo,spawn_link(fun() -> tabLoop() end)).

%% 端口监听 连接
connect(Port) ->
	{ok,LSocket} = gen_tcp:listen(Port,?TCP_OPTIONS),
	accept_s(LSocket).

%% 并行服务器，使每个客户端都有自己的socket，防止进程被占用无法操作请求
accept_s(LSocket) ->
	process_flag(trap_exit,true),
	case gen_tcp:accept(LSocket) of
		{ok,Socket} ->
			spawn_link(fun() -> accept_s(LSocket) end),
			loop(Socket);
		{error,_Why} ->
			exit(accept_s)
	end.

loop(Socket) ->
	receive
		{tcp,Socket,Bin} ->
			Opt =binary_to_term(Bin),
			?clInfo ! {opt,Socket,Opt},
			loop(Socket);
		{tcp_closed,Socket} ->
			case select('$0',Socket,true) of
				[] ->
					noop ;
				Obj ->
					Prop = {out,{sel_f(Obj)}},
					?clInfo ! {opt,Socket,Prop}
				% outInfo(Socket,?LINE),
				% out(Socket,sel_f(Obj))    %% 设置ets为public时才能操作
			end,
			outInfo(?MODULE,tcp_closed),
			loop(Socket)
	end.

%% 初始化记录
tabLoop() ->
	% ets:new(?tabInfo,[{keypos,#user.name},named_table,ordered_set,public]), %% 有调用的进程都可操作
	ets:new(?tabInfo,[{keypos,#user.name},named_table,ordered_set]), %% 只能在当前进程操作
	clientLoop().

%% 处理客户端的操作
clientLoop() ->
	receive
		{opt,Socket,Pack} ->
			case Pack of
				{register,{Name,Pwd}} ->
					gen_tcp:send(Socket,term_to_binary(regis(Name,Pwd)));
				{login,{Name,Pwd}}  ->
					gen_tcp:send(Socket,term_to_binary(login(Name,Pwd,Socket)));
				{out,{Name}}  ->
					Info = out(Socket,Name),
					gen_tcp:send(Socket,term_to_binary(Info)),
					case Info of %% 只有自己退出成功,才关闭socket
						{true,_Prop} ->
							gen_tcp:close(Socket);
						{false,_Prop} -> noop
					end;
				{mms,{Name,Msg}} ->
					mmss(Socket,Name,Msg);
				{mmall,{Msg}} ->
					mmall(Socket,Msg);
				{onli} ->
					gen_tcp:send(Socket,term_to_binary(onli()))
			end,
			clientLoop()
	end.

%% 注册
regis(Name,Pwd) when is_list(Name) ->
	Names = string:strip(Name),
	case ets:lookup(?tabInfo,Names) of
		[_] ->
			{false,"already register name"};%% 已经注册的名字
		[] ->
			outInfo("regis :"++Name,Pwd),
			ets:insert(?tabInfo,#user{name=Names,pwd=Pwd,online=false,socket=""}),
			{true,"register succeed"}
	end.

%% 登入  一个socket只能登入一号
login(Name,Pwd,Socket) ->
	case ets:lookup(?tabInfo,Name) of
		[User] ->
			if(Pwd == User#user.pwd andalso User#user.online == false) ->
				case select('$0',Socket,true) of
					[] ->
						outInfo("login :"++Name,Socket),
						ets:update_element(?tabInfo, Name, [{#user.online, true},{#user.socket, Socket}]),
						{true,"login succeed"};
					_Obj ->
						{false,"have a Socket login"}
				end;
				(Pwd =/= User#user.pwd) -> {false,"name / pwd  error"};
				(User#user.online) -> {false,"name already online"}
			end;
		[] -> {false," name null "}
	end.

%% 登出
out(Socket,Name) ->
	case ets:lookup(?tabInfo,Name) of
		[User] ->
			if (User#user.online andalso Socket==User#user.socket) ->
				outInfo("out :"++Name,Socket),
				ets:update_element(?tabInfo, Name, [{#user.online, false},{#user.socket, 0}]),
				{true," out succeed"};
				(User#user.online==false) -> {false,"name out error"};
				(User#user.socket=/=Socket) -> {false,"name out error not own socket"}
			end;
		[] ->
			{false," name null "}
	end.

%% 两个聊天
mmss(Socket,Name,Msg) ->
	% outInfo(?MODULE,?LINE),
	case ets:lookup(?tabInfo,Name) of
		[User] ->
			if(User#user.online) ->
				case select('$0',Socket,true) of
					[] ->
						noop ;
					Obj ->
						outInfo(sel_f(Obj) ++ " to "++Name,Msg),
						Msgs = sel_f(Obj) ++ " to My : " ++ Msg,
						MsgMy = " My to " ++ Name ++ " : " ++ Msg,
						gen_tcp:send(Socket,term_to_binary(MsgMy)),
						gen_tcp:send(User#user.socket,term_to_binary(Msgs))
				end;
				(User#user.online==false) ->
					gen_tcp:send(Socket,term_to_binary({false," call fail"}))
			end;
		[] ->
			gen_tcp:send(Socket,term_to_binary({false,"name error ,call fail"}))
	end.

%% 全体聊天
mmall(Socket,Msg) ->
	% outInfo(?MODULE,?LINE),
	case select('$0',Socket,true) of
		[] ->
			noop_My ;
		Obj ->
			Msgs = sel_f(Obj) ++ " to : " ++ Msg,
			outInfo(sel_f(Obj) ++ " to ",Msg),
			case select('_','$1',true) of
				[] ->
					noop_all ;
				Sockets ->
					send_all_msg(Sockets,Msgs)
				% gen_tcp:send(User#user.socket,term_to_binary(Msgs));
			end
	end.

%% 查询在线玩家
onli() ->
	% outInfo(?MODULE,?LINE),
	case select('$0','_',true) of
		[] ->
			{false, onli_null} ;
		Obj ->
			Obj
	end.

%% 广播所有人
send_all_msg(Sockets, Msg) ->
	SendData = fun(Socket) ->
		gen_tcp:send(Socket, term_to_binary(Msg))
			   end,
	[SendData(X)||[X] <- Sockets].

%%  查询当前Name,Socket的Online的所有记录
select(Name,Socket,Online) ->
	% [User] = ets:tab2list(?tabInfo),
	ets:match(?tabInfo,{'_',Name,Socket,Online,'_','_'}).

%% 获得一个玩家
sel_f([]) -> [];
sel_f([[X]|_]) -> X.

%% 输出错误行
outInfo(ClassName,Line) ->
	io:format("__~p______line: ~p~n",[ClassName,Line]).






%%start() -> register(server, spawn(fun() -> loop() end)).
%%
%%store(Key, Value) -> rpc({store, Key, Value}). %%<label id="server.store1"/>
%%
%%lookup(Key) -> rpc({lookup, Key}). %%<label id="server.lookup1"/>
%%
%%rpc(Q) ->
%%	server ! {self(), Q},
%%	receive
%%		{server, Reply} ->
%%			io:format("reply: ~p~n",[Reply])
%%	end.
%%
%%loop() ->  %%<label id="server.loop"/>
%%	receive
%%		{From, {store, Key, Value}} ->  %%<label id="server.store2"/>
%%			put(Key, {ok, Value}),
%%			From ! {server, true},
%%			loop();
%%		{From, {lookup, Key}} -> %%<label id="server.lookup2"/>
%%			From ! {server, get(Key)},
%%			loop();
%%
%%		{From, {name, Name}} ->
%%			case get(Name) of
%%			undefined ->
%%%%				io:format("Server:this Name is accept"),
%%				From!{server,"Server:this Name is accept~n"} ,
%%				store(Name,1),
%%				loop();
%%			true ->
%%%%				io:format("Server:this Name is Exist"),
%%				From ! {self(),"exist"},
%%				loop()
%%			end;
%%		{From,{client1,Message}} ->
%%			client1!{server,{message,Message}}
%%	end.
%%
%%
%%chat() ->
%%	io:format("chat start~n"),
%%	receive
%%		}
%%	end,
%%	chat().




%%start()   ->
%%%%	register(server,self()) ,
%%%%	io:format("regesiter ok ~n"),
%%	spawn(task4_server,login_loop,[]),
%%	spawn(task4_server,logout,[]),
%%	spawn(task4_server,chat,[]),
%%	spawn(task4_server,message_recv,[])
%%		 .
%%
%%login_loop() ->
%%	io:format("login start~n"),
%%	receive
%%		{_From, {name, Name}} ->
%%			Name
%%
%%
%%
%%%%		{From, {name, Name}} ->
%%%%			case whereis(Name) of
%%%%			undefined ->
%%%%				io:format("Server:this Name is accept"),
%%%%				From!{self(),["Server:this Name is accept" ]} ,
%%%%				register(Name,From);
%%%%			_Pid ->
%%%%				io:format("Server:this Name is Exist"),
%%%%				From ! {self(),["Server: this name  is Exist "]}
%%%%			end
%%	end,
%%	login_loop().
%%
%%
%%
%%logout() ->
%%	io:format("logout start~n"),
%%	receive
%%		{_From, {logout,Response}} ->
%%			io:format("server:~p~n",[Response])
%%
%%	end,
%%	logout().
%%
%%
%%message_recv() ->
%%	receive
%%		{_From,{message,Message}} ->
%%			Message
%%
%%	end.
%%
%%
%%chat() ->
%%	io:format("chat start~n"),
%%	receive
%%		{From,{message,Other,Message}} ->
%%			Other!{self(),{message,From,Message}}
%%	end,
%%	chat().

%%
%%broadcast() _>
%%	.











