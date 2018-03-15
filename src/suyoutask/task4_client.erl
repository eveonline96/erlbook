%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%% 客户端
%%% @end
%%% Created : 14. 三月 2018 17:53
%%%-------------------------------------------------------------------
-module(task4_client).
-author("Eric").

%% API
-compile(export_all).



start() ->
	start("localhost",999).

start(IP, Port) ->
	register(client,spawn(fun() -> connectS(IP,Port) end)).

connectS(IP, Port) when is_port(Port) ->
	case gen_tcp:connect(IP, Port, [binary, {packet, 0}]) of
		{ok, Socket} ->
			talk(Socket);
		{error,Why}->
			outInfo(c2,Why),
			exit(error)
	end.

talk(Socket) ->
	receive
		{tcp,Socket,Pack} ->
			io:format(" ~p~n", [binary_to_term(Pack)]),
			talk(Socket);
		{tcp_closed,Socket} ->
			gen_tcp:close(Socket),
			outInfo(?MODULE," Socket die");
	% gen_tcp:close(Socket)
		{opt,Pack} ->
			% outInfo(c2,?LINE),
			gen_tcp:send(Socket, term_to_binary(Pack)),
			talk(Socket)
	end.

%% 注册操作   登入   登出   一对一聊天   一对多聊天  查询在线玩家
regis(Name,Pwd) ->
	% if is_null(Name) -> %% 这里调用方法，无法确定方法所调用的返回值
	case is_null(Name) of
		true ->
			client ! {opt ,{register,{Name,Pwd}}};
		false ->
			{false,name_is_null}
	end.
login(Name,Pwd) ->
	client !{opt ,{login,{Name,Pwd}}}.
out(Name) ->
	client !{opt ,{out,{Name}}}.
mms(Name,Msg) ->
	client !{opt ,{mms,{Name,Msg}}}.
mmall(Msg) ->
	client !{opt ,{mmall,{Msg}}}.
onli() ->
	client !{opt ,{onli}}.

%% 验证字符串是否为空
is_null(X)
	when is_list(X) ->
	% outInfo(X,X),
	Len=length(string:strip(X)),
	if Len>=1 ->
		true;
		true -> false
	end.

%% 输出错误行
outInfo(ClassName,Line) ->
	io:format("__~p______line: ~p~n",[ClassName,Line]).


%%start(Name) ->
%%	register(client, spawn(fun() -> login(Name) end)),
%%	register(client1, spawn(fun() -> login1(Name) end)).
%%
%%login(Name) ->
%%	server ! {self(), {name,Name}},
%%	io:format("client send name ok~n"),
%%%%	server ! {self(), Q},
%%	receive
%%		{server, Reply} ->
%%			io:format("reply: ~p~n",[Reply])
%%	end.
%%
%%
%%login1(Name) ->
%%	server ! {self(), {name,Name}},
%%	io:format("client send name ok~n"),
%%%%	server ! {self(), Q},
%%	receive
%%		{server, Reply} ->
%%			io:format("reply: ~p~n",[Reply])
%%	end.
%%
%%
%%chat(Message) ->
%%%%	Message=io:read(Other),
%%	Other!{self(),{message,Other,Message}},
%%	chat(Other) .





%%logout(Name) ->
%%	io:format("server pid: ~p",[server]),
%%	server ! {self(), {logout, "client logout"}},
%%	unregister(Name),
%%	exit(normal) .
%%%%	.
%%
%%chat(Other) ->
%%	Message=io:read(Other),
%%	Other!{self(),{message,Other,Message}},
%%	chat(Other) .
%%
%%message_send(Pid) ->
%%	Pid !{self(),{message,"message send ok"}}.
%%
%%
%%











