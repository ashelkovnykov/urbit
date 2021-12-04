::
::::  /hoon/tang/mar
  ::
/?    310
::
|_  tan=(list tank)
++  grad  %noun
++  grow
  |%
  ++  noun  tan
  ++  json
    =,  enjs:format
    =/  result=(each (^list ^json) tang)
      (mule |.((list tan tank)))
    ?:  -.result
      a+p.result
    a+[a+[%s '[[output rendering error]]']~]~
  ::
  ++  elem
    =-  ;pre:code:"{(of-wall -)}"
    ^-  wall  %-  zing  ^-  (list wall)
    (turn (flop tan) |=(a=tank (wash 0^160 a)))
  --
++  grab                                                ::  convert from
  |%
  ++  noun  (list ^tank)                                ::  clam from %noun
  ++  tank  |=(a=^tank [a]~)
  --
--
