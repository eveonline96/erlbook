%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%% (1).file:read_file(File) 会返回 {ok, Bin} 或者 {error, Why}，
%%% 其中 File 是文件名， Bin 则包含了文件的内容。请编写一个myfile:read(File) 函数
%%% ，当文件可读取时返回 Bin，否则抛出一个异常。
%%%异常都没有被我写的catch 捕获，而是被系统捕获了


%%% @end
%%% Created : 08. 三月 2018 17:16
%%%-------------------------------------------------------------------
-module(myfile).
-author("${Eric}").

%% API
-export([read/1]).

read(File) ->
	try file:read_file(File) of
		{ok, Bin}-> Bin;
		{error, Why} -> throw(Why)
	catch
		error:X ->io:format("error is ~p",[X]);
		throw:X ->io:format("throw is ~p",[X]);
		exit:X ->io:format("exit is ~p",[X])
	end

	.
