%%%-------------------------------------------------------------------
%%% @author ${Eric}
%%% @copyright (C) 2018, ${suyou_game}
%%% @doc
%%%消息和binary内存：erlang:process_flag(min_bin_vheap_size, 1024*1024)，
%%% 减少大量消息到达或处理过程中产生大量binary时的gc次数

%%堆内存：erlang:process_flag(min_heap_size, 1024*1024)，减少处理过程中产生大量term，尤其是list时的gc次数
%%进程优先级：erlang:process_flag(priority, high)，防止特殊进程被其它常见进程强制执行reductions
%%进程调度器绑定：erlang:process_flag(scheduler, 1)，
%%当进程使用了port时，还需要port绑定支持，防止进程在不同调度器间迁移引起性能损失，
%%如cache、跨numa node拷贝等，当进程使用了port时，主要是套接字，若进程与port不在一个scheduler上，
%%可能会引发严重的epoll fd锁竞争及跨numa node拷贝，导致性能严重下降
%%% @end
%%% Created : 13. 三月 2018 10:59
%%%-------------------------------------------------------------------
-author("Eric").
-record(todo,{type = person,name = [joe,eric],args=[12,34]}) .