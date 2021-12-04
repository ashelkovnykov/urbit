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
    |^  (frond %launch-update (frond (encode upd)))
    ::
    ++  encode
      |=  upd=^update
      ^-  [^cord json]
      ?-  -.upd
          %add
        :-  %add
        %-  pairs
        :~  [%name (cord name.upd)]
            [%tile (tile tile.upd)]
        ==
      ::
          %remove             [%remove (cord name.upd)]
          %change-order       [%'changeOrder' (list tile-ordering.upd cord)]
          %change-first-time  [%'changeFirstTime' (bool first-time.upd)]
          %change-is-shown
        :-  %'changeIsShown'
        %-  pairs
        :~  [%name (cord name.upd)]
            [%'isShown' (bool is-shown.upd)]
        ==
      ::
          %initial
        :-  %initial
        %-  pairs
        :~  [%tiles (tiles tiles.upd)]
            [%'tileOrdering' (list tile-ordering.upd cord)]
            [%'firstTime' (bool first-time.upd)]
        ==
      ::
          %keys  [%keys (set keys.upd cord)]
      ==
    ::
    ++  tile
      |=  =^tile
      ^-  json
      %-  pairs
      :~  [%type (tile-type type.tile)]
          [%'isShown' (bool is-shown.tile)]
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
        %+  frond  %basic
        %-  pairs
        :~  [%title (cord title.type)]
            [%'iconUrl' (cord icon-url.type)]
            [%'linkedUrl' (cord linked-url.type)]
        ==
      ::
          %custom
        %+  frond  %custom
        %-  pairs
        :~  [%'linkedUrl' (unit linked-url.type cord)]
            [%'image' (unit image.type cord)]
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
