-module(afile_client).
-export([ls/1,get_file/2,put_file/3]).

ls(Server) ->
	Server !{self(),list_dir},
	receive
		{Server,FileList}->
			FileList
	end.

get_file(Server,File) ->
	Server! {self(),{get_file,File}},
	receive
		{Server,Content} ->
			Content
	end.

% put_file 上传文件到 Server 上

% 注意不能直接发送 file:read_file 内容，
% file:read_file 返回的是一个元组，
% 需要提取出来 Content 二进制信息。
put_file(Server,File,NewName) ->
	case file:read_file(File) of
		{ok,Content} ->
			Server ! {self(),{put_file,Content,NewName}},
			receive
			{Server,Result} ->
				Result
			end;
		{error,Reason} ->
			Reason
  end.



