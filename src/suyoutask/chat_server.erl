-module (chat_server).
-export ([start_server/0, server/1]).


%服务器进程
%用户列表格式：[{ClientPid1,Name1},{ClientPid2,Name2}...]
server(User_List) ->
    receive
        {From, logon, Name} ->
            New_User_List = server_logon(From, Name, User_List),
            server(New_User_List);
        {From, logoff} ->
            New_User_List = server_logoff(From, User_List),
            server(New_User_List);
        {From, message_to, To, Message} ->
            server_transfer(From, To, Message, User_List),
            io:format("list is now: ~p~n", [User_List]),
            server(User_List)
    end.

% 启动服务器
start_server() ->
    register(messenger, spawn(chat_server, server, [[]])).

% 服务器将新用户添加到用户列表
server_logon(From, Name, User_List) ->
    % 检查是否在其他地方登录
    case lists:keymember(Name, 2, User_List) of
        true ->
            From ! {messenger, stop, user_exists_at_other_node},  %拒绝登陆
            User_List;
        false ->
            From ! {messenger, logged_on},
            [{From, Name} | User_List]        %想列表中添加用户
    end.

% 服务器从用户列表中删除用户
server_logoff(From, User_List) ->
    lists:keydelete(From, 1, User_List).

% 服务器在用户之间传输消息
server_transfer(From, To, Message, User_List) ->
    % 检查用户是否登录以及他是谁
    case lists:keysearch(From, 1, User_List) of
        false ->
            From ! {messenger, stop, you_are_not_logged_on};
        {value, {From, Name}} ->
            server_transfer(From, Name, To, Message, User_List)
    end.
% 如果用户存在，则发送消息
server_transfer(From, Name, To, Message, User_List) ->
    % 找到接收者并发送消息
    case lists:keysearch(To, 2, User_List) of
        false ->
            From ! {messenger, receiver_not_found};
        {value, {ToPid, To}} ->
            ToPid ! {message_from, Name, Message}, 
            From ! {messenger, sent} 
    end.
