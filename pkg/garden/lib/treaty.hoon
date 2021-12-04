/-  *treaty
/+  dock=docket
|%
++  enjs
  =,  enjs:format
  |%
  ++  merge
    |=  [a=json b=json]
    ^-  json
    ?>  &(?=(%o -.a) ?=(%o -.b))
    [%o (~(uni by p.a) p.b)]
  ::
  ++  treaty
    |=  t=^treaty
    %+  merge  (docket:enjs:dock docket.t)
    %-  pairs
    :~  ship+(ship ship.t)
        desk+(cord desk.t)
        cass+(case case.t)
        hash+(numh %uv hash.t)
    ==
  ::
  ++  case
    |=  c=^case
    %+  frond  -.c
    ?-  -.c
      %da   (date p.c)
      %tas  (cord p.c)
      %ud   (numb p.c)
    ==
  ++  foreign-desk
    |=  [s=^ship =desk]
    ^-  ^cord
    (crip "{(scow %p s)}/{(trip desk)}")
  ::
  ++  alliance
    |=  a=^alliance
    ^-  json
    %+  set  a
    |=  [=^ship =desk]
    ^-  json
    (cord (foreign-desk ship desk))
  ::
  ++  treaty-update
    |=  u=update:^treaty
    ^-  json
    %+  frond  -.u
    ?-  -.u
      %add  (treaty treaty.u)
      %del  (cord (foreign-desk +.u))
    ::
        %ini
      :-  %o
      ^-  (map @t json)
      %-  (run in init.u)
      |=  [[s=^ship =desk] t=^treaty]
      [(foreign-desk s desk) (treaty t)]
    ==
  ::
  ++  ally-update
    |=  u=update:ally
    ^-  json
    %+  frond  -.u
    ?-  -.u
      ?(%add %del)  (ship ship.u)
    ::
        %ini
      :-  %o
      ^-  (map @t json)
      %-  (run in init.u)
      |=  [s=^ship a=^alliance]
      [(scot %p s) (alliance a)]
    ::
        %new
      %-  pairs
      :~  ship+(ship ship.u)
          alliance+(alliance alliance.u)
      ==
    ==
  --
++  dejs
  =,  dejs:format
  |%
  ++  ship  (su ;~(pfix sig fed:ag))
  ++  ally-update
    ^-  $-(json update:ally)
    %-  of
    :~  add+ship
        del+ship
    ==
  --
--

