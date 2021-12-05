/-  *docket
|%
::
++  mime
  |%
  +$  draft
    $:  title=(unit @t)
        info=(unit @t)
        color=(unit @ux)
        glob-http=(unit [=url hash=@uvH])
        glob-ames=(unit [=ship hash=@uvH])
        base=(unit term)
        site=(unit path)
        image=(unit url)
        version=(unit version)
        website=(unit url)
        license=(unit cord)
    ==
  ::
  ++  finalize
    |=  =draft
    ^-  (unit docket)
    ?~  title.draft  ~
    ?~  info.draft  ~
    ?~  color.draft  ~
    ?~  version.draft  ~
    ?~  website.draft  ~
    ?~  license.draft  ~
    =/  href=(unit href)
      ?^  site.draft  `[%site u.site.draft]
      ?~  base.draft  ~
      ?^  glob-http.draft
        `[%glob u.base hash.u.glob-http %http url.u.glob-http]:draft
      ?~  glob-ames.draft
        ~
      `[%glob u.base hash.u.glob-ames %ames ship.u.glob-ames]:draft
    ?~  href  ~
    =,  draft
    :-  ~
    :*  %1
        u.title
        u.info
        u.color
        u.href
        image
        u.version
        u.website
        u.license
    ==
  ::
  ++  from-clauses
    =|  =draft
    |=  cls=(list clause)
    ^-  (unit docket)
    =*  loop  $
    ?~  cls  (finalize draft)
    =*  clause  i.cls
    =.  draft
      ?-  -.clause
        %title  draft(title `title.clause)
        %info   draft(info `info.clause)
        %color  draft(color `color.clause)
        %glob-http   draft(glob-http `[url hash]:clause)
        %glob-ames   draft(glob-ames `[ship hash]:clause)
        %base   draft(base `base.clause)
        %site   draft(site `path.clause)
        %image  draft(image `url.clause)
        %version  draft(version `version.clause)
        %website  draft(website `website.clause)
        %license  draft(license `license.clause)
      ==
    loop(cls t.cls)
  ::
  ++  to-clauses
    |=  d=docket
    ^-  (list clause)
    %-  zing
    :~  :~  title+title.d
            info+info.d
            color+color.d
            version+version.d
            website+website.d
            license+license.d
        ==
        ?~  image.d  ~  ~[image+u.image.d]
        ?:  ?=(%site -.href.d)  ~[site+path.href.d]
        =/  ref=glob-reference  glob-reference.href.d
        :~  base+base.href.d
            ?-  -.location.ref
              %http  [%glob-http url.location.ref hash.ref]
              %ames  [%glob-ames ship.location.ref hash.ref]
    ==  ==  ==
  ::
  ++  spit-clause
    |=  =clause
    ^-  tape
    %+  weld  "  {(trip -.clause)}+"
    ?+  -.clause  "'{(trip +.clause)}'"
      %color  (scow %ux color.clause)
      %site   (spud path.clause)
    ::
        %glob-http
      "['{(trip url.clause)}' {(scow %uv hash.clause)}]"
    ::
        %glob-ames
      "[{(scow %p ship.clause)} {(scow %uv hash.clause)}]"
    ::
        %version
      =,  version.clause
      "[{(scow %ud major)} {(scow %ud minor)} {(scow %ud patch)}]"
    ==
  ::
  ++  spit-docket
    |=  dock=docket
    ^-  tape
    ;:  welp
      ":~\0a"
      `tape`(zing (join "\0a" (turn (to-clauses dock) spit-clause)))
      "\0a=="
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ::
  ++  charge-update
    |=  u=^charge-update
    ^-  json
    %+  ob  -.u
    ^-  json
    ?-  -.u
      %del-charge  (co desk.u)
    ::
        %initial
      :-  %o
      %-  ~(run by initial.u)
      |=  c=^charge
      ^-  json
      (charge c)
    ::
        %add-charge
      %-  pr
      :~  desk+(co desk.u)
          charge+(charge charge.u)
      ==
    ==
  ::
  ++  num
    |=  a=@u
    ^-  tape
    (a-co:^co a)
  ::
  ++  version
    |=  v=^version
    ^-  json
    %-  ta
    "{(num major.v)}.{(num minor.v)}.{(num patch.v)}"
  ::
  ++  href
    |=  h=^href
    %+  ob  -.h
    ?-    -.h
        %site  (pa path.h)
        %glob
      %-  pr
      :~  base+(co base.h)
          glob-reference+(glob-reference glob-reference.h)
      ==
    ==
  ::
  ++  glob-reference
    |=  ref=^glob-reference
    %-  pr
    :~  hash+(nh %uv hash.ref)
        location+(glob-location location.ref)
    ==
  ::
  ++  glob-location
    |=  loc=^glob-location
    ^-  json
    %+  ob  -.loc
    ?-  -.loc
      %http  (co url.loc)
      %ames  (hp ship.loc)
    ==
  ::
  ++  charge
    |=  c=^charge
    ^-  json
    %-  pr
    :~  title+(co title.docket.c)
        info+(co info.docket.c)
        color+(nh %ux color.docket.c)
        href+(href href.docket.c)
        image+(un image.docket.c co)
        version+(version version.docket.c)
        license+(co license.docket.c)
        website+(co website.docket.c)
        chad+(chad chad.c)
    ==
  ::
  ++  chad
    |=  c=^chad
    ^-  json
    %+  ob  -.c
    ?+  -.c  ~
      %hung   (co err.c)
    ==
  --
--
