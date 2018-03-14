%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%% (1).编写一个start(AnAtom, Fun)函数来把spawn(Fun)注册为AnAtom。
% 确保当两个并行的进程同时执行start/2时你的程序也能正确工作。
% 在这种情况下，必须保证其中一个进程会成功执行而另一个会失败。

%%whereis（RegName） - > pid（）| port（）| 未定义
%%RegName = atom()
%%用注册名称返回进程标识符或端口标识符RegName。undefined 如果名称未注册，则返回。


%%register（RegName，PidOrPort） - > true
%%RegName = atom()
%%PidOrPort = port() | pid()
%%将该名称RegName与进程标识符（pid）或端口标识符关联。
%%RegName，它必须是一个原子，可以用来代替发送操作符（RegName ! Message）中的pid或端口标识符。
%%% @end
%%% Created : 09. 三月 2018 17:13
%%%-------------------------------------------------------------------
-module(spawnatom).
-author("${Eric}").

%% API
-compile(export_all).

start(AnAtom,Fun) ->
	create(AnAtom,Fun),
	create(AnAtom,Fun).

%%因为Pid匹配的范围大，它可以匹配undefined，所以第一段代码中undefined永远不会被匹配。
%%我们在写程序的时候需要注意，范围小的放在前面，范围大的放在后面，避免大范围包含小范围这种情况

create(AnAtom,Fun) ->
	case whereis(AnAtom) of
		undefined -> io:format("this atom is undefined~n") ,
			         register(AnAtom,spawn(Fun));

		Pid ->
			io:format(" this atom Pid is ~p~n",[Pid])
end.


