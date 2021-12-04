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
    |^
    %+  frond  -.upd
    ?+  -.upd  a+~
        %added          (notification +.upd)
        %add-note       (add-note +.upd)
        %timebox        (timebox +.upd)
        %more           (more +.upd)
        %read-each      (read-each +.upd)
        %read-count     (place +.upd)
        %unread-each    (read-each +.upd)
        %unread-count   (unread-count +.upd)
        %saw-place      (saw-place +.upd)
        %all-stats      (all-stats +.upd)
        %del-place      (place +.upd)
        ::%read-note      (index +.upd)
        ::%note-read      (note-read +.upd)
        %archived       (archived +.upd)
    ==
    ::
    ++  add-note
      |=  [bi=^bin bo=^body]
      %-  pairs
      :~  bin+(bin bi)
          body+(body bo)
      ==
    ::
    ++  saw-place
      |=  [p=^place t=(^unit ^time)]
      %-  pairs
      :~  place+(place p)
          time+(unit t time)
      ==
    ::
    ++  archived
      |=  [t=^time l=^lid n=^notification]
      %-  pairs
      :~  lid+(lid l)
          time+(numh %ud t)
          notification+(notification n)
      ==
    ::
    ++  note-read
      |=  *
      (pairs ~)
    ::
    ++  all-stats
      |=  places=(map ^place ^stats)
      ^-  json
      %+  list  ~(tap by places)
      |=  [p=^place s=^stats]
      %-  pairs
      :~  stats+(stats s)
          place+(place p)
      ==
    ::
    ++  stats
      |=  s=^stats
      ^-  json
      %-  pairs
      :~  each+(set each.s path)
          last+(time last.s)
          count+(numb count.s)
      ==
    ++  more
      |=  upds=(^list ^update)
      ^-  json
      (list upds update)
    ::
    ++  place
      |=  =^place
      %-  pairs
      :~  desk+(cord desk.place)
          path+(path path.place)
      ==
    ::
    ++  bin
      |=  =^bin
      %-  pairs
      :~  place+(place place.bin)
          path+(path path.bin)
      ==
    ++  notification
      |=  ^notification
      ^-  json
      %-  pairs
      :~  time+(time date)
          bin+(^bin bin)
          body+(bodies body)
      ==
    ++  bodies
      |=  bs=(^list ^body)
      ^-  json
      (list bs body)
    ::
    ++  contents
      |=  cs=(^list ^content)
      ^-  json
      (list cs content)
    ::
    ++  content
      |=  c=^content
      ^-  json
      %+  frond  -.c
      ?-  -.c
        %ship  (ship ship.c)
        %text  (cord cord.c)
      ==
    ::
    ++  body
      |=  ^body
      ^-  json
      %-  pairs
      :~  title+(contents title)
          content+(contents content)
          time+(^time time)
          link+(path link)
      ==
    :: 
    ++  binned-notification
      |=  [=^bin =^notification]
      %-  pairs
      :~  bin+(^bin bin)
          notification+(^notification notification)
      ==
    ++  lid
      |=  l=^lid
      ^-  json
      %+  frond  -.l
      ?-  -.l
        ?(%seen %unseen)  ~
        %archive          (numh %ud time.l)
      ==
    ::
    ++  timebox
      |=  [li=^lid l=(^list ^notification)]
      ^-  json
      %-  pairs
      :~  lid+(lid li)
          notifications+(list l notification)
      ==
    ::
    ++  read-each
      |=  [p=^place pax=^path]
      %-  pairs
      :~  place+(place p)
          path+(path pax)
      ==
    ::
    ++  unread-count
      |=  [p=^place inc=? count=@ud]
      %-  pairs
      :~  place+(place p)
          inc+(bool inc)
          count+(numb count)
      ==
    --
  --
++  dejs
  =,  dejs:format
  |%
  :: TODO: fix +stab 
  ::
  ++  pa
    |=  j=json
    ^-  path
    ?>  ?=(%s -.j)
    ?:  =('/' p.j)  /
    (stab p.j)
  ::
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
  ::
  ::  parse date as @ud
  ::    TODO: move to zuse
  ++  sd
    |=  jon=json 
    ^-  @da
    ?>  ?=(%s -.jon)
    `@da`(rash p.jon dem:ag)
  ::
  ++  lid
    %-  of
    :~  archive+sd
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
