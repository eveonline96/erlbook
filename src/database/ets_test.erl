%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%
%%% @end
%%% Created : 20. 三月 2018 16:33
%%%-------------------------------------------------------------------
-module(ets_test).
-author("Eric").
%%4).ets测试:
%%a.测试百万条数据的写入性能，字段设置参见记录row;
%%b.测试ets:lookup方式的百万次读取;
%%c.测试ets:match方式的百万次读取;
%%d.测试ets:select方式的百万次读取;
%% API

%%
%%test_ets(Mode) ->
%%	TableId =ets:new(test,[Mode]),
%%	ets:insert(TableId,{a,1}),
%%	ets:insert(TableId,{b,1}),d
%%	ets:insert(TableId,{a,1}),
%%	ets:insert(TableId,{a,3}),
%%	List =ets:tab2list(TableId),
%%	io:format("~-13w => ~p~n",[Mode,List]),
%%	ets:delete(TableId).

-compile(export_all).
%%-record(row,{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).

start() ->
	ets:new(?MODULE,[set,ordered_set,bag,duplicate_bag]).

% 测试函数t/1
% N：测试N次读取/写入
t(N) ->
%%insert(Tab, ObjectOrObjects) -> true
%%Tab = tab()
%%ObjectOrObjects = tuple() | [tuple()]
	F1 = fun(_I)->
%%		ets:insert(?MODULE, #row{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0})
		ets:insert(start(),
			[   {c1 ,0},
				{c2 , 0},
				{c3 , 0},
				{c4 , 0},
				{c5 , 0},
				{c6 , 0},
				{c7 , 0},
				{c8 , 0},
				{c9 , 0},
				{c10 , 0},
				{c11 , 0},
				{c12 , 0},
				{c13 , 0},
				{c14 , 0},
				{c15 , 0},
				{c16 , 0},
				{c17 , 0},
				{c18 , 0},
				{c19 , 0},
				{c20 , 0}])
		  end,
%%lookup(Tab, Key) -> [Object]
%%	Tab = tab()
%%Key = term()
%%Object = tuple()
	F2 = fun(_I)->
%%		Id = ptester:rand(1, N),
%%		Str= integer_to_list(Id),
		ets:lookup(start(),c1)
		 end,
	F3 = fun(_I)->
%%		Id = ptester:rand(1, N),
%%		Str= integer_to_list(Id),
		ets:match(start(),[{'$1','_'},'_'])
		 end,

%%select(Tab, MatchSpec) -> [Match]
%%	Tab = tab()
%%MatchSpec = match_spec()
%%Match = term()
	F4 = fun(_I) ->
%%		ets:select(?MODULE,['$$'])
%%		ets:select(?MODULE,[{{'$1','$2'},[],['$$']}])
		ets:select(?MODULE,'$$')
		 end,

	ptester:run(N,
		[
			{"ets insert", F1}
			,{"ets lookup",F2}
			,{"ets match",F3}
			,{"ets select",F4}
		]
	).





















