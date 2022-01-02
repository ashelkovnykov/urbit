/-  sur=graph-view, store=graph-store
/+  resource, group-store, metadata-store
^?
=<  [sur .]
=,  sur
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    |^
    ^-  $-(json ^action)
    %-  of
    :~  create+create
        delete+delete
        join+join
        leave+leave
        groupify+groupify
        eval+so
        pending-indices+pending-indices
        create-group-feed+create-group-feed
        disable-group-feed+disable-group-feed
        ::invite+invite
    ==
    ::
    ++  create
      %-  ot
      :~  resource+dejs:resource
          title+so
          description+so
          mark+(mu so)
          associated+associated
          module+so
      ==
    ::
    ++  leave
      %-  ot
      :~  resource+dejs:resource
      ==
    ::
    ++  delete
      %-  ot
      :~  resource+dejs:resource
      ==
    ::
    ++  join
      %-  ot
      :~  resource+dejs:resource
          ship+sp
      ==
    ::
    ++  groupify  
      %-  ot
      :~  resource+dejs:resource
          to+(mu dejs:resource)
      ==
    ::
    ++  pending-indices  (op hex (su ;~(pfix fas (more fas dem))))
    ::
    ++  invite    !!
    ::
    ++  associated
      %-  of
      :~  group+dejs:resource
          policy+policy:dejs:group-store
      ==
    ::
    ++  create-group-feed
      %-  ot
      :~  resource+dejs:resource
          vip+vip:dejs:metadata-store
      ==
    ::
    ++  disable-group-feed
      %-  ot
      :~  resource+dejs:resource
      ==
    --
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  action
    |=  act=^action
    ^-  json
    ?>  ?=(%pending-indices -.act)
    %+  ob  %pending-indices
    :-  %o
    ^-  (map @t json)
    %-  ~(run in pending.act)
    |=  [h=hash:store i=index:store]
    =/  idx  (index i)
    ?>  ?=(%s -.idx)
    [p.idx (nh %ux h)]
  ::
  ++  index
    |=  i=index:store
    ^-  json
    %-  %s
    ?~  i  '/'
    %+  roll  i
    |=  [cur=@ acc=@t]
    (rap 3 acc '/' (crip (a-co:co cur)) ~)
  --
--
