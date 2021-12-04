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
        ship+(su ;~(pfix sig fed:ag))
        app+(su (perk %groups %graph ~))
        'shareContact'^bo
        autojoin+bo
    ==
  ::
  ++  invite
    %-  ot
    :~  resource+dejs:resource
        ships+(as (su ;~(pfix sig fed:ag)))
        description+so
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    %+  frond  %group-view-update
    %+  frond  -.upd
    ?-  -.upd
      %initial    (initial +.upd)
      %progress   (progress +.upd)
      %started    (started +.upd)
      %hide       (enjs-path:resource +.upd)
    ==
  ::
  ++  started
    |=  [rid=resource req=^request]
    %-  pairs
    :~  resource+(enjs-path:resource rid)
        request+(request req)
    ==
  ::
  ++  progress
    |=  [rid=resource prog=^progress]
    %-  pairs
    :~  resource+(enjs-path:resource rid)
        progress+(cord prog)
    ==
  ++  request
    |=  req=^request
    %-  pairs
    :~  started+(time started.req)
        ship+(shil ship.req)
        progress+(cord progress.req)
        'shareContact'^(bool share-co.req)
        autojoin+(bool autojoin.req)
        app+(cord app.req)
        invite+(set invite.req (cury numh %ux))
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
