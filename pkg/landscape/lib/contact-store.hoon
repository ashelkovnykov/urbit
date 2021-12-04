/-  sur=contact-store
/+  res=resource
=<  [sur .]
=,  sur
|%
++  nu                                              ::  parse number as hex
  |=  jon=json
  ?>  ?=([%s *] jon)
  (rash p.jon hex)
::
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    %+  frond  %contact-update
    %-  pairs
    :_  ~
    ^-  [^cord json]
    ?-  -.upd
        %initial
      :-  %initial
      %-  pairs
      :~  [%rolodex (rolo rolodex.upd)]
          [%is-public (bool is-public.upd)]
      ==
    ::
        %add
      :-  %add
      %-  pairs
      :~  [%ship (shil ship.upd)]
          [%contact (cont contact.upd)]
      ==
    ::
        %remove
      [%remove (frond %ship (shil ship.upd))]
    ::
        %edit
      :-  %edit
      %-  pairs
      :~  [%ship (shil ship.upd)]
          [%edit-field (edit edit-field.upd)]
          [%timestamp (time timestamp.upd)]
      ==
    ::
        %allow
      [%allow (frond %beings (beng beings.upd))]
    ::
        %disallow
      [%disallow (frond %beings (beng beings.upd))]
    ::
        %set-public
      [%set-public (bool public.upd)]
    ==
  ::
  ++  rolo
    |=  =rolodex
    ^-  json
    :-  %o
    ^-  (map @t json)
    %-  ~(run in rolodex)
    |=  [=^ship =contact]
    [(scot %p ship) (cont contact)]
  ::
  ++  cont
    |=  =contact
    ^-  json
    %-  pairs
    :~  [%nickname (cord nickname.contact)]
        [%bio (cord bio.contact)]
        [%status (cord status.contact)]
        [%color (numh %ux color.contact)]
        [%avatar (unit avatar.contact cord)]
        [%cover (unit cover.contact cord)]
        [%groups (set groups.contact enjs-path:res)]
        [%last-updated (time last-updated.contact)]
    ==
  ::
  ++  edit
    |=  field=edit-field
    ^-  json
    %+  frond  -.field
    ?-  -.field
      %nickname      (cord nickname.field)
      %bio           (cord bio.field)
      %status        (cord status.field)
      %color         (numh %ux color.field)
      %avatar        (unit avatar.field cord)
      %cover         (unit cover.field cord)
      %add-group     (enjs-path:res resource.field)
      %remove-group  (enjs-path:res resource.field)
    ==
  ::
  ++  beng
    |=  =beings
    ^-  json
    ?-  -.beings
      %ships  (set ships.beings ship)
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
      :~  [%ship (su ;~(pfix sig fed:ag))]
          [%contact cont]
      ==
    ::
    ++  remove-contact  (ot [%ship (su ;~(pfix sig fed:ag))]~)
    ::
    ++  edit-contact
      %-  ot
      :~  [%ship (su ;~(pfix sig fed:ag))]
          [%edit-field edit]
          [%timestamp di]
      ==
    ::
    ++  beings
      %-  of
      :~  [%ships (as (su ;~(pfix sig fed:ag)))]
          [%group dejs:res]
      ==
    ::
    ++  cont
      %-  ot
      :~  [%nickname so]
          [%bio so]
          [%status so]
          [%color nu]
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
          [%color nu]
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
      (of share+(su ;~(pfix sig fed:ag)) ~)
  --
--
