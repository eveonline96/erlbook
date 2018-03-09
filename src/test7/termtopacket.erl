%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc


%%Knowledge:
%%Ei = Value |
%%Value:Size |
%%Value/TypeSpecifierList |
%%Value:Size/TypeSpecifierList
%%Size表示前一个Value数据存储的位数，默认是8位，也就是一个字节。
%%TypeSpecifierList可以是以下几种类型及其组合，组合以 - 相连
%%Type = integer | float | binary | bytes |bitstring | bits | utf8 | utf16 | utf32
%%默认值是integer。bytes是binary的简写，bits是bitsring的简写
%%Signedness = signed | unsigned
%%只有当type为integer时有用，默认是unsigned
%%Endianness = big | little | native
%%当type为integer，utf16，utf32，float有用，默认是big
%%Unit = unit:IntegerLiteral
%%有效范围是1-256，integer、float和bitstring默认是1，binary默认是8
%%% @end
%%% Created : 09. 三月 2018 10:31
%%%-------------------------------------------------------------------
-module(termtopacket).
-author("${Eric}").

%% API
-export([term_to_packet/1,term_to_packet1/1,packet_to_term/1,reverse_binary/1]).

% (2).编写一个 term_to_packet(Term) -> Packet 的函数，
% 通过调用 term_to_binary(Term) 来生成并返回一个二进制型，
% 它内含长度为 4 个字节的包头 N，后跟 N 个字节的数据

%%term_to_packet(Term) ->
%%	Bin=term_to_binary(Term),
%%	<<_Head:32, Message/bitstring>>=Bin,
%%	Message.
term_to_packet(Term) ->
	Bin= term_to_binary(Term),
	Length = bit_size(Bin),
	Size = <<Length:1/unit:32>> ,  %默认size*unit位
	<<Size/binary,Bin/binary>>
		.
term_to_packet1(Term) ->
	Bin= term_to_binary(Term),
	Length = bit_size(Bin),
%%	Size = <<Length:4/big-unsigned-bytes-unit:8>> ,
	Size = <<Length:4/unit:8>> ,
%%	Size = <<Length:4>> ,
	<<Size/binary,Bin/binary>>.


% (3).编写一个反转函数 packet_to_term(Packet) -> Term，
% 使它成为前一个函数的逆向函数
packet_to_term(Packet) ->

	<<_Size:8/binary, Message/bitstring>> = Packet,
	binary_to_term(term_to_binary(Message)).

% (5).编写一个函数来反转某个二进制型所包含的位。

reverse_binary(Bin)  ->
	lists:reverse([X || <<X:1>>  <= Bin]).  %位推导


















