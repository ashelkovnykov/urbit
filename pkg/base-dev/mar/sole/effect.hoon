::
::::  /hoon/effect/sole/mar
  ::
/?    310
/-    sole
!:
::
::::
  ::
=,  sole
=,  format
|%
++  mar-sole-change                       ::  XX  dependency
  |_  cha=sole-change
  ++  grow
    |%
    ++  json
      ^-  ^json
      =,  enjs
      =;  edi
        =,  cha
        %-  pairs
        :~
          ted+(edi ted)
          ler+(list ~[own.ler his.ler] numb)
        ==
      |=  det=sole-edit
      ?-  -.det
          %nop  (cord 'nop')
          %mor  (list p.det json)
          %del  (frond %del (numb p.det))
          %set  (frond %set (tape (tufa p.det)))
        ::
          %ins
        %+  frond  %ins
        %-  pairs
        :~
          at+(numb p.det)
          cha+(cord (tuft q.det))
        ==
      ==
    --
  --
++  wush
  |=  [wid=@u tan=tang]
  ^-  tape
  (of-wall (turn (flop tan) |=(a=tank (of-wall (wash 0^wid a)))))
::
++  purge                                               ::  discard ++styx style
  |=  a=styx  ^-  tape
  %-  zing  %+  turn  a
  |=  a=_?>(?=(^ a) i.a)
  ?@(a (trip a) ^$(a q.a))
--
::
|_  sef=sole-effect
::
++  grad  %noun
++  grab                                                ::  convert from
  |%
  ++  noun  sole-effect                                 ::  clam from %noun
  --
++  grow
  =,  enjs
  |%
  ++  noun  sef
  ++  json
    ^-  ^json
    ?+    -.sef
              ~|(unsupported-effect+-.sef !!)
        %mor  (list p.sef json)
        %err  (frond %hop (numb p.sef))
        %txt  (frond %txt (tape p.sef))
        %tan  (frond %tan (tape (wush 160 p.sef)))
        %det  (frond %det json:~(grow mar-sole-change +.sef))
    ::
        %pro
      %+  frond  %pro
      %-  pairs
      :~
        vis+(bool vis.sef)
        tag+(cord tag.sef)
        cad+(tape (purge cad.sef))
      ==
    ::
        %tab
      %+  list  p.sef
      |=  [c=^cord =^tank]
      %+  frond  %tab
      %-  pairs
      :~
        match+(cord c)
        info+(tape ~(ram re tank))
      ==
    ::
        ?(%bel %clr %nex %bye)
      (frond %act (cord -.sef))
    ==
  --
--
