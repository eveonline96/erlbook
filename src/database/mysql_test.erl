-module(mysql_test).
-compile(export_all).

-record(row,{c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, c6 = 0, c7 = 0, c8 = 0, c9 = 0, c10 = 0, c11 = 0, c12 = 0, c13 = 0, c14 = 0, c15 = 0, c16 = 0, c17 = 0, c18 = 0, c19 = 0, c20 = 0}).

-define(DB_HOST, "localhost").
-define(DB_PORT, 3306).
-define(DB_USER, "root").
-define(DB_PASS, "1234").
-define(DB_NAME, "test").

% 初始化mysql数据库
init() ->
    mysql:start_link(p1, ?DB_HOST, ?DB_PORT, ?DB_USER, ?DB_PASS, ?DB_NAME,fun(_, _, _, _) -> ok end),
    mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
    mysql:connect(p1, ?DB_HOST, undefined, ?DB_USER, ?DB_PASS, ?DB_NAME, true),
    mysql:fetch(p1, <<"drop table if exists mysql_memory">>),
	mysql:fetch(p1, <<"drop table if exists mysql_innoDB">>),
    mysql:fetch(p1, <<"create table mysql_memory (id int not null auto_increment,
	                                               c1 int not null,
												   c2 int not null,
												   c3 int not null,
												   c4 int not null,
												   c5 int not null,
												   c6 int not null,
												   c7 int not null,
												   c8 int not null,
												   c9 int not null,
												   c10 int not null,
												   c11 int not null,
												   c12 int not null,
												   c13 int not null,
												   c14 int not null,
												   c15 int not null,
												   c16 int not null,
												   c17 int not null,
												   c18 int not null,
												   c19 int not null,
												   c20 int not null,
												   primary key (id)) engine = memory">>),
	mysql:fetch(p1, <<"create table mysql_innoDB (id int not null auto_increment,
	                                               c1 int not null,
												   c2 int not null,
												   c3 int not null,
												   c4 int not null,
												   c5 int not null,
												   c6 int not null,
												   c7 int not null,
												   c8 int not null,
												   c9 int not null,
												   c10 int not null,
												   c11 int not null,
												   c12 int not null,
												   c13 int not null,
												   c14 int not null,
												   c15 int not null,
												   c16 int not null,
												   c17 int not null,
												   c18 int not null,
												   c19 int not null,
												   c20 int not null,
												   primary key (id)) engine = innodb">>).

% 测试函数t/1
% N：测试N次读取/写入
t(N) ->
    %测试memory类型表的写入时间
    F1 = fun(_I) ->
            mysql:fetch(p1, <<"insert into mysql_memory(c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20) values(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)">>)
    end,
	%测试innodb类型表的写入时间
	F2 = fun(_I) ->
            mysql:fetch(p1, <<"insert into mysql_innoDB (c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20) values(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20)">>)
    end,
	%测试memory类型表的读取时间
	F3 = fun(_I)->
	        Id = ptester:rand(1, N),
			Str= integer_to_list(Id),
			mysql:fetch(p1, list_to_binary("select * from  mysql_memory where id = " ++ Str))
	end,
	%测试innodb类型表的读取时间
	F4 = fun(_I)->
	        Id = ptester:rand(1, N),
			Str= integer_to_list(Id),
			mysql:fetch(p1, list_to_binary("select * from  mysql_innoDB where id = " ++ Str))
	end,
    ptester:run(N,
		[
            {"mysql(memory) write", F1}
            ,{"mysql(innodb) write", F2}
			,{"mysql(memory) read",F3}
			,{"mysql(innoDB) read",F4}
        ]
    ).







