%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%3).dets测试:
%%a.测试百万条数据的写入性能，字段设置参见记录row;
%%b.测试dets:lookup方式的百万次读取;
%%c.测试dets:match方式的百万次读取;
%%d.测试dets:select方式的百万次读取;
%%% @end
%%% Created : 22. 三月 2018 8:42
%%%-------------------------------------------------------------------
-module(dets_test).
-author("Eric").

%% API
-compile(export_all).
-record(row,{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).

start() ->
	open("./test.dets").
open(File) ->
	io:format("dets opened:~p~n", [File]),
	Bool = filelib:is_file(File),
	case dets:open_file(?MODULE, [{file, File}]) of
		{ok, ?MODULE} ->
			case Bool of
				true  -> void;
				false -> ok = dets:insert(?MODULE, {free,1})
			end,
			true;
		{error,Reason} ->
			io:format("cannot open dets table~n"),
			exit({eDetsOpen, File, Reason})
	end.
%%close(Name) -> ok | {error, Reason}
%%Name = tab_name()
%%Reason = term()
close() -> dets:close(?MODULE).

% 测试函数t/1
% N：测试N次读取/写入
%%insert(Name, Objects) -> ok | {error, Reason}
%%Name = tab_name()
%%Objects = object() | [object()]
%%Reason = term()
t(N) ->
	F1 = fun(_I)->
		  dets:insert(?MODULE, #row{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0})
		 end,

%%lookup(Name, Key) -> Objects | {error, Reason}
%%Name = tab_name()
%%Key = term()
%%Objects = [object()]
%%Reason = term()
	F2 = fun(_I)->
		Id = ptester:rand(1, N),
		Str= integer_to_list(Id),
		dets:lookup(?MODULE,Str)
		 end,

%%match(Name, Pattern) -> [Match] | {error, Reason}
%%Name = tab_name()
%%Pattern = pattern()
%%Match = [term()]
%%Reason = term()
	F3 = fun(_I) ->
%%		 dets:match(?MODULE,'$1')
		 dets:match(?MODULE,'$1')
		 end,

%%select(Name, MatchSpec) -> Selection | {error, Reason}
%%Name = tab_name()
%%MatchSpec = match_spec()
%%Selection = [term()]
%%Reason = term()
	F4 = fun(_I) ->
%%		 dets:select(?MODULE,{'$1','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_','_'})
		dets:select(?MODULE,[{{'$1','$2','$3'},[],['$$']}])
		 end,

	ptester:run(N,
		[
			{"dets insert", F1}
			,{"dets lookup",F2}
			,{"dets match",F3}
			,{"dets select",F4}
		]
	).


test() ->
	value(1,100,[]).

value(Max, Max, F) -> F;
value(I, Max, F)   ->
	value(I + 1, Max, [I|F]).
















