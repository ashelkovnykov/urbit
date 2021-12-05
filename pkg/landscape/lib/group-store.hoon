/-  *group, sur=group-store
/+  resource
^?
=<  [. sur]
=,  sur
|%
::
++  dekebab
  |=  str=cord
  ^-  cord
  =-  (fall - str)
  %+  rush  str
  =/  name
    %+  cook
     |=  part=tape
     ^-  tape
     ?~  part  part
     :-  (sub i.part 32)
     t.part
    (star low)
  %+  cook
    (cork (bake zing (list tape)) crip)
  ;~(plug (star low) (more hep name))
::
++  enkebab
  |=  str=cord
  ^-  cord
  ~|  str
  =-  (fall - str)
  %+  rush  str
  =/  name
    %+  cook
      |=  part=tape
      ^-  tape
      ?~  part  part
      :-  (add i.part 32)
      t.part
    ;~(plug hig (star low))
  %+  cook
    |=(a=(list tape) (crip (zing (join "-" a))))
  ;~(plug (star low) (star name))

++  migrate-path-map
  |*  map=(map path *)
  =/  keys=(list path)
    (skim ~(tap in ~(key by map)) |=(=path =('~' (snag 0 path))))
  |-
  ?~  keys
    map
  =*  key  i.keys
  ?>  ?=(^ key)
  =/  value
    (~(got by map) key)
  =.  map
    (~(put by map) t.key value)
  =.  map
    (~(del by map) key)
  $(keys t.keys, map (~(put by map) t.key value))
::
++  enjs
  =,  enjs:format
  |%
  ++  ob
    |=  [p=@t q=json]
    ^-  json
    (ob:enjs:format (dekebab p) q)
  ++  pr
    |=  a=(list [p=@t q=json])
    ^-  json
    %-  pr:enjs:format
    %+  turn  a
    |=  [p=@t q=json]
    ^-  [@t json]
    [(dekebab p) q]
  ::
  ++  update
    |=  =^update
    ^-  json
    %+  ob  -.update
    ?-  -.update
      %add-group        (add-group update)
      %add-members      (add-members update)
      %add-tag          (add-tag update)
      %remove-members   (remove-members update)
      %remove-tag       (remove-tag update)
      %initial          (initial update)
      %initial-group    (initial-group update)
      %remove-group     (remove-group update)
      %change-policy    (change-policy update)
      %expose           (expose update)
    ==
  ::
  ++  initial-group
    |=  =^update
    ?>  ?=(%initial-group -.update)
    %-  pr
    :~  resource+(enjs:resource resource.update)
        group+(group group.update)
    ==
  ::
  ++  initial
    |=  =^initial
    ?>  ?=(%initial -.initial)
    :-  %o
    ^-  (map @t json)
    %-  ~(run in groups.initial)
    |=  [rid=resource grp=^group]
    :_  (group grp)
    (spat (en-path:resource rid))
  ::
  ++  group
    |=  =^group
    ^-  json
    %-  pr
    :~  members+(st members.group hl)
        policy+(policy policy.group)
        tags+(tags tags.group)
        hidden+(bo hidden.group)
    ==
  ++  tags
    |=  =^tags
    ^-  json
    :-  %o
    ^-  (map @t json)
    %-  ~(run in tags)
    |=  [=^tag ships=(set ship)]
    :_  (st ships hl)
    ?@  tag  tag
    ;:  (cury cat 3)
      app.tag  '\\'
      tag.tag  '\\'
      (spat (en-path:resource resource.tag))
    ==
  ::
  ++  tag
    |=  =^tag
    ^-  json
    ?@  tag
      (ob %tag (co tag))
    %-  pr
    :~  app+(co app.tag)
        tag+(co tag.tag)
        resource+(enjs-path:resource resource.tag)
    ==
  ::
  ++  policy
    |=  =^policy
    %+  ob  -.policy
    %-  pr
    ?-  -.policy
        %invite
      :~  pending+(st pending.policy hl)
      ==
    ::
        %open
      :~  banned+(st banned.policy hl)
          ban-ranks+(st ban-ranks.policy co)
      ==
    ==
  ++  policy-diff
    |=  =diff:^policy
    %+  ob  -.diff
    |^
    ?-  -.diff
      %invite   (invite +.diff)
      %open     (open +.diff)
      %replace  (policy +.diff)
    ==
    ++  open
      |=  =diff:open:^policy
      %+  ob  -.diff
      ?-  -.diff
        %allow-ranks  (st ranks.diff co)
        %ban-ranks    (st ranks.diff co)
        %allow-ships  (st ships.diff hl)
        %ban-ships    (st ships.diff hl)
      ==
    ++  invite
      |=  =diff:invite:^policy
      %+  ob  -.diff
      ?-  -.diff
        %add-invites      (st invitees.diff hl)
        %remove-invites   (st invitees.diff hl)
      ==
    --
  ::
  ++  expose
    |=  =^update
    ^-  json
    ?>  ?=(%expose -.update)
    (ob %resource (enjs:resource resource.update))
  ::
  ++  remove-group
    |=  =^update
    ^-  json
    ?>  ?=(%remove-group -.update)
    (ob %resource (enjs:resource resource.update))
  ::
  ++  add-group
    |=  =action
    ^-  json
    ?>  ?=(%add-group -.action)
    %-  pr
    :~  resource+(enjs:resource resource.action)
        policy+(policy policy.action)
        hidden+(bo hidden.action)
    ==
  ::
  ++  add-members
    |=  =action
    ^-  json
    ?>  ?=(%add-members -.action)
    %-  pr
    :~  resource+(enjs:resource resource.action)
        ships+(st ships.action hl)
    ==
  ::
  ++  remove-members
    |=  =action
    ^-  json
    ?>  ?=(%remove-members -.action)
    %-  pr
    :~  resource+(enjs:resource resource.action)
        ships+(st ships.action hl)
    ==
  ::
  ++  add-tag
    |=  =action
    ^-  json
    ?>  ?=(%add-tag -.action)
    %-  pr
    ^-  (list [p=@t q=json])
    :~  resource+(enjs:resource resource.action)
        tag+(tag tag.action)
        ships+(st ships.action hl)
    ==
  ::
  ++  remove-tag
    |=  =action
    ^-  json
    ?>  ?=(%remove-tag -.action)
    %-  pr
    :~  resource+(enjs:resource resource.action)
        tag+(tag tag.action)
        ships+(st ships.action hl)
    ==
  ::
  ++  change-policy
    |=  =action
    ^-  json
    ?>  ?=(%change-policy -.action)
    %-  pr
    :~  resource+(enjs:resource resource.action)
        diff+(policy-diff diff.action)
    ==
  --
