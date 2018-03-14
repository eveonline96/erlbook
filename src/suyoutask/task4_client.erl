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


%%start()  ->.

login(Pid, Name) ->
	Pid ! {self(), {name,Name}},
	case whereis(Name) of
		undefined ->
			io:format("this Name is accept  ~n"),
			register(server,Pid);
		_Pid ->
			io:format("this name  is Exist ~n")
	end,
	receive
	{Pid, Response} ->
		Response
	end.

logout() ->
	server ! {self(), {logout,"client logout"}},
	exit(normal) .














