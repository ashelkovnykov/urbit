/-  sur=contact-store
/+  res=resource
=<  [sur .]
=,  sur
|%
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    %+  ob  %contact-update
    %-  pr
    :_  ~
    ^-  [cord json]
    ?-  -.upd
        %initial
      :-  %initial
      %-  pr
      :~  [%rolodex (rolo rolodex.upd)]
          [%is-public (bo is-public.upd)]
      ==
    ::
        %add
      :-  %add
      %-  pr
      :~  [%ship (hl ship.upd)]
          [%contact (cont contact.upd)]
      ==
    ::
        %remove
      [%remove (ob %ship (hl ship.upd))]
    ::
        %edit
      :-  %edit
      %-  pr
      :~  [%ship (hl ship.upd)]
          [%edit-field (edit edit-field.upd)]
          [%timestamp (ms timestamp.upd)]
      ==
    ::
        %allow
      [%allow (ob %beings (beng beings.upd))]
    ::
        %disallow
      [%disallow (ob %beings (beng beings.upd))]
    ::
        %set-public
      [%set-public (bo public.upd)]
    ==
  ::
  ++  rolo
    |=  =rolodex
    ^-  json
    :-  %o
    ^-  (map @t json)
    %-  ~(run in rolodex)
    |=  [=ship =contact]
    [(scot %p ship) (cont contact)]
  ::
  ++  cont
    |=  =contact
    ^-  json
    %-  pr
    :~  [%nickname (co nickname.contact)]
        [%bio (co bio.contact)]
        [%status (co status.contact)]
        [%color (nh %ux color.contact)]
        [%avatar (un avatar.contact co)]
        [%cover (un cover.contact co)]
        [%groups (st groups.contact enjs-path:res)]
        [%last-updated (ms last-updated.contact)]
    ==
  ::
  ++  edit
    |=  field=edit-field
    ^-  json
    %+  ob  -.field
    ?-  -.field
      %nickname      (co nickname.field)
      %bio           (co bio.field)
      %status        (co status.field)
      %color         (nh %ux color.field)
      %avatar        (un avatar.field co)
      %cover         (un cover.field co)
      %add-group     (enjs-path:res resource.field)
      %remove-group  (enjs-path:res resource.field)
    ==
  ::
  ++  beng
    |=  =beings
    ^-  json
    ?-  -.beings
      %ships  (st ships.beings hp)
      %group  (enjs:res resource.beings)
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  update
    |=  jon=json
    ^-  ^update
    =<  (decode jon)
    |%
    ++  decode
      %-  of
      :~  [%initial initial]
          [%add add-contact]
          [%remove remove-contact]
          [%edit edit-contact]
          [%allow beings]
          [%disallow beings]
          [%set-public bo]
      ==
    ::
    ++  initial
      %-  ot
      :~  [%rolodex (op ;~(pfix sig fed:ag) cont)]
          [%is-public bo]
      ==
    ::
    ++  add-contact
      %-  ot
      :~  [%ship sp]
          [%contact cont]
      ==
    ::
    ++  remove-contact  (ot [%ship sp]~)
    ::
    ++  edit-contact
      %-  ot
      :~  [%ship sp]
          [%edit-field edit]
          [%timestamp di]
      ==
    ::
    ++  beings
      %-  of
      :~  [%ships (as sp)]
          [%group dejs:res]
      ==
    ::
    ++  cont
      %-  ot
      :~  [%nickname so]
          [%bio so]
          [%status so]
          [%color nx]
          [%avatar (mu so)]
          [%cover (mu so)]
          [%groups (as dejs:res)]
          [%last-updated di]
      ==
    ::
    ++  edit
      %-  of
      :~  [%nickname so]
          [%bio so]
          [%status so]
          [%color nx]
          [%avatar (mu so)]
          [%cover (mu so)]
          [%add-group dejs:res]
          [%remove-group dejs:res]
      ==
    --
  --
::
++  share-dejs
  =,  dejs:format
  |%
  ++  share  
      ^-  $-(json [%share ship])
      (of share+sp ~)
  --
--
