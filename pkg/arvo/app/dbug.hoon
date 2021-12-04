::  dbug: debug dashboard server
::
/-  spider
/+  server, default-agent, verb, dbug
::
|%
+$  state-0  [%0 passcode=(unit @t)]
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
::
%+  verb  |
%-  agent:dbug
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this  .
      do    ~(. +> bowl)
      def   ~(. (default-agent this %|) bowl)
  ::
  ++  on-init
    ^-  (quip card _this)
    :_  this
    [%pass /connect %arvo %e %connect [~ /'~debug'] dap.bowl]~
  ::
  ++  on-save  !>(state)
  ::
  ++  on-load
    |=  old=vase
    ^-  (quip card _this)
    [~ this(state !<(state-0 old))]
  ::
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?.  ?=([%http-response *] path)
      (on-watch:def path)
    [~ this]
  ::
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?:  ?=(%noun mark)
      ?>  (team:title [our src]:bowl)
      =/  code  !<((unit @t) vase)
      =/  msg=tape
        ?~  code
          "Removing passcode access for debug interface."
        """
        Enabling passcode access for debug interface. Anyone with this code can
         view your applications' state, the people you've talked to, etc. Only
         share with people you trust. To disable, run :dbug ~
        """
      %-  (slog leaf+msg ~)
      [~ this(passcode code)]
    ?.  ?=(%handle-http-request mark)
      (on-poke:def mark vase)
    =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
    :_  this
    %+  give-simple-payload:app:server  eyre-id
    %+  authorize-http-request:do  inbound-request
    handle-http-request:do
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    ?.  ?=([%eyre %bound *] sign-arvo)
      (on-arvo:def wire sign-arvo)
    ~?  !accepted.sign-arvo
      [dap.bowl "bind rejected!" binding.sign-arvo]
    [~ this]
  ::
  ++  on-peek   on-peek:def
  ++  on-leave  on-leave:def
  ++  on-agent  on-agent:def
  ++  on-fail   on-fail:def
  --
::
|_  =bowl:gall
::
::  serving
::
++  authorize-http-request
  =,  server
  ::  if no passcode configured, only allow host ship to view
  ::
  ?~  passcode  require-authorization:app
  |=  $:  =inbound-request:eyre
          handler=$-(inbound-request:eyre simple-payload:http)
      ==
  ?:  authenticated.inbound-request
    (handler inbound-request)
  ::  else, allow randos access,
  ::  on the condition they provide a correct ?passcode= url parameter
  ::
  =;  pass=(unit @t)
    ?:  =(passcode pass)
      (handler inbound-request)
    (require-authorization:app inbound-request handler)
  =/  from-url=(unit @t)
    =-  (~(get by -) 'passcode')
    %-  ~(gas by *(map @t @t))
    args:(parse-request-line url.request.inbound-request)
  ?^  from-url  from-url
  ::  try the referer field instead
  ::
  =/  ref-url=(unit @t)
    (get-header:http 'referer' header-list.request.inbound-request)
  ?~  ref-url  ~
  ?~  (find "passcode={(trip u.passcode)}" (trip u.ref-url))  ~
  passcode
::
++  handle-http-request
  =,  server
  |=  =inbound-request:eyre
  ^-  simple-payload:http
  =/  =request-line
    %-  parse-request-line
    url.request.inbound-request
  =*  req-head  header-list.request.inbound-request
  ::TODO  handle POST
  ?.  ?=(%'GET' method.request.inbound-request)
    not-found:gen
  (handle-get-request req-head request-line)
