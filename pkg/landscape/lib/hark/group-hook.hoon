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
    %+  frond  -.upd
    ?-  -.upd
      ?(%listen %ignore)  (enjs-path:resource group.upd)
      %initial  (set watching.upd enjs-path:resource)
    ==
  --
--
