%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%
%%% @end
%%% Created : 23. 三月 2018 16:13
%%%-------------------------------------------------------------------
-module(test).
-author("Eric").

-include_lib("stdlib/include/qlc.hrl").
-compile(export_all).
-record(row_mne,{id = 0,c1 = 0, c2 = 0, c3 = 0}).


start() ->
	mnesia:create_schema([node()]),
	mnesia:start(),
	mnesia:delete_table(row_mne),
%%	mnesia:create_table(row_mne, [{attributes, record_info(fields, row_mne)}]),
	mnesia:create_table(row_mne,[{ram_copies,[node()]},{attributes,record_info(fields, row_mne)}]),
	mnesia:wait_for_tables([row_mne], 20000).


% 测试函数t/1
% N：测试N次读取/写入
t(N) ->
	Test = #row_mne{id = 1,c1 = 1, c2 = 1, c3 = 0},
	F1 = fun(_I) ->
			mnesia:dirty_write(Test)
		 end,

	ptester:run(N,
		[
			{"mnesia(dirty) write", F1}
		]
	).

