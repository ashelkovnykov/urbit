/-  sur=group-view, spider
/+  resource, strandio, metadata=metadata-store, store=group-store
^?
=<  [. sur]
=,  sur
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    ^-  $-(json ^action)
    %-  of
    :~  create+create
        remove+remove
        join+join
        abort+dejs-path:resource
        leave+leave
        invite+invite
        done+dejs-path:resource
    ==
  ::
  ++  create
    %-  ot
    :~  name+so
        policy+policy:dejs:store
        title+so
        description+so
    ==
  ::
  ++  remove  dejs:resource
  ::
  ++  leave  dejs:resource
  ::
  ++  join
    %-  ot
    :~  resource+dejs:resource
        ship+sp
        app+(su (perk %groups %graph ~))
        'shareContact'^bo
        autojoin+bo
    ==
  ::
  ++  invite
    %-  ot
    :~  resource+dejs:resource
        ships+(as sp)
        description+so
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    %+  ob  %group-view-update
    %+  ob  -.upd
    ?-  -.upd
      %initial    (initial +.upd)
      %progress   (progress +.upd)
      %started    (started +.upd)
      %hide       (enjs-path:resource +.upd)
    ==
  ::
  ++  started
    |=  [rid=resource req=^request]
    %-  pr
    :~  resource+(enjs-path:resource rid)
        request+(request req)
    ==
  ::
  ++  progress
    |=  [rid=resource prog=^progress]
    %-  pr
    :~  resource+(enjs-path:resource rid)
        progress+(co prog)
    ==
  ++  request
    |=  req=^request
    %-  pr
    :~  started+(ms started.req)
        ship+(hl ship.req)
        progress+(co progress.req)
        'shareContact'^(bo share-co.req)
        autojoin+(bo autojoin.req)
        app+(co app.req)
        invite+(st invite.req (cury nh %ux))
    ==
  ::
  ++  initial
    |=  init=(map resource ^request)
    :-  %o
    ^-  (map @t json)
    %-  ~(run in init)
    |=  [rid=resource req=^request]
    :_  (request req)
    (enjs-path:resource rid)
  --
++  cleanup-md
  |=  rid=resource
  =/  m  (strand:spider ,~)
  ^-  form:m
  ;<  =associations:metadata  bind:m  
    %+  scry:strandio  associations:metadata
    %+  weld  /gx/metadata-store/group 
    (snoc (en-path:resource rid) %noun)
  ~&  associations
  =/  assocs=(list [=md-resource:metadata association:metadata])
    ~(tap by associations) 
  |-  
  =*  loop  $
  ?~  assocs
    (pure:m ~)
  ;<  ~  bind:m
    %+  poke-our:strandio  %metadata-store
    metadata-action+!>([%remove rid md-resource.i.assocs])
  loop(assocs t.assocs)
--
