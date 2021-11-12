/-  sur=hark-store
^?
=,  sur
=<  [. sur]
|%
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    %+  ob  -.upd
    ?+  -.upd  a+~
        %added         (notification +.upd)
        %add-note      (add-note +.upd)
        %timebox       (timebox +.upd)
        %more          (more +.upd)
        %read-each     (read-each +.upd)
        %read-count    (place +.upd)
        %unread-each   (read-each +.upd)
        %unread-count  (unread-count +.upd)
        %saw-place     (saw-place +.upd)
        %all-stats     (all-stats +.upd)
        %del-place     (place +.upd)
        ::%read-note     (index +.upd)
        ::%note-read     (note-read +.upd)
        %archived      (archived +.upd)
    ==
  ::
  ++  add-note
    |=  [bi=^bin bo=^body]
    %-  pr
    :~  bin+(bin bi)
        body+(body bo)
    ==
  ::
  ++  saw-place
    |=  [p=^place t=(unit time)]
    %-  pr
    :~  place+(place p)
        time+(un t ms)
    ==
  ::
  ++  archived
    |=  [t=time l=^lid n=^notification]
    %-  pr
    :~  lid+(lid l)
        time+(nh %ud t)
        notification+(notification n)
    ==
  ::
  ++  note-read
    |=  *
    (pr ~)
  ::
  ++  all-stats
    |=  places=(map ^place ^stats)
    ^-  json 
    %+  ls  ~(tap by places)
    |=  [p=^place s=^stats]
    %-  pr
    :~  stats+(stats s)
        place+(place p)
    ==
  ::
  ++  stats
    |=  s=^stats
    ^-  json
    %-  pr
    :~  each+(st each.s pa)
        last+(ms last.s)
        count+(nu count.s)
    ==
  ++  more
    |=  upds=(list ^update)
    ^-  json
    (ls upds update)
  ::
  ++  place
    |=  =^place
    %-  pr
    :~  desk+(co desk.place)
        path+(pa path.place)
    ==
  ::
  ++  bin
    |=  =^bin
    %-  pr
    :~  place+(place place.bin)
        path+(pa path.bin)
    ==
  ++  notification
    |=  ^notification
    ^-  json
    %-  pr
    :~  time+(ms date)
        bin+(^bin bin)
        body+(bodies body)
    ==
  ++  bodies
    |=  bs=(list ^body)
    ^-  json
    (ls bs body)
  ::
  ++  contents
    |=  cs=(list ^content)
    ^-  json
    (ls cs content)
  ::
  ++  content
    |=  c=^content
    ^-  json
    %+  ob  -.c
    ?-  -.c
      %ship  (hp ship.c)
      %text  (co cord.c)
    ==
  ::
  ++  body
    |=  ^body
    ^-  json
    %-  pr
    :~  title+(contents title)
        content+(contents content)
        time+(ms time)
        link+(pa link)
    ==
  :: 
  ++  binned-notification
    |=  [=^bin =^notification]
    %-  pr
    :~  bin+(^bin bin)
        notification+(^notification notification)
    ==
  ++  lid
    |=  l=^lid
    ^-  json
    %+  ob  -.l
    ?-  -.l
      ?(%seen %unseen)  ~
      %archive          (nh %ud time.l)
    ==
  ::
  ++  timebox
    |=  [li=^lid l=(list ^notification)]
    ^-  json
    %-  pr
    :~  lid+(lid li)
        notifications+(ls l notification)
    ==
  ::
  ++  read-each
    |=  [p=^place pax=path]
    %-  pr
    :~  place+(place p)
        path+(pa pax)
    ==
  ::
  ++  unread-count
    |=  [p=^place inc=? count=@ud]
    %-  pr
    :~  place+(place p)
        inc+(bo inc)
        count+(nu count)
    ==
  --
++  dejs
  =,  dejs:format
  |%
  ++  place
    %-  ot
    :~  desk+so
        path+pa
    ==
  ::
  ++  bin
    %-  ot
    :~  path+pa
        place+place
    ==
  ::
  ++  read-each
    %-  ot
    :~  place+place
        path+pa
    ==
  ++  lid
    %-  of
    :~  archive+(cu |=(a=@ `@da`a) (su dem:ag))
        unseen+ul
        seen+ul
    ==
  ::
  ++  archive
    %-  ot
    :~  lid+lid
        bin+bin
    ==
  ::
  ++  action
    ^-  $-(json ^action)
    %-  of
    :~  archive-all+ul
        archive+archive
        opened+ul
        read-count+place
        read-each+read-each
        read-note+bin
    ==
  --
--
