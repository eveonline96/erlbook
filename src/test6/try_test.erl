%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.

%%如果编译器能够明确的知道你表达式的值的话，除非这几个东西 atom, [], boolean 不警告以外，
%%其他无用的一律警告， 而且尽可能的不产生代码。 这就解释为什么大部分的函数返回值是 原子或者 [].

% 重写 try_test.erl 里的代码，让它生成两条错误消息;
% 一条明文消息给用户，另一条详细的消息给开发者。
%%erlang:get_stacktrace打印详细的函数调用栈，可以很好的让开发者判断错误发生时程序执行的位置。
%%对于普通用户，简单回复错误内容或警告即可。
%%---
-module(try_test).
-compile(export_all).

generate_exception(1) -> a;
generate_exception(2) -> throw(a);
generate_exception(3) -> exit(a);
generate_exception(4) -> {'EXIT', a};
generate_exception(5) -> error(a).

demo1() ->
     [catcher_new(I) || I <- [1,2,3,4,5]].

catcher(N) ->
   try generate_exception(N) of
       Val -> {N, normal, Val}
   catch
       throw:X -> {N, caught, thrown, X};
       exit:X  -> {N, caught, exited, X};
       error:X -> {N, caught, error, X}
   end.

demo2() ->
    [{I, (catch generate_exception(I))} || I <- [1,2,3,4,5]].

demo3() ->
    try generate_exception(5) 
    catch
       error:X ->
	    {X, erlang:get_stacktrace()}
    end.
	
lookup(N) ->
          case(N) of
	     1 -> {'EXIT', a};
	     2 -> exit(a)
	  end.

catcher_new(N) ->
	try generate_exception(N) of
		Val -> {N, normal, Val}
	catch
		throw:X -> io:format("error is ~p",[X]),{developer,X,erlang:get_stacktrace()};
		exit:X  -> io:format("error is ~p",[X]),{developer,X,erlang:get_stacktrace()};
		error:X -> io:format("error is ~p",[X]),{developer,X,erlang:get_stacktrace()}
	end.


