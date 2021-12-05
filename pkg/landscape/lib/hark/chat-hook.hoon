/-  sur=hark-chat-hook
^?
=<  [. sur]
=,  sur
|%
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  listen+pa
        ignore+pa
        set-mentions+bo
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    %+  ob  -.upd
    ?-  -.upd
      ?(%listen %ignore)  (pa chat.upd)
      %set-mentions       (bo mentions.upd)
      %initial            (st watching.upd pa)
    ==
  --
--

