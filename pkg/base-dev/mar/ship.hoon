|_  s=ship
++  grad  %noun
++  grow
  |%
  ++  noun  s
  ++  json  (hp:enjs:format s)
  ++  mime
    ^-  ^mime
    [/text/x-ship (as-octt:mimes:html (scow %p s))]

  --
++  grab
  |%
  ++  noun  ship
  ++  json  sp:dejs:format
  ++  mime
    |=  [=mite len=@ tex=@]
    (slav %p (snag 0 (to-wain:format tex)))
  --
--
