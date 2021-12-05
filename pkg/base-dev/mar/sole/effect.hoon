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
        %-  pr
        :~
          ted+(edi ted)
          ler+(ls ~[own.ler his.ler] nu)
        ==
      |=  det=sole-edit
      ?-  -.det
          %nop  (co 'nop')
          %mor  (ls p.det json)
          %del  (ob %del (nu p.det))
          %set  (ob %set (ta (tufa p.det)))
        ::
          %ins
        %+  ob  %ins
        %-  pr
        :~
          at+(nu p.det)
          cha+(co (tuft q.det))
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
        %mor  (ls p.sef json)
        %err  (ob %hop (nu p.sef))
        %txt  (ob %txt (ta p.sef))
        %tan  (ob %tan (ta (wush 160 p.sef)))
        %det  (ob %det json:~(grow mar-sole-change +.sef))
    ::
        %pro
      %+  ob  %pro
      %-  pr
      :~
        vis+(bo vis.sef)
        tag+(co tag.sef)
        cad+(ta (purge cad.sef))
      ==
    ::
        %tab
      %+  ls  p.sef
      |=  [=cord =tank]
      %+  ob  %tab
      %-  pr
      :~
        match+(co cord)
        info+(ta ~(ram re tank))
      ==
    ::
        ?(%bel %clr %nex %bye)
      (ob %act (co -.sef))
    ==
  --
--