++  dejs
  =,  dejs:format
  |%
  ::
  ++  ruk-jon
    |=  [a=(map @t json) b=$-(@t @t)]
    ^+  a
    =-  (malt -)
    |-
    ^-  (list [@t json])
    ?~  a  ~
    :-  [(b p.n.a) q.n.a]
    %+  weld
      $(a l.a)
    $(a r.a)
  ::
  ++  of
      |*  wer=(pole [cord fist])
      |=  jon=json
      ?>  ?=([%o [@ *] ~ ~] jon)
      |-
      ?-    wer
          :: [[key=@t wit=*] t=*]
          [[key=@t *] t=*]
        =>  .(wer [[* wit] *]=wer)
        ?:  =(key.wer (enkebab p.n.p.jon))
          [key.wer ~|(val+q.n.p.jon (wit.wer q.n.p.jon))]
        ?~  t.wer  ~|(bad-key+p.n.p.jon !!)
        ((of t.wer) jon)
      ==
  ++  ot
    |*  wer=(pole [cord fist])
    |=  jon=json
    ~|  jon
    %-  (ot-raw:dejs:format wer)
    ?>  ?=(%o -.jon)
    (ruk-jon p.jon enkebab)
  ::
  ++  update
    ^-  $-(json ^update)
    |=  jon=json
    ^-  ^update
    %.  jon
    %-  of
    :~
      add-group+add-group
      add-members+add-members
      remove-members+remove-members
      add-tag+add-tag
      remove-tag+remove-tag
      change-policy+change-policy
      remove-group+remove-group
      expose+expose
    ==
  ++  rank
    |=  =json
    ^-  rank:title
    ?>  ?=(%s -.json)
    ?+  p.json  !!
      %czar  %czar
      %king  %king
      %duke  %duke
      %earl  %earl
      %pawn  %pawn
    ==
  ++  tag
    |=  =json
    ^-  ^tag
    ?>  ?=(%o -.json)
    ?.  (~(has by p.json) 'app')
      =/  tag-json
        (~(got by p.json) 'tag')
      ?>  ?=(%s -.tag-json)
      ?:  =('admin' p.tag-json)  %admin
      ?:  =('moderator' p.tag-json)  %moderator
      ?:  =('janitor' p.tag-json)  %janitor
      !!
    %.  json
    %-  ot
    :~  app+so
        resource+dejs-path:resource
        tag+so
    ==

  ::  move to zuse also
  ++  oj
    |*  =fist
    ^-  $-(json (jug cord _(fist *json)))
    (om (as fist))
  ++  tags
    ^-  $-(json ^tags)
    *$-(json ^tags)
  :: TODO: move to zuse
  ++  ship
    (su ;~(pfix sig fed:ag))
  ++  policy
    ^-  $-(json ^policy)
    %-  of
    :~  invite+invite-policy
        open+open-policy
    ==
  ++  invite-policy
    %-  ot
    :~  pending+(as ship)
    ==
  ++  open-policy
    %-  ot
    :~  ban-ranks+(as rank)
        banned+(as ship)
    ==
  ++  open-policy-diff
    %-  of
    :~  allow-ranks+(as rank)
        allow-ships+(as ship)
        ban-ranks+(as rank)
        ban-ships+(as ship)
    ==
  ++  invite-policy-diff
    %-  of
    :~  add-invites+(as ship)
        remove-invites+(as ship)
    ==
  ++  policy-diff
    ^-  $-(json diff:^policy)
    %-  of
    :~  invite+invite-policy-diff
        open+open-policy-diff
        replace+policy
    ==
  ::
  ++  remove-group
    |=  =json
    ^-  [resource ~]
    ?>  ?=(%o -.json)
    =/  rid=resource
      (dejs:resource (~(got by p.json) 'resource'))
    [rid ~]
  ::
  ++  expose
    |=  =json
    ^-  [resource ~]
    ?>  ?=(%o -.json)
    =/  rid=resource
      (dejs:resource (~(got by p.json) 'resource'))
    [rid ~]
  ::
  ++  add-group
    %-  ot
    :~  resource+dejs:resource
        policy+policy
        hidden+bo
    ==
  ++  add-members
    %-  ot
    :~  resource+dejs:resource
        ships+(as ship)
    ==
  ++  remove-members
    ^-  $-(json [resource (set ^ship)])
    %-  ot
    :~  resource+dejs:resource
        ships+(as ship)
    ==
  ++  add-tag
    %-  ot
    :~  resource+dejs:resource
        tag+tag
        ships+(as ship)
    ==
  ++  remove-tag
    %-  ot
    :~  resource+dejs:resource
        tag+tag
        ships+(as ship)
    ==
  ++  change-policy
    %-  ot
    :~  resource+dejs:resource
        diff+policy-diff
    ==
  --
--
