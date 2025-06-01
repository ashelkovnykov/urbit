::  eth-watcher: ethereum event log collector
::
/+  ethereum
=,  jael
|%
+$  config
  $:  ::  url: ethereum node rpc endpoint
      ::
      url=@ta
      ::  eager: if true, give logs asap, send disavows in case of reorg
      ::
      eager=?
      ::  refresh-rate: rate at which to check for updates
      ::
      refresh-rate=@dr
      ::  timeout-time: time an update check is allowed to take
      ::
      timeout-time=@dr
      ::  from: oldest block number to look at
      ::
      from=number:block
      ::  to: optional newest block number to look at
      ::
      to=(unit number:block)
      ::  contracts: contract addresses to look at
      ::
      contracts=(list address:ethereum)
      ::  TODO
      ::  batchers: ???
      ::
      batchers=(list address:ethereum)
      ::  topics: event descriptions to look for
      ::
      =topics
  ==
::
+$  loglist  (list event-log:rpc:ethereum)
+$  topics   (list ?(@ux (list @ux)))
+$  watchpup
  $:  config
      =number:block
      =pending-logs
      blocks=(list block)
  ==
::
::  disavows: newest block first
+$  disavows      (list id:block)
+$  pending-logs  (map number:block loglist)
::
+$  poke
  $%  ::  %watch: configure a watchdog and fetch initial logs
      ::
      [%watch =path =config]
      ::  %clear: remove a watchdog
      ::
      [%clear =path]
  ==
::
+$  diff
  $%  ::  %history: full event log history, oldest first
      ::
      [%history =loglist]
      ::  %logs: newly added logs
      ::
      [%logs =loglist]
      ::  %disavow: forget logs
      ::
      ::    this is sent when a reorg happens that invalidates
      ::    previously-sent logs
      ::
      [%disavow =id:block]
  ==
--
