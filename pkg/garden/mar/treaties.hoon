/+  treaty
|_  treaties=(list treaty:treaty)
++  grow
  |%
  ++  noun  treaties
  ++  json  
    ^-  ^json
    %-  pr:enjs:format
    %+  turn  treaties
    |=  t=treaty:treaty
    :-  (crip "{(scow %p ship.t)}/{(trip desk.t)}")
    (treaty:enjs:treaty t)
  --
++  grab
  |%
  ++  noun  (list treaty:treaty)
  --
++  grad  %noun
--
