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
    %+  frond  -.act
    ?-  -.act
      ?(%accept %decline)   (shil +.act)
      %pendings             (set ships.act shil)
      %screen               (bool +.act)
    ==
  --
--
