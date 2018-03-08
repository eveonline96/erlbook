%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
% (1).配置文件可以很方便地用 JSON 数据表示。
% 请编写一些函数来读取包含 JSON 数据的配置文件，
% 并将它们转换成 Erlang 的映射组。
% 再编写一些代码，对配置文件里的数据进行合理性检查。
%%%参考:http://blog.csdn.net/wwh578867817/article/details/49808395
%%2> S="{\"name\":\"Tom\",\"sex\":\"man\"}".
%%"{\"name\":\"Tom\",\"sex\":\"man\"}"
%%3> R=rfc4627:decode(S).
%%{ok,{obj,[{"name",<<"Tom">>},{"sex",<<"man">>}]},[]}
%%4> parsefile:parse_file("D:\code\erlang\erlbook\src\test5\file.json").
%%parse_file error:eio
%%8> parsefile:parse_file("file.json").
%%parse_file/3 error:unexpected_end_of_input
%%ok
%%在windows下打开werl交互器正常运行
%%> parsefile:parse_file("file.json").
%%#{"cpu" => <<"8">>,"disk" => <<"1T">>,"memory" => <<"8G">>}

%%% @end
%%% Created : 08. 三月 2018 14:49
%%%-------------------------------------------------------------------
-module(parsefile).
-export([parse_file/1]).
-import(rfc4627, [decode/1, encode/1]).

parse_file(File) ->
	case file:open(File, read) of
		{ok, FileFd} -> parse_file(FileFd, io:get_line(FileFd, "Read a line"), #{});
		{error, Reason} -> io:format("parse_file error:~p~n", [Reason])
	end.
% 非文件结尾
parse_file(FileFd, Line, X) when Line =/= eof ->
	case rfc4627:decode(Line) of
%%		问题:X#{}??????
%%		首次定义某个键使用Key=value,更新那个键使用Key:=Value

		{ok, {obj, [{Key, Value}]}, []} -> parse_file(FileFd, io:get_line(FileFd, "Read a line"), X#{Key => Value});
		{error, Reason} -> io:format("parse_file/3 error:~p~n", [Reason])
	end;
% 读到文件结尾
parse_file(FileFd, Line, X) when Line =:= eof ->
	file:close(FileFd),
	X.