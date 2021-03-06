%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%5).进程字典测试: 使用进程字典存储数据，测试百万次读和写，字段设置参见记录row;
%%a.测试百万条数据的写入(put)性能，字段设置参见记录row;
%%b.测试get方式的百万次读取;
%%% @end
%%% Created : 21. 三月 2018 10:23
%%%-------------------------------------------------------------------
-module(dictionary_test).
-author("Eric").

%% API
-compile(export_all).
%%-import(ptester,[run/2]).


-record(row,{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).


value(Max, Max, F) -> F;
value(I, Max, F)   ->
	value(I + 1, Max, [I|F]).
% 测试函数t/1
% N：测试N次读取/写入
t(N) ->
	%测试进程字典的写入时间
%%	put(Key, Val) -> term()
%%  Key = Val = term()
	F1 = fun(_I) ->
	Value=value(1,100000,[]),
	put(row,Value)

%%	(1)
%%			put(row,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20})
%%	(2)
%%			put({c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20},{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20})

%%	(3)
%%			put(c1,1),
%%			put(c2,1),
%%			put(c3,1),
%%			put(c3,1),
%%			put(c4,1),
%%			put(c5,1),
%%			put(c6,1),
%%			put(c7,1),
%%			put(c8,1),
%%			put(c9,1),
%%			put(c10,1),
%%			put(c11,1),
%%			put(c12,1),
%%			put(c13,1),
%%			put(c14,1),
%%			put(c15,1),
%%			put(c16,1),
%%			put(c17,1),
%%			put(c18,1),
%%			put(c19,1),
%%			put(c20,1)

		 end,

	%测试进程字典的读取时间
	F2 = fun(_I)->
			get()
		 end,

	ptester:run(N,
		[
			{"dictionary put", F1}
			,{"dictionary get",F2}
		]
	).





















