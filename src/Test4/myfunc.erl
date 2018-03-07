%%%-------------------------------------------------------------------
%%% @author wh
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%% 
%%% (3).查看 erlang:now/0、erlang:date/0 和 erlang:time/0 的定义。
%%erlang:now/0 now（） - >时间戳
%%Timestamp = timestamp()
%%timestamp() =
%%{MegaSecs :: integer() >= 0,
%%Secs :: integer() >= 0,
%%MicroSecs :: integer() >= 0}  返回{MegaSecs, Secs, MicroSecs}

%%erlang:date/0 date（） - > Date
%%Date = calendar:date()
%%返回当前日期{Year, Month, Day}。
%%时区和夏令时更正取决于底层操作系统。
%%例：
%%>  { 1995 ，2 ，19 }date().

%%erlang:time/0 时间（） - >时间
%%Time = calendar:time()
%%返回当前时间{Hour, Minute, Second}。
%%时区和夏令时更正取决于底层操作系统。
%%例：
%%>  { 9 ，42 ，44 }time().

% 编写一个名为 my_time_func(F) 的函数，让它执行 fun F 并记下执行时间。
% 编写一个名为 my_date_string() 的函数，用它把当前的日期和时间改成整齐的格式
%%% @end
%%% Created : 26. 二月 2018 21:07
%%%-------------------------------------------------------------------
-module(myfunc).
-author("wh").

%% API
-export([my_time_func/1,my_date_string/0]).

%%控制序列的一般格式是~F.P.PadModC。该字符C确定要使用的控制序列的类型，F并且P是可选的数字参数。如果F，P或者Pad是*，下一个参数Data被用作For 的数值P。
%%F是field width打印的参数。负值表示该参数将在该字段内左对齐，否则将被右对齐。如果未指定字段宽度，将使用所需的打印宽度。如果指定的字段宽度太小，则整个字段将填充*字符。
%%
%%P是precision打印的参数。如果未指定精度，则使用默认值。精度的解释取决于控制顺序。除非另有说明，否则参数within用于确定打印宽度。
%%
%%Pad是填充字符。这是用于填充参数的打印表示的字符，以便它符合指定的字段宽度和精度。只能指定一个填充字符，并且在适用的情况下，它将用于字段宽度和精度。默认的填充字符是' '（空格）。
%%
%%Mod是控制序列修改器。它可以是单个字符（目前仅t支持Unicode转换，l支持停止p和 P检测可打印字符），这会改变Data的解释。
%%以下控制序列可用：
%%~
%%该角色~被写入。
%%c
%%该参数是一个将被解释为ASCII码的数字。精度是字符打印的次数，默认为字段宽度，字段宽度默认为1.以下示例说明：
%%1 >  |      aaaaa | bbbbb      | ccccc |
%%好io:fwrite("|~10.5c|~-10.5c|~5c|~n", [$a, $b, $c]).
%%如果Unicode转换修饰符（t）有效，那么integer参数可以是表示有效Unicode码位的任何数字，否则它应该是小于或等于255的整数，否则使用16＃FF屏蔽：
%%2 >  \ x { 400 }io:fwrite("~tc~n",[1024]).
%%3 >
%%^ @
%%okio:fwrite("~c~n",[1024]).
%%f
%%参数是一个浮点数，写为： [-]ddd.ddd精度是小数点后的位数。默认精度为6，不能小于1。
%%e
%%参数是一个写成float的浮点数 [-]d.ddde+-ddd，其中精度是写入的位数。默认精度为6，不能小于2。
%%g
%%参数是一个浮点数f，如果它大于或等于0.1且小于10000.0 ，则写为float 。否则，它以e格式写入。精度是有效位数。它的默认值为6，不应该小于2.如果float的绝对值不允许以f具有所需有效数字的e格式写入，则它也会以格式写入。
%%s
%%用字符串语法打印参数。参数是，如果没有Unicode转换修饰符存在，an iolist()，a binary()或an atom()。如果Unicode转换修饰符（t）是有效的，则参数是unicode:chardata()，意味着二进制文件是UTF-8。字符打印时不带引号。该字符串首先被给定的精度截断，然后填充并对齐给定的字段宽度。默认精度是字段宽度。

my_time_func(F) ->
	{Hour1, Minute1, Second1}=erlang:time(),
	F,
	{Hour2, Minute2, Second2}=erlang:time(),
	io:format("function runtime:~f s ~n",(Hour2-Hour1)*3600+(Minute2-Minute1)*60+(Second2-Second1))
		.

my_date_string() ->
	{Year, Month, Day}=erlang:date(),
	{Hour, Minute, Second}=erlang:time(),
	io:format("~pyear ~pmonth ~pday ~phour ~pmin ~psec",[Year, Month, Day,Hour, Minute, Second])
	.