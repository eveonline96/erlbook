%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%2).mnesia测试:
%%a.建立一个普通表，字段设置参见记录row，分别用mnesia的dirty和transaction方式测试百万次读和写;
%%b.建立一个内存表，字段设置参见记录row, 分别用mnesia的dirty和transaction方式测试百万次读和写;
%%% @end
%%% Created : 21. 三月 2018 17:21
%%%-------------------------------------------------------------------
-module(mnesia_test).
-author("Eric").

-include_lib("stdlib/include/qlc.hrl").
-compile(export_all).
-record(row,{id = 0,c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).



start() ->
	mnesia:start(),
	mnesia:delete_table(row),
	mnesia:create_table(row, [{attributes, record_info(fields, row)}]),
%%	mnesia:create_table(row,[{ram_copies,[node()]},{attributes,record_info(fields, row)}]),
	mnesia:wait_for_tables([row], 20000).


% 测试函数t/1
% N：测试N次读取/写入
t(N) ->
	%测试dirty类型表的写入时间
	%	dirty_write(Record) -> ok | exit({aborted, Reason})
	Id_Row = ptester:rand(1, N),
	Test = #row{id = Id_Row,c1 = 0, c2 = 1, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0},
	F1 = fun(_I) ->
			mnesia:dirty_write(Test)
		 end,

	%测试transaction类型表的写入时间
	%%	write(Record) -> transaction abort | ok
	%%	write(Tab, Record, LockKind) -> transaction abort | ok
	F2 = fun(_K)->
			K=fun(_I) ->
				Id_Row = ptester:rand(1, N),
				Test = #row{id = Id_Row,c1 = 0, c2 = 1, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19= 0, c20= 0},
				mnesia:write(Test)
			 end,
		 mnesia:transaction(K)
		end,

	%测试dirty类型表的读取时间
	%%dirty_read({Tab, Key}) -> ValueList | exit({aborted, Reason}
	%测试transaction类型表的读取时间
	F3 = fun(_I)->
			Id = ptester:rand(1, N),
			mnesia:dirty_read({row,Id})
		 end,
	%测试transation类型表的读取时间
	F4 = fun(_K)->
			K=fun(_I) ->
				Id = ptester:rand(1,N),
				mnesia:read(row,Id)
			  end,
			mnesia:transaction(K)
	     end,
%%	F4 = fun(_K)->
%%			fun(_I)->
%%				Id = ptester:rand(1, N),
%%				Str= integer_to_list(Id),
%%				qlc:q([X || X <- mnesia:table(row),X#row.c1 =:= Str])
%%			 end,
%%			mnesia:transaction(F4)
%%		end,

	MatchHead = #row{c1='$1', c2='$2',_='_'},
	Guard = {'>', '$2', 30},
	Result = '$1',
	F5 =fun(_K)->
		K=fun(_I) ->
			mnesia:select(tab,[{MatchHead, [Guard], [Result]}])
		  end,
		mnesia:transaction(K)
		end,

%%%%	match_object（模式） - >事务中止| RecList
	F6 =fun(_K)->
			K=fun(_I) ->
				mnesia:match_object({'$1','_','_' })
			end,
			mnesia:transaction(K)
		end,

	ptester:run(N,
		[
			{"mnesia(dirty) write",        F1}
			,{"mnesia(transaction) write", F2}
			,{"mnesia(dirty) read",        F3}
			,{"mnesia(transaction) read",  F4}
%%			,{"mnesia select",  F5}
%%			,{"mnesia match",  F6}
		]).









