%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%  6).dict测试：使用进程字典存储数据，测试百万次读和写，字段设置参见记录row;
%%a.测试百万条数据的写入(dict:store)性能，字段设置参见记录row;
%%b.测试dict:find方式的十万次读取;
%%% @end
%%% Created : 21. 三月 2018 15:34
%%%-------------------------------------------------------------------
-module(dict_test).
-author("Eric").

%% API
-compile(export_all).
-record(row,{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).

%%开始
start()->
	dict:new().

% 测试函数t/1
	% N：测试N次读取/写入
t(N) ->
	F1 = fun(_I)->
%%			dict:store(c1,1,start())
%%		   怎么存储新的Newdict=dict:store(XX,XX,Olddict)  ,然后可以调用
		 	 dict:store(row,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20},start())
		 end,

	%测试进程字典的读取时间
	F2 = fun(_I)->
			dict:fetch_keys(start())
		 end,

ptester:run(N,
		[
			{"dict store", F1}
			,{"dict fetch",F2}
		]
).















