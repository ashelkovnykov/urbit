/-  verb
=,  dejs:format
|_  =event:verb
++  grad  %noun
++  grab
  |%
  ++  noun  event:verb
  --
::
++  grow
  |%
  ++  noun  event
  ++  json
    =,  enjs:format
    %+  ob  -.event
    ?-  -.event
      %on-init    ~
      %on-load    ~
      %on-poke    (co mark.event)
      %on-watch   (pa path.event)
      %on-leave   (pa path.event)
      %on-agent   %-  pr
                  :~  'wire'^(pa wire.event)
                      'sign'^(co sign.event)
                  ==
      %on-arvo    %-  pr
                  :~  'wire'^(pa wire.event)
                      'vane'^(co vane.event)
                      'sign'^(co sign.event)
                  ==
      %on-fail    (co term.event)
    ==
  --
--
