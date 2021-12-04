/-  *invite-store
/+  resource
|%
++  slan  |=(mod=@tas |=(txt=@ta (need (slaw mod txt))))
::
++  seri                                              :::  serial
  =,  dejs:format
  ^-  $-(json serial)
  (cu (slan %uv) so)
::
++  invites-to-json
  |=  inv=invites
  ^-  json
  :-  %o
  %-  ~(run by inv)
  |=  =invitatory
  ^-  json
  (invitatory-to-json invitatory)
::
++  invitatory-to-json
  |=  =invitatory
  ^-  json
  :-  %o
  ^-  (map @t json)
  %-  ~(run in invitatory)
  |=  [=serial =invite]
  [(scot %uv serial) (invite-to-json invite)]
::
++  invite-to-json
  |=  =invite
  ^-  json
  =,  enjs:format
  %-  pairs
  :~  [%ship (shil ship.invite)]
      [%app (cord app.invite)]
      [%resource (enjs:resource resource.invite)]
      [%recipient (shil recipient.invite)]
      [%text (cord text.invite)]
  ==
::
++  update-to-json
  |=  upd=update
  =,  enjs:format
  ^-  json
  %+  frond  %invite-update
  %-  frond
  ?+  -.upd  [*@t *json]
    %initial            [%initial (invites-to-json invites.upd)]
    %invitatory         [%invitatory (invitatory-to-json invitatory.upd)]
    ?(%create %delete)  [-.upd (frond [%term (cord term.upd)])]
    ::
      %decline
    :-  %decline
    %-  pairs
    :~  [%term (cord term.upd)]
        [%uid (numh %uv uid.upd)]
    ==
    ::
      ?(%accepted %invite)
    :-  -.upd
    %-  pairs
    :~  [%term (cord term.upd)]
        [%uid (numh %uv uid.upd)]
        [%invite (invite-to-json invite.upd)]
    ==
  ==
::
++  json-to-action
  |=  jon=json
  ^-  action
  =,  dejs:format
  =<  (parse-json jon)
  |%
  ++  parse-json
    %-  of
    :~  [%create so]
        [%delete so]
        [%invite invite]
        [%accept accept]
        [%decline decline]
    ==
  ::
  ++  invite
    %-  ot
    :~  [%term so]
        [%uid seri]
        [%invite invi]
    ==
  ::
  ++  accept
    %-  ot
    :~  [%term so]
        [%uid seri]
    ==
  ::
  ++  decline
    %-  ot
    :~  [%term so]
        [%uid seri]
    ==
  ::
  ++  invi
    %-  ot
    :~  [%ship (su ;~(pfix sig fed:ag))]
        [%app so]
        [%resource dejs:resource]
        [%recipient (su ;~(pfix sig fed:ag))]
        [%text so]
    ==
  --
--
