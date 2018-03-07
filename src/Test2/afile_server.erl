-module(afile_server).
-export([start/1,loop/1]).

start(Dir) ->spawn(afile_server,loop,[Dir]).
% 接受请求 1.目录 2.文件
% 回复请求
loop(Dir) -> %Dir是服务端的地址
 	receive
 		{Client,list_dir }->
 			Client ! {self(),file:list_dir(Dir)};

 		{Client,{get_file,File}} ->
 			Full = filename:join(Dir,File),
 			Client ! {self(),file:read_file(Full)};

		{Client,{put_file,Content,NewName}} ->
			Content,
			FullTwo =filename:join(Dir,NewName),%使用目录分隔符连接两个文件名组件。相当于join([Name1, Name2])
			Ret =file:write_file(FullTwo,Content),%（文件名，字节）Reason = posix() | badarg | terminated | system_limit
			Client!{self(),{Ret,FullTwo,Content}}
  end,
	loop(Dir).


