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
    %-  pr
    :~  ship+(hp ship.t)
        desk+(co desk.t)
        cass+(case case.t)
        hash+(nh %uv hash.t)
    ==
  ::
  ++  case
    |=  c=^case
    %+  ob  -.c
    ?-  -.c
      %da   (da p.c)
      %tas  (co p.c)
      %ud   (nu p.c)
    ==
  ++  foreign-desk
    |=  [s=ship =desk]
    ^-  cord
    (crip "{(scow %p s)}/{(trip desk)}")
  ::
  ++  alliance
    |=  a=^alliance
    ^-  json
    %+  st  a
    |=  [=ship =desk]
    ^-  json
    (co (foreign-desk ship desk))
  ::
  ++  treaty-update
    |=  u=update:^treaty
    ^-  json
    %+  ob  -.u
    ?-  -.u
      %add  (treaty treaty.u)
      %del  (co (foreign-desk +.u))
    ::
        %ini
      :-  %o
      ^-  (map @t json)
      %-  (run in init.u)
      |=  [[s=ship =desk] t=^treaty]
      [(foreign-desk s desk) (treaty t)]
    ==
  ::
  ++  ally-update
    |=  u=update:ally
    ^-  json
    %+  ob  -.u
    ?-  -.u
      ?(%add %del)  (hp ship.u)
    ::
        %ini
      :-  %o
      ^-  (map @t json)
      %-  (run in init.u)
      |=  [s=ship a=^alliance]
      [(scot %p s) (alliance a)]
    ::
        %new
      %-  pr
      :~  ship+(hp ship.u)
          alliance+(alliance alliance.u)
      ==
    ==
  --
++  dejs
  =,  dejs:format
  |%
  ++  ship  sp
  ++  ally-update
    ^-  $-(json update:ally)
    %-  of
    :~  add+ship
        del+ship
    ==
  --
--

