/-  sur=metadata-store
/+  resource
^?
=<  [. sur]
=,  sur
|%
++  enjs
  =,  enjs:format
  |%
  ::
  ++  initial-group
    |=  [group=resource assocs=^associations]
    %-  pr
    :~  group+(enjs-path:resource group)
        associations+(associations assocs)
    ==
  ::
  ++  associations
    |=  =^associations
    ^-  json
    :-  %o
    ^-  (map @t json)
    %-  ~(run in associations)
    |=  [=md-resource [group=resource =^metadatum]]
    :-  %:  rap  3
            (spat (en-path:resource group))
            '/'
            app-name.md-resource
            (spat (en-path:resource resource.md-resource))
            ~
        ==
    %-  pr
    :~  [%group (enjs-path:resource group)]
        [%app-name (co app-name.md-resource)]
        [%resource (enjs-path:resource resource.md-resource)]
        [%metadata (^metadatum metadatum)]
    ==
  ::
  ++  edit-field
    |=  edt=^edit-field
    ^-  json
    %+  ob  -.edt
    ?-  -.edt
      %color                                (nh %ux color.edt)
      ?(%title %description %picture %vip)  (co +.edt)
      ?(%preview %hidden)                   (bo +.edt)
    ==
  ::
  ++  metadatum
    |=  met=^metadatum
    ^-  json
    %-  pr
    :~  [%title (co title.met)]
        [%description (co description.met)]
        [%color (nh %ux color.met)]
        [%date-created (nh %da date-created.met)]
        [%creator (hp creator.met)]
      ::
        :-  %config
        ?+    -.config.met  o+~
            %graph
          (ob %graph (co module.config.met))
        ::
            %group
          %+  ob  %group
          ?~  feed.config.met  ~
          ?~  u.feed.config.met  o+~
          %-  pr
          :~  [%app-name (co app-name.u.u.feed.config.met)]
              [%resource (enjs-path:resource resource.u.u.feed.config.met)]
          ==
        ==
      ::
        [%picture (co picture.met)]
        [%preview (bo preview.met)]
        [%hidden (bo hidden.met)]
        [%vip (co vip.met)]
    ==
  ::
  ++  update
    |=  upd=^update
    ^-  json
    %+  ob  %metadata-update
    %-  ob
    ?-  -.upd
    ::
        %add
      :-  %add
      %-  pr
      :~  [%group (enjs-path:resource group.upd)]
          [%app-name (co app-name.resource.upd)]
          [%resource (enjs-path:resource resource.resource.upd)]
          [%metadata (metadatum metadatum.upd)]
      ==
    ::
        %edit
      :-  %edit
      %-  pr
      :~  [%group (enjs-path:resource group.upd)]
          [%app-name (co app-name.resource.upd)]
          [%resource (enjs-path:resource resource.resource.upd)]
          [%edit (edit-field edit-field.upd)]
      ==
    ::
        %updated-metadata
      :-  %add
      %-  pr
      :~  [%group (enjs-path:resource group.upd)]
          [%app-name (co app-name.resource.upd)]
          [%resource (enjs-path:resource resource.resource.upd)]
          [%metadata (metadatum metadatum.upd)]
      ==
    ::
        %remove
      :-  %remove
      %-  pr
      :~  [%group (enjs-path:resource group.upd)]
          [%app-name (co app-name.resource.upd)]
          [%resource (enjs-path:resource resource.resource.upd)]
      ==
    ::
        %associations
      [%associations (associations associations.upd)]
    ::
        %initial-group
      [%initial-group (initial-group +.upd)]
    ==
  ::
  ++  hook-update
    |=  upd=^hook-update
    %+  ob  %metadata-hook-update
    %+  ob  -.upd
    %-  pr
    ?-  -.upd
    ::
        %preview
      :~  [%group (enjs-path:resource group.upd)]
          [%channels (associations channels.upd)]
          [%members (nu members.upd)]
          [%channel-count (nu channel-count.upd)]
          [%metadata (metadatum metadatum.upd)]
      ==
    ::
        %req-preview
      ~[group+(enjs-path:resource group.upd)]
    ==
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  action
    %-  of
    :~  [%add add]
        [%remove remove]
        [%initial-group initial-group]
        [%edit edit]
    ==
  ::
  ++  edit
    %-  ot
    :~  [%group dejs-path:resource]
        [%resource md-resource]
        [%edit edit-field]
    ==
  ::
  ++  edit-field
    %-  of
    :~  [%title so]
        [%description so]
        [%color nu]
        [%picture so]
        [%preview bo]
        [%hidden bo]
        [%vip vip]
    ==
  ::
  ++  initial-group
    |=  json
    [*resource *associations]
  ::
  ++  add
    %-  ot
    :~  [%group dejs-path:resource]
        [%resource md-resource]
        [%metadata metadatum]
    ==
  ++  remove
    %-  ot
    :~  [%group dejs-path:resource]
        [%resource md-resource]
    ==
  ::
  ++  nu
    |=  jon=json
    ?>  ?=([%s *] jon)
    (rash p.jon hex)
  ::
  ++  vip
    %-  su
    %-  perk
    :~  %reader-comments
        %member-metadata
        %admin-feed
        %host-feed
        %$
    ==
  ::
  ++  metadatum
    ^-  $-(json ^metadatum)
    %-  ot
    :~  [%title so]
        [%description so]
        [%color nu]
        [%date-created (se %da)]
        [%creator (su ;~(pfix sig fed:ag))]
        [%config config]
        [%picture so]
        [%preview bo]
        [%hidden bo]
        [%vip vip]
    ==
  ::
  ++  config
    |=  jon=^json
    ^-  md-config
    ?~  jon
      [%group ~]
    ?>  ?=(%o -.jon)
    ?:  (~(has by p.jon) %graph)
      =/  mod
        (~(got by p.jon) %graph)
      ?>  ?=(%s -.mod)
      [%graph p.mod]
    =/  jin=json
      (~(got by p.jon) %group)
    :+  %group  ~
    ?~  jin
      ~  
    ?>  ?=(%o -.jin)
    ?.  ?&  (~(has by p.jin) 'app-name')
            (~(has by p.jin) 'resource')
        ==
      ~
    =/  app-name=^json  (~(got by p.jin) 'app-name')
    ?>  ?=(%s -.app-name)
    :+  ~
      p.app-name
    =/  res=^json  (~(got by p.jin) 'resource')
    (dejs-path:resource res)
  ::
  ++  md-resource
    ^-  $-(json ^md-resource)
    %-  ot
    :~  [%app-name so]
        [%resource dejs-path:resource]
    ==
  --
--
