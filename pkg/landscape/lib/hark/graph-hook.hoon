/-  sur=hark-graph-hook, post
/+  graph-store, resource
^?
=<  [. sur]
=,  sur
|%
++  dejs
  =,  dejs:format
  |%
  ::
  ++  index
    ^-  $-(json index:graph-store)
    (su ;~(pfix fas (more fas dem)))
  ::
  ++  graph-index
    %-  ot
    :~  graph+dejs-path:resource
        index+index
    ==
  ::
  ++  action
    %-  of
    :~  listen+graph-index
        ignore+graph-index
        set-mentions+bo
        set-watch-on-self+bo
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ::
  ++  graph-index
    |=  [graph=resource =index:post]
    %-  pr
    :~  graph+(enjs-path:resource graph)
        index+(index:enjs:graph-store index)
    ==
  ::
  ++  action
    |=  act=^action
    ^-  json
    %+  ob  -.act
    ?-  -.act
      %set-watch-on-self  (bo watch-on-self.act)
      %set-mentions       (bo mentions.act)
      ?(%listen %ignore)  (graph-index graph.act index.act)
    ==
  ::
  ++  update
    |=  upd=^update
    ^-  json
    ?.  ?=(%initial -.upd)
      (action upd)
    %+  ob  -.upd
    %-  pr
    :~  'watchOnSelf'^(bo watch-on-self.upd)
        'mentions'^(bo mentions.upd)
        'watching'^(st watching.upd graph-index)
    ==
  --
--
