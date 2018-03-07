%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 07. 三月 2018 16:33
%%%-------------------------------------------------------------------
-module('ParseFile').
-author("Administrator").

%% API
-export([parse/1]).
-import(rfc4627,[decode/1,encode/1]). %decode解码，encode编码



parse(File) ->
  case file:open(File,read) of
    {ok,FileFd}->parse(FileFd, io:get_line(FileFd, "Read a line"), #{});
    {error,Reason} -> io:format("parsefile error ~p~n",[Reason])
  end.

parse() ->
  ;
  parse() ->
.