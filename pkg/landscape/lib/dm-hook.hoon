/-  *dm-hook
|%
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    |^
    %-  of
    :~  accept+ship
        decline+ship
        pendings+ships
        screen+bo
    ==
    ::
    ++  ship  (su ;~(pfix sig fed:ag))
    ::
    ++  ships  (as ship)
    --
  --
::
++  enjs
  =,  enjs:format
  |%
  ::
  ++  action
    |=  act=^action
    %+  ob  -.act
    ?-  -.act
      ?(%accept %decline)   (hl +.act)
      %pendings             (st ships.act hl)
      %screen               (bo +.act)
    ==
  --
--
