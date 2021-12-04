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
    %-  pairs
    :~  graph+(enjs-path:resource graph)
        index+(index:enjs:graph-store index)
    ==
  ::
  ++  action
    |=  act=^action
    ^-  json
    %+  frond  -.act
    ?-  -.act
      %set-watch-on-self  (bool watch-on-self.act)
      %set-mentions       (bool mentions.act)
      ?(%listen %ignore)  (graph-index graph.act index.act)
    ==
  ::
  ++  update
    |=  upd=^update
    ^-  json
    ?.  ?=(%initial -.upd)
      (action upd)
    %+  frond  -.upd
    %-  pairs
    :~  'watchOnSelf'^(bool watch-on-self.upd)
        'mentions'^(bool mentions.upd)
        'watching'^(set watching.upd graph-index)
    ==
  --
--