::
++  handle-get-request
  =,  server
  |=  [headers=header-list:http request-line]
  ^-  simple-payload:http
  =?  site  ?=([%'~debug' *] site)  t.site
  ?~  ext
    $(ext `%html, site [%index ~]) ::NOTE  hack
  ::  serve dynamic session.js
  ::
  ?:  =([/js/session `%js] [site ext])
    %-  js-response:gen
    %-  as-octt:mimes:html
    "window.ship = '{(slag 1 (scow %p our.bowl))}';"
  ::  if not json, serve static file
  ::
  ?.  ?=([~ %json] ext)
    =/  file=(unit octs)
      (get-file-at /app/debug site u.ext)
    ?~  file  not-found:gen
    ?+  u.ext  not-found:gen
      %html  (html-response:gen u.file)
      %js    (js-response:gen u.file)
      %css   (css-response:gen u.file)
      %png   (png-response:gen u.file)
    ==
  ::  get data matching the json and convert it
  ::
  =;  json=(unit json)
    ?~  json  not-found:gen
    (json-response:gen u.json)
  =,  enjs:format
  ?+  site  ~
    ::  /apps.json: {appname: running?}
    ::
      [%apps ~]
    %-  some
    %-  pairs
    %+  turn  all:apps
    |=  app=term
    [app (bool (running:apps app))]
  ::
    ::  /app/[appname]...
    ::
      [%app @ *]
    =*  app  i.t.site
    ::TODO  ?.  (dbugable:apps app)  ~
    =/  rest=^path  t.t.site
    ?+  rest  ~
      ::  /app/[appname].json: {state: }
      ::
        ~
      %-  some
      %-  pairs
      :~  :-  'simpleState'
          %-  tank
          =;  head=(^unit ^tank)
            (fall head leaf+"unversioned")
          ::  try to print the state version
          ::
          =/  version=(^unit vase)
            (slew 2 (state:apps app))
          ?~  version  ~
          ?.  ?=(%atom -.p.u.version)  ~
          `(sell u.version)
        ::
          :-  'subscriptions'
          %-  pairs
          =+  (subscriptions:apps app)
          |^  ~['in'^(incoming in) 'out'^(outgoing out)]
          ::
          ++  incoming
            |=  =bitt:gall
            ^-  json
            %+  list  ~(tap by bitt)
            |=  [d=duct [s=^ship p=^path]]
            %-  pairs
            :~  'duct'^(list d path)
                'ship'^(shil s)
                'path'^(path p)
            ==
          ::
          ++  outgoing
            |=  =boat:gall
            ^-  json
            %+  list  ~(tap by boat)
            |=  [[w=wire s=^ship t=term] [a=? p=^path]]
            %-  pairs
            :~  'wire'^(path w)
                'ship'^(shil s)
                'app'^(cord t)
                'acked'^(bool a)
                'path'^(path p)
            ==
          --
      ==
    ::
      ::  /app/[appname]/state.json
      ::  /app/[appname]/state/[query].json
      ::
        [%state ?(~ [@ ~])]
      %-  some
      %+  frond  %state
      %-  tank
      %+  state-at:apps  app
      ?~  t.rest  ~
      (slaw %t i.t.rest)
    ==
  ::
    ::  /spider.json
    ::
      [%spider %threads ~]
    %-  some
    ::  turn flat stack descriptors into object (tree) representing stacks
    ::
    |^  (tree-to-json build-thread-tree)
    ::
    +$  tree
      $~  ~
      (map tid:spider tree)
    ::
    ++  build-thread-tree
      %+  roll  tree:threads
      |=  [stack=(^list tid:spider) =tree]
      ?~  stack  tree
      %+  ~(put by tree)  i.stack
      %_  $
        stack  t.stack
        tree   (~(gut by tree) i.stack ~)
      ==
    ::
    ++  tree-to-json
      |=  =tree
      o+(~(run by tree) tree-to-json)
    --
  ::
    ::  /azimuth/status
  ::
    ::  /ames/peer.json
    ::
      [%ames %peer ~]
    =/  [known=(^list [^ship *]) alien=(^list [^ship *])]
      %+  skid  ~(tap by peers:v-ames)
      |=  [^ship kind=?(%alien %known)]
      ?=(%known kind)
    %-  some
    %-  pairs
    :~  'known'^(list known :(cork head ^ship shil))
        'alien'^(list alien :(cork head ^ship shil))
    ==
  ::
    ::  /ames/peer/[shipname].json
    ::
      [%ames %peer @ ~]
    =/  who=^ship
      (rash i.t.t.site fed:ag)
    %-  some
    =,  v-ames
    (peer-to-json (peer who))
  ::
    ::  /behn/timers.json
    ::
      [%behn %timers ~]
    %-  some
    %+  list  timers:v-behn
    |=  [date=@da =duct]
    %-  pairs
    :~  'date'^(time date)
        'duct'^(list duct path)
    ==
  ::
    ::  /clay/commits.json
    ::
      [%clay %commits ~]
    (some commits-json:v-clay)
  ::
    ::  /eyre/bindings.json
    ::
      [%eyre %bindings ~]
    %-  some
    %+  list  bindings:v-eyre
    =,  eyre
    |=  [binding =duct =action]
    %-  pairs
    :~  'location'^(cord (cat 3 (fall site '*') (spat path)))
        'action'^(render-action:v-eyre action)
    ==
  ::
    ::  /eyre/connections.json
    ::
      [%eyre %connections ~]
    %-  some
    %+  list  ~(tap by connections:v-eyre)
    |=  [=duct outstanding-connection:eyre]
    %-  pairs
    :~  'duct'^(list duct path)
        'action'^(render-action:v-eyre action)
      ::
        :-  'request'
        %-  pairs
        =,  inbound-request
        :~  'authenticated'^(bool authenticated)
            'secure'^(bool secure)
            'source'^(cord (scot %if +.address))
            :: ?-  -.address
            ::   %ipv4  %if
            ::   %ipv6  %is
            :: ==
        ==
      ::
        :-  'response'
        %-  pairs
        :~  'sent'^(numb bytes-sent)
          ::
            :-  'header'
            ?~  response-header  ~
            =,  u.response-header
            %-  pairs
            :~  'status-code'^(numb status-code)
              ::
                :-  'headers'
                %+  list  headers
                |=([k=@t v=@t] (cord :((cury cat 3) k ': ' v)))
            ==
        ==
    ==
  ::
    ::  /eyre/authentication.json
    ::
      [%eyre %authentication ~]
    %-  some
    %+  list
      %+  sort  ~(tap by sessions:auth-state:v-eyre)
      |=  [[@uv a=session:eyre] [@uv b=session:eyre]]
      (gth expiry-time.a expiry-time.b)
    |=  [cookie=@uv session:eyre]
    %-  pairs
    :~  'cookie'^(cord (end [3 4] (rsh [3 2] (scot %x (shax cookie)))))
        'expiry'^(time expiry-time)
        'channels'^(numb ~(wyt in channels))
    ==
  ::
    ::  /eyre/channels.json
    ::
      [%eyre %channels ~]
    %-  some
    =+  channel-state:v-eyre
    %+  list  ~(tap by session)
    |=  [key=@t channel:eyre]
    %-  pairs
    :~  'session'^(cord key)
        'connected'^(bool !-.state)
        'expiry'^?-(-.state %& (time date.p.state), %| ~)
        'next-id'^(numb next-id)
        'last-ack'^(time last-ack)
        'unacked'^(list (sort (turn ~(tap in events) head) dor) numb)
      ::
        :-  'subscriptions'
        %+  list  ~(tap by subscriptions)
        |=  [id=@ud [s=^ship app=term p=^path *]]
        %-  pairs
        :~  'id'^(numb id)
            'ship'^(shil s)
            'app'^(cord app)
            'path'^(path p)
            'unacked'^(numb (~(gut by unacked) id 0))
        ==
    ==
  ==
::
++  get-file-at
  |=  [base=path file=path ext=@ta]
  ^-  (unit octs)
  ?.  ?=(?(%html %css %js %png) ext)
    ~
  =/  =path
    :*  (scot %p our.bowl)
        q.byk.bowl
        (scot %da now.bowl)
        (snoc (weld base file) ext)
    ==
  ?.  .^(? %cu path)  ~
  %-  some
  %-  as-octs:mimes:html
  .^(@ %cx path)
::
::  applications
::
++  apps
  |%
  ++  all
    ^-  (list dude:gall)
    %-  zing
    ^-  (list (list dude:gall))
    %+  turn
      ~(tap in (scry (set desk) %cd %$ /))
    |=  =desk
    ^-  (list dude:gall)
    =-  (turn ~(tap in -) head)
    ;;  (set [dude:gall ?])  ::TODO  for some reason we need this?
    (scry (set [dude:gall ?]) %ge desk /)
  ::
  ++  running
    |=  app=term
    (scry ? %gu app ~)
  ::
  ++  dbugable
    |=  app=term
    ^-  ?
    !!  ::TODO  how to check if it supports the /dbug scries?
  ::
  ++  state
    |=  app=term
    ^-  vase
    (scry-dbug vase app /state)
  ::
  ++  state-at
    |=  [app=term what=(unit @t)]
    ^-  tank
    =/  state=vase  (state app)
    ?~  what  (sell state)
    =/  result=(each vase tang)
      %-  mule  |.
      %+  slap
        (slop state !>([bowl=bowl ..zuse]))
      (ream u.what)
    ?-  -.result
      %&  (sell p.result)
      %|  (head p.result)
    ==
  ::
  ++  subscriptions
    =,  gall
    |=  app=term
    ^-  [out=boat in=bitt]
    (scry-dbug ,[boat bitt] app /subscriptions)
  ::
  ++  scry-dbug
    |*  [=mold app=term =path]
    (scry mold %gx app (snoc `^path`[%dbug path] %noun))
  ::
  ::TODO  but why? we can't tell if it's on or not
  ++  poke-verb-toggle
    |=  app=term
    ^-  card
    (poke /verb/[app] app %verb !>(%loud))
  --
::
::  threads
::
++  threads
  |%
  ::NOTE  every (list tid:spider) represents a stack,
  ::      with a unique tid at the end
  ++  tree
    (scry (list (list tid:spider)) %gx %spider /tree/noun)
  ::
  ++  poke-kill
    |=  =tid:spider
    ^-  card
    (poke /spider/kill/[tid] %spider %spider-stop !>([tid |]))
  --
::
::  ames
::
++  v-ames
  |%
  ++  peers
    (scry (map ship ?(%alien %known)) %ax %$ /peers)
  ::
  ++  peer
    |=  who=ship
    (scry ship-state:ames %ax %$ /peers/(scot %p who))
  ::
  ++  peer-to-json
    =,  ames
    =,  enjs:format
    |=  =ship-state
    |^  ^-  json
        %+  frond  -.ship-state
        ?-  -.ship-state
          %alien  (alien +.ship-state)
          %known  (known +.ship-state)
        ==
    ::
    ++  alien
      |=  alien-agenda
      %-  pairs
      :~  'messages'^(numb (lent messages))
          'packets'^(numb ~(wyt in packets))
          'heeds'^(set heeds from-duct)
      ==
    ::
    ::  json for known peer is structured to closely match the peer-state type.
    ::  where an index is specified, the array is generally sorted by those.
    ::
    ::  { life: 123,
    ::    route: { direct: true, lane: 'something' },
    ::    qos: { kind: 'status', last-contact: 123456 },  // ms timestamp
    ::    flows: { forward: [snd, rcv, ...], backward: [snd, rcv, ...] }
    ::    ->  snd:
    ::        { bone: 123,  // index
    ::          duct: ['/paths', ...]
    ::          current: 123,
    ::          next: 123,
    ::          unsent-messages: [123, ...],  // size in bytes
    ::          queued-message-acks: [{
    ::            message-num: 123,  // index
    ::            ack: 'ok'
    ::          }, ...],
    ::          packet-pump-state: {
    ::            next-wake: 123456,  // ms timestamp
    ::            live: [{
    ::              message-num: 123,  // index
    ::              fragment-num: 123,  // index
    ::              num-fragments: 123,
    ::              last-sent: 123456,  //  ms timestamp
    ::              retries: 123,
    ::              skips: 123
    ::            }, ...],
    ::            metrics: {
    ::              rto: 123,  // seconds
    ::              rtt: 123,  // seconds
    ::              rttvar: 123,
    ::              ssthresh: 123,
    ::              num-live: 123,
    ::              cwnd: 123,
    ::              counter: 123
    ::            }
    ::          }
    ::        }
    ::    ->  rcv:
    ::        { bone: 123,  // index
    ::          duct: ['/paths', ...]  // index
    ::          last-acked: 123,
    ::          last-heard: 123,
    ::          pending-vane-ack: [123, ...],
    ::          live-messages: [{
    ::            message-num: 123,  // index
    ::            num-received: 122,
    ::            num-fragments: 123,
    ::            fragments: [123, ...]
    ::          }, ...],
    ::          nax: [123, ...]
    ::        }
    ::    nax: [{
    ::      bone: 123,  // index
    ::      duct: ['/paths', ...],
    ::      message-num: 123
    ::    }, ...],
    ::    heeds: [['/paths', ...] ...]
    ::  }
    ::
    ++  known
      |=  peer-state
      %-  pairs
      :~  'life'^(numb life)
        ::
          :-  'route'
          %+  unit  route
          |=  [direct=? =lane]
          ^-  json
          %-  pairs
          :~  'direct'^(bool direct)
            ::
              :-  'lane'
              ?-  -.lane
                %&  (shil p.lane)
              ::
                  %|
                %-  tape
                =/  ip=@if  (end [0 32] p.lane)
                =/  pt=@ud  (cut 0 [32 16] p.lane)
                "{(scow %if ip)}:{((d-co:co 1) pt)} ({(scow %ux p.lane)})"
              ==
          ==
        ::
          :-  'qos'
          %-  pairs
          :~  'kind'^(cord -.qos)
              'last-contact'^(time last-contact.qos)
          ==
        ::
          :-  'flows'
          |^  =/  mix=(^list flow)
                =-  (sort - dor)
                %+  welp
                  (turn ~(tap by snd) (tack %snd))
                (turn ~(tap by rcv) (tack %rcv))
              =/  [forward=(^list flow) backward=(^list flow)]
                %+  skid  mix
                |=  [=bone *]
                =(0 (mod bone 2))
              %-  pairs
              :~  'forward'^(list forward build)
                  'backward'^(list backward build)
              ==
          ::
          +$  flow
            $:  =bone
              ::
                $=  state
                $%  [%snd message-pump-state]
                    [%rcv message-sink-state]
                ==
            ==
          ::
          ++  tack
            |*  =term
            |*  [=bone =noun]
            [bone [term noun]]
          ::
          ++  build
            |=  flow
            ^-  json
            %+  frond  -.state
            ?-  -.state
              %snd  (snd-with-bone ossuary bone +.state)
              %rcv  (rcv-with-bone ossuary bone +.state)
            ==
          --
        ::
          :-  'nax'
          %+  list  (sort ~(tap in nax) dor)  ::  sort by bone
          |=  [=bone =message-num]
          %-  pairs
          :*  'message-num'^(numb message-num)
              (bone-to-pairs bone ossuary)
          ==
        ::
          'heeds'^(set heeds from-duct)
      ==
    ::
    ++  snd-with-bone
      |=  [=ossuary =bone message-pump-state]
      ^-  json
      %-  pairs
      :*  'current'^(numb current)
          'next'^(numb next)
        ::
          :-  'unsent-messages'  ::  as byte sizes
          (set unsent-messages (cork (cury met 3) numb))
        ::
          'unsent-fragments'^(numb (lent unsent-fragments))  ::  as lent
        ::
          :-  'queued-message-acks'
          %+  list  (sort ~(tap by queued-message-acks) dor)  ::  sort by msg nr
          |=  [=message-num =ack]
          %-  pairs
          :~  'message-num'^(numb message-num)
              'ack'^(cord -.ack)
          ==
        ::
          :-  'packet-pump-state'
          %-  pairs
          =,  packet-pump-state
          :~  'next-wake'^(unit next-wake time)
            ::
              :-  'live'
              %+  list  (sort ~(tap in live) dor)  ::  sort by msg nr & frg nr
              |=  [live-packet-key live-packet-val]
              %-  pairs
              :~  'message-num'^(numb message-num)
                  'fragment-num'^(numb fragment-num)
                  'num-fragments'^(numb num-fragments)
                  'last-sent'^(time last-sent)
                  'retries'^(numb retries)
                  'skips'^(numb skips)
              ==
            ::
              :-  'metrics'
              %-  pairs
              =,  metrics
              :~  'rto'^(numb (div rto ~s1))  ::TODO  milliseconds?
                  'rtt'^(numb (div rtt ~s1))
                  'rttvar'^(numb (div rttvar ~s1))
                  'ssthresh'^(numb ssthresh)
                  'num-live'^(numb num-live)
                  'cwnd'^(numb cwnd)
                  'counter'^(numb counter)
              ==
          ==
        ::
          (bone-to-pairs bone ossuary)
      ==
    ::
    ++  rcv-with-bone
      |=  [=ossuary =bone message-sink-state]
      ^-  json
      %-  pairs
      :*  'last-acked'^(numb last-acked)
          'last-heard'^(numb last-heard)
        ::
          :-  'pending-vane-ack'
          =-  (list - numb)
          (sort (turn ~(tap in pending-vane-ack) head) dor)  ::  sort by msg #
        ::
          :-  'live-messages'
          %+  list  (sort ~(tap by live-messages) dor)  ::  sort by msg #
          |=  [=message-num partial-rcv-message]
          %-  pairs
          :~  'message-num'^(numb message-num)
              'num-received'^(numb num-received)
              'num-fragments'^(numb num-fragments)
              'fragments'^(set ~(key by fragments) numb)
          ==
        ::
          'nax'^(list (sort ~(tap in nax) dor) numb)
        ::
          (bone-to-pairs bone ossuary)
      ==
    ::
    ++  bone-to-pairs
      |=  [=bone ossuary]
      ^-  (^list [@t json])
      :~  'bone'^(numb bone)
          'duct'^(from-duct (~(gut by by-bone) bone ~))
      ==
    ::
    ++  from-duct
      |=  =duct
      (list duct path)
    --
  --
::
::  behn
::
++  v-behn
  |%
  ++  timers
    (scry ,(list [date=@da =duct]) %bx %$ /debug/timers)
  --
::
::  clay
::
::TODO  depends on new clay changes (%s care)
++  v-clay
  =,  clay
  |%
  ++  start-path  /(scot %p our.bowl)/home/(scot %da now.bowl)
  ::
  +$  commit
    [=tako parents=(list tako) children=(list tako) wen=@da content-hash=@uvI]
  ::
  ++  commits-json
    ^-  json
    =+  .^(desks=(set desk) %cd start-path)
    =/  heads=(list [tako desk])
      %+  turn  ~(tap in desks)
      |=  =desk
      =+  .^(=dome %cv /(scot %p our.bowl)/[desk]/(scot %da now.bowl))
      =/  =tako  (~(got by hit.dome) let.dome)
      [tako desk]
    =/  yakis=(set yaki)
      %-  silt
      ^-  (list yaki)
      %-  zing
      %+  turn  heads
      |=  [=tako =desk]
      (trace-tako tako)
    =/  commits=(list commit)  (yakis-to-commits ~(tap in yakis))
    =,  enjs:format
    %-  pairs
    :~
      head+(pairs (turn heads |=([=tako =desk] (scot %uv tako)^(cord desk))))
      commits+(commits-to-json commits)
    ==
  ::
  ++  yakis-to-commits
    |=  yakis=(list yaki)
    ^-  (list commit)
    %+  turn  yakis
    |=  =yaki
    :*  r.yaki  p.yaki
        =/  candidates
          %+  turn
            (skim yakis |=(can=^yaki (lien p.can |=(=tako =(r.yaki tako)))))
          |=  can=^yaki
          r.can
        ~(tap in (silt candidates))
        t.yaki
        .^(@uvI %cs (weld start-path /hash/(scot %uv r.yaki)))
    ==
  ::
  ++  trace-tako
    |=  =tako
    ~+
    ^-  (list yaki)
    =+  .^(=yaki %cs (weld start-path /yaki/(scot %uv tako)))
    :-  yaki
    (zing (turn p.yaki trace-tako))
  ::
  ++  commits-to-json
    |=  commits=(list commit)
    ^-  json
    %+  list:enjs:format
      %+  sort  commits
      |=  [a=commit b=commit]
      (gte wen.a wen.b)
    |=  =commit
    (commit-to-json commit)
  ::
  ++  commit-to-json
    |=  =commit
    ^-  json
    =,  enjs:format
    %-  pairs
    :~
      'commitHash'^(tako-to-json tako.commit)
      parents+(list parents.commit tako-to-json)
      children+(list children.commit tako-to-json)
      'contentHash'^(tako-to-json content-hash.commit)
    ==
  ::
  ++  tako-to-json
    |=  =tako
    ^-  json
    (numh:enjs:format %uv tako)
  --
::
::  eyre
::
++  v-eyre
  =,  eyre
  =,  enjs:format
  |%
  ++  bindings
    (scry ,(^list [=binding =duct =action]) %e %bindings ~)
  ::
  ++  connections
    (scry ,(map duct outstanding-connection) %e %connections ~)
  ::
  ++  auth-state
    (scry authentication-state %e %authentication-state ~)
  ::
  ++  channel-state
    (scry ^channel-state %e %channel-state ~)
  ::
  ++  render-action
    |=  =action
    ^-  json
    %-  cord
    ?+  -.action  -.action
      %gen  :((cury cat 3) '+' (spat [desk path]:generator.action))
      %app  (cat 3 ':' app.action)
    ==
  --
::
::  helpers
::
++  poke
  |=  [=wire app=term =mark =vase]
  ^-  card
  [%pass wire %agent [our.bowl app] %poke mark vase]
::
++  scry
  |*  [=mold care=term =desk =path]
  .^(mold care (scot %p our.bowl) desk (scot %da now.bowl) path)
--
