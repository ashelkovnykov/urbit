/-  sur=graph-store, pos=post, pull-hook, hark=hark-store
/+  res=resource, migrate
=<  [sur .]
=<  [pos .]
=,  sur
=,  pos
|%
++  hark-content
  |=  =content
  ^-  content:hark
  ?-  -.content
    %text       content
    %mention    ship+ship.content
    %url        text+url.content
    %code       text+'A code excerpt'
    %reference  text+'A reference'
  ==
::
++  hark-contents
  |=  cs=(list content) 
  (turn cs hark-content)
++  orm      ((on atom node) gth)
++  orm-log  ((on time logged-update) gth)
::
++  enjs
  =,  enjs:format
  |%
  ::
  ++  signatures
    |=  s=^signatures
    ^-  json
    (st s signature)
  ::
  ++  signature
    |=  s=^signature
    ^-  json
    %-  pr
    :~  [%signature (nh %ux p.s)]
        [%ship (hl q.s)]
        [%life (nu r.s)]
    ==
  ::
  ++  index
    |=  ind=^index
    ^-  json
    :-  %s
    ?:  =(~ ind)  '/'
    %+  roll  ind
    |=  [cur=@ acc=@t]
    (rap 3 acc '/' (crip (a-co:^co cur)) ~)
  ::
  ++  uid
    |=  u=^uid
    ^-  json
    %-  pr
    :~  [%resource (enjs:res resource.u)]
        [%index (index index.u)]
    ==
  ::
  ++  content
    |=  c=^content
    ^-  json
    ?-  -.c
        %mention    (ob %mention (hl ship.c))
        %text       (ob %text (co text.c))
        %url        (ob %url (co url.c))
        %reference  (ob %reference (reference +.c))
        %code
      %+  ob  %code
      %-  pr
      :~  [%expression (co expression.c)]
        ::
          :-  %output
          ::  virtualize output rendering, +tank:enjs:format might crash
          ::
          =/  result=(each json tang)
            (mule |.((ls output.c tk)))
          ?-  -.result
            %&  p.result
            %|  a+[a+[%s '[[output rendering error]]']~]~
          ==
        ::
      ==
    ==
  ::
  ++  reference
    |=  ref=^reference
    |^
    %+  ob  -.ref
    ?-  -.ref
      %graph  (graph +.ref)
      %group  (enjs-path:res +.ref)
      %app    (app +.ref)
    ==
    ::
    ++  graph
      |=  [grp=res gra=res idx=^index]
      %-  pr
      :~  graph+(enjs-path:res gra)
          group+(enjs-path:res grp)
          index+(index idx)
      ==
    ::
    ++  app
      |=  [s=ship =desk p=path]
      %-  pr
      :~  ship+(hp s)
          desk+(co desk)
          path+(pa p)
      ==
    --
  ::
  ++  maybe-post
    |=  mp=^maybe-post
    ^-  json
    ?-  -.mp
      %&  (post p.mp)
      %|  (nh %ux p.mp)
    ==
  ::
  ++  post
    |=  p=^post
    ^-  json
    %-  pr
    :~  [%author (hl author.p)]
        [%index (index index.p)]
        [%time-sent (ms time-sent.p)]
        [%contents (ls contents.p content)]
        [%hash (un hash.p (cury nh %ux))]
        [%signatures (signatures signatures.p)]
    ==
  ::
  ++  update
    |=  upd=^update
    ^-  json
    |^  (ob %graph-update (ob (encode q.upd)))
    ::
    ++  encode
      |=  upd=action
      ^-  [cord json]
      ?-  -.upd
          %add-graph
        :-  %add-graph
        %-  pr
        :~  [%resource (enjs:res resource.upd)]
            [%graph (graph graph.upd)]
            [%mark (un mark.upd co)]
            [%overwrite (bo overwrite.upd)]
        ==
      ::
          %remove-graph
        [%remove-graph (enjs:res resource.upd)]
      ::
          %add-nodes
        :-  %add-nodes
        %-  pr
        :~  [%resource (enjs:res resource.upd)]
            [%nodes (nodes nodes.upd)]
        ==
      ::
          %remove-posts
        :-  %remove-posts
        %-  pr
        :~  [%resource (enjs:res resource.upd)]
            [%indices (st indices.upd index)]
        ==
      ::
          %add-signatures
        :-  %add-signatures
        %-  pr
        :~  [%uid (uid uid.upd)]
            [%signatures (signatures signatures.upd)]
        ==
      ::
          %remove-signatures
        :-  %remove-signatures
        %-  pr
        :~  [%uid (uid uid.upd)]
            [%signatures (signatures signatures.upd)]
        ==
      ::
          %add-tag
        :-  %add-tag
        %-  pr
        :~  [%term (co term.upd)]
            [%uid (uid uid.upd)]
        ==
      ::
          %remove-tag
        :-  %remove-tag
        %-  pr
        :~  [%term (co term.upd)]
            [%uid (uid uid.upd)]
        ==
      ::
          %archive-graph
        [%archive-graph (enjs:res resource.upd)]
      ::
          %unarchive-graph
        [%unarchive-graph (enjs:res resource.upd)]
      ::
          %keys
        [%keys (st resources.upd enjs:res)]
      ::
          %tags
        [%tags (st tags.upd co)]
      ::
          %run-updates
        [%run-updates ~]
      ::
          %tag-queries
        :-  %tag-queries
        :-  %o
        %-  ~(run by tag-queries.upd)
        |=  uids=(set ^uid)
        ^-  json
        (st uids uid)
      ==
    ::
    ++  graph
      |=  g=^graph
      ^-  json
      %-  pr
      %+  turn  (tap:orm g)
      |=  [a=atom n=^node]
      ^-  [@t json]
      [(crip (a-co:^co a)) (node n)]
    ::
    ++  node
      |=  n=^node
      ^-  json
      %-  pr
      :~  [%post (maybe-post post.n)]
          :-  %children
          ?-  -.children.n
              %empty  ~
              %graph  (graph +.children.n)
          ==
      ==
    ::
    ++  nodes
      |=  m=(map ^index ^node)
      ^-  json
      :-  %o
      ^-  (map @t json)
      %-  ~(run in m)
      |=  [n=^index o=^node]
      ^-  [@t json]
      :_  (node o)
      =/  idx  (index n)
      ?>  ?=(%s -.idx)
      p.idx
    ::
    --
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  update
    |=  jon=json
    ^-  ^update
    :-  *time
    ^-  action
    =<  (decode jon)
    |%
    ++  decode
      %-  of
      :~  [%add-nodes add-nodes]
          [%remove-posts remove-posts]
          [%add-signatures add-signatures]
          [%remove-signatures remove-signatures]
        ::
          [%add-graph add-graph]
          [%remove-graph remove-graph]
        ::
          [%add-tag add-tag]
          [%remove-tag remove-tag]
        ::
          [%archive-graph archive-graph]
          [%unarchive-graph unarchive-graph]
          [%run-updates run-updates]
        ::
          [%keys keys]
          [%tags tags]
          [%tag-queries tag-queries]
      ==
    ::
    ++  add-graph
      %-  ot
      :~  [%resource dejs:res]
          [%graph graph]
          [%mark (mu so)]
          [%overwrite bo]
      ==
    ::
    ++  graph
      |=  a=json
      ^-  ^graph
      =/  or-mp  ((on atom ^node) gth)
      (gas:or-mp ~ ~(tap by ((op dem node) a)))
    ::
    ++  remove-graph  (ot [%resource dejs:res]~)
    ++  archive-graph  (ot [%resource dejs:res]~)
    ++  unarchive-graph  (ot [%resource dejs:res]~)
    ::
    ++  add-nodes
      %-  ot
      :~  [%resource dejs:res]
          [%nodes nodes]
      ==
    ::
    ++  nodes  (op ;~(pfix fas (more fas dem)) node)
    ::
    ++  node
      %-  ot
      :~  [%post maybe-post]
          [%children internal-graph]
      ==
    ::
    ++  internal-graph
      |=  jon=json
      ^-  ^internal-graph
      ?~  jon
        [%empty ~]
      [%graph (graph jon)]
    ::
    ++  maybe-post
      |=  jon=json
      ^-  ^maybe-post
      ?~  jon    !!
      ?+  -.jon  !!
        %n  [%| (nx jon)]
        %o  [%& (post jon)]
      ==
    ::
    ++  post
      %-  ot
      :~  [%author sp]
          [%index index]
          [%time-sent di]
          [%contents (ar content)]
          [%hash (mu (su hex))]
          [%signatures (as signature)]
      ==
    ::
    ++  content
      %-  of
      :~  [%mention sp]
          [%text so]
          [%url so]
          [%reference reference]
          [%code eval]
      ==
    ::
    ++  reference
      |^
      %-  of
      :~  graph+graph
          group+dejs-path:res
          app+app
      ==
      ::
      ++  graph
        %-  ot
        :~  group+dejs-path:res
            graph+dejs-path:res
            index+index
        ==
      ::
      ++  app
        %-  ot
        :~  ship+sp
            desk+so
            path+pa
        ==
      --
    ::
    ++  tang 
      |=  jon=^json
      ^-  ^tang
      ?>  ?=(%a -.jon)
      %-  zing
      %+  turn
        p.jon
      |=  jo=^json
      ^-  (list tank)
      ?>  ?=(%a -.jo)
      %+  turn
        p.jo
      |=  j=^json
      ?>  ?=(%s -.j)
      ^-  tank
      leaf+(trip p.j)
    ::
    ++  eval
      %-  ot
      :~  expression+so
          output+tang
      ==
    ::
    ++  remove-posts
      %-  ot
      :~  [%resource dejs:res]
          [%indices (as index)]
      ==
    ::
    ++  add-signatures
      %-  ot
      :~  [%uid uid]
          [%signatures (as signature)]
      ==
    ::
    ++  remove-signatures
      %-  ot
      :~  [%uid uid]
          [%signatures (as signature)]
      ==
    ::
    ++  signature
      %-  ot
      :~  [%hash (su hex)]
          [%ship sp]
          [%life nu]
      ==
    ::
    ++  uid
      %-  ot
      :~  [%resource dejs:res]
          [%index index]
      ==
    ::
    ++  index  (su ;~(pfix fas (more fas dem)))
    ::
    ++  add-tag
      %-  ot
      :~  [%term so]
          [%uid uid]
      ==
    ::
    ++  remove-tag
      %-  ot
      :~  [%term so]
          [%uid uid]
      ==
    ::
    ++  keys
      |=  =json
      *resources
    ::
    ++  tags
      |=  =json
      *(set term)
    ::
    ++  tag-queries
      |=  =json
      *^tag-queries
    ::
    ++  run-updates
      |=  a=json
      ^-  [resource update-log]
      [*resource *update-log]
    --
  --
