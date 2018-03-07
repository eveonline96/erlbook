%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 三月 2018 16:33
%%%-------------------------------------------------------------------
-module(parsefile).
-author("Administrator").

%% API
-export([parse/1,mytupletolist/1]).
-import(rfc4627,[decode/1,encode/1]). %decode解码，encode编码



parse(File) ->
  case file:open(File,read) of
    {ok,FileFd}->parse(FileFd, io:get_line(FileFd, "Read a line"), #{});
    {error,Reason} -> io:format("parsefile error ~p~n",[Reason])
  end.

%%parse() ->
%%  ;
%%  parse() ->
%%.



mytupletolist(T) ->
  mytupletolist(T,tuple_size(),0,[]).

mytupletolist(L,size,F,K)  when  size  > F  ->
  mytupletolist(L,size-1,F,[element(size,L)|L]);

mytupletolist(L,size,F,K)  when  size =:= F  ->
  L.
