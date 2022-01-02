/-  btc-wallet, btc-provider, bitcoin
/+  bl=bitcoin
|%
++  dejs
  =,  dejs:format
  |%
  ++  command
    |=  jon=json
    ^-  command:btc-wallet
    %.  jon
    %-  of
    :~  set-provider+(mu ship)
        check-provider+ship
        check-payee+ship
        set-current-wallet+so
        add-wallet+add-wallet
        delete-wallet+so
        init-payment-external+init-payment-external
        init-payment+init-payment
        broadcast-tx+so
        gen-new-address+|=(json ~)
    ==
  ::
  ++  ship  sp
  ::
  ++  add-wallet
    %-  ot
    :~  xpub+so
        fprint+(at [ni ni ~])
        scan-to+(mu (at [ni ni ~]))
        max-gap+(mu ni)
        confs+(mu ni)
    ==
  ::
  ++  init-payment-external
    %-  ot
    :~  address+address
        value+ni
        feyb+ni
        note+(mu so)
    ==
  ::
  ++  init-payment
    %-  ot
    :~  payee+ship
        value+ni
        feyb+ni
        note+(mu so)
    ==
  ::
  ++  address
    |=  jon=json
    ?>  ?=([%s @t] jon)
    ^-  address:bitcoin
    (from-cord:adr:bl +.jon)
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  status
    |=  sta=status:btc-provider
    ^-  json
    %+  ob  -.sta
    ?-  -.sta
      %connected    (connected sta)
      %new-block    (new-block sta)
      %disconnected  ~
    ==
  ::
  ++  connected
    |=  sta=status:btc-provider
    ?>  ?=(%connected -.sta)
    %-  pr
    :~  network+(co network.sta)
        block+(nu block.sta)
        fee+(un fee.sta nu)
    ==
  ::
  ++  new-block
    |=  sta=status:btc-provider
    ?>  ?=(%new-block -.sta)
    %-  pr
    :~  network+(co network.sta)
        block+(nu block.sta)
        fee+(un fee.sta nu)
        blockhash+(hexb blockhash.sta)
        blockfilter+(hexb blockfilter.sta)
    ==
  ::
  ++  hexb
    |=  h=hexb:bitcoin
    ^-  json
    %-  pr
    :~  wid+(nu wid.h)
        dat+(nh %ux dat.h)
    ==
  ::
  ++  update
    |=  upd=update:btc-wallet
    ^-  json
    %+  ob  -.upd
    ?-  -.upd
      %initial             (initial upd)
      %change-provider     (change-provider upd)
      %change-wallet       (change-wallet upd)
      %psbt                (psbt upd)
      %btc-state           (btc-state btc-state.upd)
      %new-tx              (hest hest.upd)
      %cancel-tx           (hexb txid.upd)
      %new-address         (address address.upd)
      %balance             (balance balance.upd)
      %scan-progress       (scan-progress main.upd change.upd)
      %error               (co error.upd)
      %broadcast-success   ~
    ==
  ::
  ++  initial
    |=  upd=update:btc-wallet
    ?>  ?=(%initial -.upd)
    ^-  json
    %-  pr
    :~  provider+(provider provider.upd)
        wallet+(un wallet.upd co)
        balance+(balance balance.upd)
        history+(history history.upd)
        btc-state+(btc-state btc-state.upd)
        address+(un address.upd address)
    ==
  ::
  ++  change-provider
    |=  upd=update:btc-wallet
    ?>  ?=(%change-provider -.upd)
    ^-  json
    (provider provider.upd)
  ::
  ++  change-wallet
    |=  upd=update:btc-wallet
    ?>  ?=(%change-wallet -.upd)
    ^-  json
    %-  pr
    :~  wallet+(un wallet.upd co)
        balance+(balance balance.upd)
        history+(history history.upd)
    ==
  ::
  ++  psbt
    |=  upd=update:btc-wallet
    ?>  ?=(%psbt -.upd)
    ^-  json
    %-  pr
    :~  pb+(co pb.upd)
        fee+(nu fee.upd)
    ==
  ::
  ++  balance
    |=  b=(unit [p=@ q=@])
    ^-  json
    ?~  b  ~
    %-  pr
    :~  confirmed+(nu p.u.b)
        unconfirmed+(nu q.u.b)
    ==
  ::
  ++  scan-progress
    |=  [main=(unit idx:bitcoin) change=(unit idx:bitcoin)]
    ^-  json
    |^
    %-  pr
    :~  main+(from-unit main)
        change+(from-unit change)
    ==
    ++  from-unit
      |=  i=(unit idx:bitcoin)
      ?~  i  ~
      (nu u.i)
    --
  ::
  ++  btc-state
    |=  bs=btc-state:btc-wallet
    ^-  json
    %-  pr
    :~  block+(nu block.bs)
        fee+(un fee.bs nu)
        date+(sc t.bs)
    ==
  ::
  ++  provider
    |=  p=(unit provider:btc-wallet)
    ^-  json
    ?~  p  ~
    %-  pr
    :~  host+(hl host.u.p)
        connected+(bo connected.u.p)
    ==
  ::
  ++  history
    |=  hy=history:btc-wallet
    ^-  json
    :-  %o
    ^-  (map @t json)
    %-  ~(run in hy)
    |=  [=txid:btc-wallet h=hest:btc-wallet]
    [(scot %ux dat.txid) (hest h)]
  ::
  ++  hest
    |=  h=hest:btc-wallet
    ^-  json
    %-  pr
    :~  xpub+(co xpub.h)
        txid+(hexb txid.h)
        confs+(nu confs.h)
        recvd+(un recvd.h sc)
        inputs+(vals inputs.h)
        outputs+(vals outputs.h)
        note+(un note.h co)
    ==
  ::
  ++  vals
    |=  vl=(list [=val:tx:bitcoin s=(unit @p)])
    ^-  json
    %+  ls  vl
    |=  [v=val:tx:bitcoin s=(unit @p)]
    %-  pr
    :~  val+(val v)
        ship+(un s hl)
    ==
  ::
  ++  val
    |=  v=val:tx:bitcoin
    ^-  json
    %-  pr
    :~  txid+(hexb txid.v)
        pos+(nu pos.v)
        address+(address address.v)
        value+(nu value.v)
    ==
  ::
  ++  address
    |=  a=address:bitcoin
    ^-  json
    ?-  -.a
      %base58  (co (rsh [3 2] (scot %uc +.a)))
      %bech32  (co +.a)
    ==
  --
--
