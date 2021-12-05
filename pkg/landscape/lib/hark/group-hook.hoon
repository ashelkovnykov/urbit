/-  sur=hark-group-hook
/+  resource
^?
=<  [. sur]
=,  sur
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  listen+dejs-path:resource
        ignore+dejs-path:resource
    ==
  --
::
++  enjs
  =,  enjs:format
  ++  update
    |=  upd=^update
    %+  ob  -.upd
    ?-  -.upd
      ?(%listen %ignore)  (enjs-path:resource group.upd)
      %initial  (st watching.upd enjs-path:resource)
    ==
  --
--
