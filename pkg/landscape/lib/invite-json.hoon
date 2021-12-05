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
  %-  pr
  :~  [%ship (hl ship.invite)]
      [%app (co app.invite)]
      [%resource (enjs:resource resource.invite)]
      [%recipient (hl recipient.invite)]
      [%text (co text.invite)]
  ==
::
++  update-to-json
  |=  upd=update
  =,  enjs:format
  ^-  json
  %+  ob  %invite-update
  %-  ob
  ?+  -.upd  [*@t *json]
    %initial            [%initial (invites-to-json invites.upd)]
    %invitatory         [%invitatory (invitatory-to-json invitatory.upd)]
    ?(%create %delete)  [-.upd (ob [%term (co term.upd)])]
    ::
      %decline
    :-  %decline
    %-  pr
    :~  [%term (co term.upd)]
        [%uid (nh %uv uid.upd)]
    ==
    ::
      ?(%accepted %invite)
    :-  -.upd
    %-  pr
    :~  [%term (co term.upd)]
        [%uid (nh %uv uid.upd)]
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