::
++  create
  |_  [our=ship now=time]
  ++  post
    |=  [=index contents=(list content)]
    ^-  ^post
    :*  our
        index
        now
        contents
        ~
        *signatures
    ==
  --
::
++  upgrade
  |%
  ::
  ::  +two
  ::
  ++  marked-graph-to-two
    |=  [=graph:one m=(unit mark)]
    [(graph-to-two graph) m]
  ::
  ++  graph-to-two
    |=  =graph:one
    (graph:(upgrade ,post:one ,maybe-post:two) graph post-to-two)
  ::
  ++  post-to-two
    |=  p=post:one
    ^-  maybe-post:two
    [%& p]
  ::
  ::
  ::  +one
  ::
  ++  update-log-to-one
    |=  =update-log:zero
    ^-  update-log:one
    %+  gas:orm-log:one  *update-log:one
    %+  turn  (tap:orm-log:zero update-log)
    |=  [=time =logged-update:zero]
    ^-  [^time logged-update:one]
    :-  time
    :-  p.logged-update  
    (logged-update-to-one q.logged-update)
  ::
  ++  logged-update-to-one
    |=  upd=logged-update-0:zero
    ^-  logged-action:one
    ?+  -.upd  upd
      %add-graph  upd(graph (graph-to-one graph.upd))
      %add-nodes  upd(nodes (~(run by nodes.upd) node-to-one))
    ==
  ::
  ++  node-to-one
    |=  =node:zero
    (node:(upgrade ,post:zero ,post:one) node post-to-one)
  ::
  ++  graph-to-one
    |=  =graph:zero
    (graph:(upgrade ,post:zero ,post:one) graph post-to-one)
  ::
  ++  marked-graph-to-one
    |=  [=graph:zero m=(unit mark)]
    [(graph-to-one graph) m]
  ::
  ++  post-to-one
    |=  p=post:zero
    ^-  post:one
    p(contents (contents-to-one contents.p))
  ::
  ++  contents-to-one
    |=  cs=(list content:zero)
    ^-  (list content:one)
    %+  murn  cs
    |=  =content:zero
    ^-  (unit content:one)
    ?:  ?=(%reference -.content)  ~
    `content
  ::
  ++  upgrade
    |*  [in-pst=mold out-pst=mold]
    =>
      |%
      ++  in-orm
        ((on atom in-node) gth)
      +$  in-node
        [post=in-pst children=in-internal-graph]
      +$  in-graph
        ((mop atom in-node) gth)
      +$  in-internal-graph
        $~  [%empty ~]
        $%  [%graph p=in-graph]
            [%empty ~]
        ==
      ::
      ++  out-orm
        ((on atom out-node) gth)
      +$  out-node
        [post=out-pst children=out-internal-graph]
      +$  out-graph
        ((mop atom out-node) gth)
      +$  out-internal-graph
        $~  [%empty ~]
        $%  [%graph p=out-graph]
            [%empty ~]
        ==
      --
    |%
    ::
    ++  graph
      |=  $:  gra=in-graph
              fn=$-(in-pst out-pst)
          ==
      ^-  out-graph
      %+  gas:out-orm  *out-graph
      ^-  (list [atom out-node])
      %+  turn  (tap:in-orm gra)
      |=  [a=atom n=in-node]
      ^-  [atom out-node]
      [a (node n fn)]
    ::
    ++  node
      |=  [nod=in-node fn=$-(in-pst out-pst)]
      ^-  out-node
      :-  (fn post.nod)
      ^-  out-internal-graph
      ?:  ?=(%empty -.children.nod)
        [%empty ~]
      [%graph (graph p.children.nod fn)]
    --
  ::
  ++  zero-load
    :: =* infinitely recurses
    =,  store=zero
    =,  orm=orm:zero
    =,  orm-log=orm-log:zero
    |%
    ++  change-revision-graph
      |=  [=graph:store q=(unit mark)]
      ^-  [graph:store (unit mark)]
      |^
      :_  q
      ?+    q  graph
        [~ %graph-validator-link]     convert-links
        [~ %graph-validator-publish]  convert-publish
      ==
      ::
      ++  convert-links
        %+  gas:orm  *graph:store
        %+  turn  (tap:orm graph)
        |=  [=atom =node:store]
        ^-  [^atom node:store]
        ::  top-level
        ::
        :+  atom  post.node
        ?:  ?=(%empty -.children.node)
          [%empty ~]
        :-  %graph
        %+  gas:orm  *graph:store
        %+  turn  (tap:orm p.children.node)
        |=  [=^atom =node:store]
        ^-  [^^atom node:store]
        ::  existing comments get turned into containers for revisions
        ::
        :^    atom
            post.node(contents ~, hash ~)
          %graph
        %+  gas:orm  *graph:store
        :_  ~  :-  %0
        :_  [%empty ~]
        post.node(index (snoc index.post.node atom), hash ~)
      ::
      ++  convert-publish
        %+  gas:orm  *graph:store
        %+  turn  (tap:orm graph)
        |=  [=atom =node:store]
        ^-  [^atom node:store]
        ::  top-level
        ::
        :+  atom  post.node
        ?:  ?=(%empty -.children.node)
          [%empty ~]
        :-  %graph
        %+  gas:orm  *graph:store
        %+  turn  (tap:orm p.children.node)
        |=  [=^atom =node:store]
        ^-  [^^atom node:store]
        ::  existing container for publish note revisions
        ::
        ?+    atom  !!
            %1  [atom node]
            %2
          :+  atom  post.node
          ?:  ?=(%empty -.children.node)
            [%empty ~]
          :-  %graph
          %+  gas:orm  *graph:store
          %+  turn  (tap:orm p.children.node)
          |=  [=^^atom =node:store]
          ^-  [^^^atom node:store]
          :+  atom  post.node(contents ~, hash ~)
          :-  %graph
          %+  gas:orm  *graph:store
          :_  ~  :-  %1
          :_  [%empty ~]
          post.node(index (snoc index.post.node atom), hash ~)
        ==
      --
    ::  
    ++  maybe-unix-to-da
      |=  =atom
      ^-  @
      ::  (bex 127) is roughly 226AD
      ?.  (lte atom (bex 127))
        atom
      (add ~1970.1.1 (div (mul ~s1 atom) 1.000))
    ::
    ++  convert-unix-timestamped-node
      |=  =node:store
      ^-  node:store
      =.  index.post.node
        (convert-unix-timestamped-index index.post.node)
      ?.  ?=(%graph -.children.node)
        node
      :+  post.node
        %graph
      (convert-unix-timestamped-graph p.children.node)
    ::
    ++  convert-unix-timestamped-index
      |=  =index:store
      (turn index maybe-unix-to-da)
    ::
    ++  convert-unix-timestamped-graph
      |=  =graph:store
      %+  gas:orm  *graph:store
      %+  turn
        (tap:orm graph)
      |=  [=atom =node:store]
      ^-  [^atom node:store]
      :-  (maybe-unix-to-da atom)
      (convert-unix-timestamped-node node)
    --
  --
++  import
  |=  [arc=* our=ship]
  ^-  (quip card:agent:gall [%5 network])
  |^
  =/  sty  [%5 (remake-network ;;(tree-network +.arc))]
  :_  sty
  %+  turn  ~(tap by graphs.sty)
  |=  [rid=resource =marked-graph]
  ^-  card:agent:gall
  ?:  =(our entity.rid)
    =/  =cage  [%push-hook-action !>([%add rid])]
    [%pass / %agent [our %graph-push-hook] %poke cage]
  (try-rejoin rid 0)
  ::
  +$  tree-network
    $:  graphs=tree-graphs
        tag-queries=(tree [term (tree uid)])
        update-logs=tree-update-logs
        archive=tree-graphs
        ~
    ==
  +$  tree-graphs          (tree [resource tree-marked-graph])
  +$  tree-marked-graph    [p=tree-graph q=(unit ^mark)]
  +$  tree-graph           (tree [atom tree-node])
  +$  tree-node            [post=tree-maybe-post children=tree-internal-graph]
  +$  tree-internal-graph
    $~  [%empty ~]
    $%  [%graph p=tree-graph]
        [%empty ~]
    ==
  +$  tree-update-logs     (tree [resource tree-update-log])
  +$  tree-update-log      (tree [time tree-logged-update])
  +$  tree-logged-update
    $:  p=time
        $=  q
        $%  [%add-graph =resource =tree-graph mark=(unit ^mark) ow=?]
            [%add-nodes =resource nodes=(tree [index tree-node])]
            [%remove-posts =resource indices=(tree index)]
            [%add-signatures =uid signatures=tree-signatures]
            [%remove-signatures =uid signatures=tree-signatures]
        ==
    ==
  +$  tree-signatures      (tree signature)
  +$  tree-maybe-post      (each tree-post hash)
  +$  tree-post
    $:  author=ship
        =index
        time-sent=time
        contents=(list content)
        hash=(unit hash)
        signatures=tree-signatures
    ==
  ::
  ++  remake-network
    |=  t=tree-network
    ^-  network
    :*  (remake-graphs graphs.t)
        (remake-jug:migrate tag-queries.t)
        (remake-update-logs update-logs.t)
        (remake-graphs archive.t)
        ~
    ==
  ::
  ++  remake-graphs
    |=  t=tree-graphs
    ^-  graphs
    %-  remake-map:migrate
    (~(run by t) remake-marked-graph)
  ::
  ++  remake-marked-graph
    |=  t=tree-marked-graph
    ^-  marked-graph
    [(remake-graph p.t) q.t]
  ::
  ++  remake-graph
    |=  t=tree-graph
    ^-  graph
    %+  gas:orm  *graph
    %+  turn  ~(tap by t)
    |=  [a=atom tn=tree-node]
    ^-  [atom node]
    [a (remake-node tn)]
  ::
  ++  remake-internal-graph
    |=  t=tree-internal-graph
    ^-  internal-graph
    ?:  ?=(%empty -.t)
      [%empty ~]
    [%graph (remake-graph p.t)]
  ::
  ++  remake-node
    |=  t=tree-node
    ^-  node
    :-  (remake-post post.t)
    (remake-internal-graph children.t)
  ::
  ++  remake-update-logs
    |=  t=tree-update-logs
    ^-  update-logs
    %-  remake-map:migrate
    (~(run by t) remake-update-log)
  ::
  ++  remake-update-log
    |=  t=tree-update-log
    ^-  update-log
    =/  ulm  ((on time logged-update) gth)
    %+  gas:ulm  *update-log
    %+  turn  ~(tap by t)
    |=  [=time tlu=tree-logged-update]
    ^-  [^time logged-update]
    [time (remake-logged-update tlu)]
  ::
  ++  remake-logged-update
    |=  t=tree-logged-update
    ^-  logged-update
    :-  p.t
    ?-  -.q.t
        %add-graph
      :*  %add-graph
          resource.q.t
          (remake-graph tree-graph.q.t)
          mark.q.t
          ow.q.t
      ==
    ::
        %add-nodes
      :-  %add-nodes
      :-  resource.q.t
      %-  remake-map:migrate
      (~(run by nodes.q.t) remake-node)
    ::
        %remove-posts
      [%remove-posts resource.q.t (remake-set:migrate indices.q.t)]
    ::
        %add-signatures
      [%add-signatures uid.q.t (remake-set:migrate signatures.q.t)]
    ::
        %remove-signatures
      [%remove-signatures uid.q.t (remake-set:migrate signatures.q.t)]
    ==
  ::
  ++  remake-post
    |=  t=tree-maybe-post
    ^-  maybe-post
    ?-  -.t
      %|  t
      %&  t(signatures.p (remake-set:migrate signatures.p.t))
    ==
  ::
  ++  try-rejoin
    |=  [rid=resource nack-count=@]
    ^-  card:agent:gall
    =/  res-path  (en-path:res rid)
    =/  wire  [%try-rejoin (scot %ud nack-count) res-path]
    =/  =cage  
      :-  %pull-hook-action 
      !>  ^-  action:pull-hook
      [%add [entity .]:rid]
    [%pass wire %agent [our %graph-pull-hook] %poke cage]
  --
--
