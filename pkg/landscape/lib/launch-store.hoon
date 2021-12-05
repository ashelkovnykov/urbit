/-  sur=launch-store
^?
=<  [sur .]
=,  sur
|%
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    |^  (ob %launch-update (ob (encode upd)))
    ::
    ++  encode
      |=  upd=^update
      ^-  [cord json]
      ?-  -.upd
          %add
        :-  %add
        %-  pr
        :~  [%name (co name.upd)]
            [%tile (tile tile.upd)]
        ==
      ::
          %remove             [%remove (co name.upd)]
          %change-order       [%'changeOrder' (ls tile-ordering.upd co)]
          %change-first-time  [%'changeFirstTime' (bo first-time.upd)]
          %change-is-shown
        :-  %'changeIsShown'
        %-  pr
        :~  [%name (co name.upd)]
            [%'isShown' (bo is-shown.upd)]
        ==
      ::
          %initial
        :-  %initial
        %-  pr
        :~  [%tiles (tiles tiles.upd)]
            [%'tileOrdering' (ls tile-ordering.upd co)]
            [%'firstTime' (bo first-time.upd)]
        ==
      ::
          %keys  [%keys (st keys.upd co)]
      ==
    ::
    ++  tile
      |=  =^tile
      ^-  json
      %-  pr
      :~  [%type (tile-type type.tile)]
          [%'isShown' (bo is-shown.tile)]
      ==
    ::
    ++  tiles
      |=  =^tiles
      ^-  json
      :-  %o
      %-  ~(run by tiles)
      |=  til=^tile
      ^-  json
      (tile til)
    ::
    ++  tile-type
      |=  type=^tile-type
      ^-  json
      ?-  -.type
          %basic
        %+  ob  %basic
        %-  pr
        :~  [%title (co title.type)]
            [%'iconUrl' (co icon-url.type)]
            [%'linkedUrl' (co linked-url.type)]
        ==
      ::
          %custom
        %+  ob  %custom
        %-  pr
        :~  [%'linkedUrl' (un linked-url.type co)]
            [%'image' (un image.type co)]
        ==
      ==
    --
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    |=  =json
    ^-  ^action
    |^  (decode json)
    ++  decode
      %-  of
      :~  [%add (ot [[%name (su sym)] [%tile tile] ~])]
          [%remove (su sym)]
          [%change-order (ar (su sym))]
          [%change-first-time bo]
          [%change-is-shown (ot [[%name (su sym)] [%'isShown' bo] ~])]
      ==
    --
  ::
  ++  tile
    |^
    %-  ot
    :~  [%type tile-type]
        [%'isShown' bo]
    ==
    ::
    ++  tile-type
      %-  of
      :~  [%basic basic]
          [%custom (ot [%'linkedUrl' (mu so)] [%'image' (mu so)] ~)]
      ==
    ::
    ++  basic
      %-  ot
      :~  [%title so]
          [%'iconUrl' so]
          [%'linkedUrl' so]
      ==
    --
  --
--
