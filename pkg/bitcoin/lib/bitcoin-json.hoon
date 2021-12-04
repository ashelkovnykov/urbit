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
  ++  ship  (su ;~(pfix sig fed:ag))
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
    %+  frond  -.sta
    ?-  -.sta
      %connected    (connected sta)
      %new-block    (new-block sta)
      %disconnected  ~
    ==
  ::
  ++  connected
    |=  sta=status:btc-provider
    ?>  ?=(%connected -.sta)
    %-  pairs
    :~  network+(cord network.sta)
        block+(numb block.sta)
        fee+(unit fee.sta numb)
    ==
  ::
  ++  new-block
    |=  sta=status:btc-provider
    ?>  ?=(%new-block -.sta)
    %-  pairs
    :~  network+(cord network.sta)
        block+(numb block.sta)
        fee+(unit fee.sta numb)
        blockhash+(hexb blockhash.sta)
        blockfilter+(hexb blockfilter.sta)
    ==
  ::
  ++  hexb
    |=  h=hexb:bitcoin
    ^-  json
    %-  pairs
    :~  wid+(numb wid.h)
        dat+(numh %ux dat.h)
    ==
  ::
  ++  update
    |=  upd=update:btc-wallet
    ^-  json
    %+  frond  -.upd
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
      %error               (cord error.upd)
      %broadcast-success   ~
    ==
  ::
  ++  initial
    |=  upd=update:btc-wallet
    ?>  ?=(%initial -.upd)
    ^-  json
    %-  pairs
    :~  provider+(provider provider.upd)
        wallet+(unit wallet.upd cord)
        balance+(balance balance.upd)
        history+(history history.upd)
        btc-state+(btc-state btc-state.upd)
        address+(unit address.upd address)
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
    %-  pairs
    :~  wallet+(unit wallet.upd cord)
        balance+(balance balance.upd)
        history+(history history.upd)
    ==
  ::
  ++  psbt
    |=  upd=update:btc-wallet
    ?>  ?=(%psbt -.upd)
    ^-  json
    %-  pairs
    :~  pb+(cord pb.upd)
        fee+(numb fee.upd)
    ==
  ::
  ++  balance
    |=  b=(unit [p=@ q=@])
    ^-  json
    ?~  b  ~
    %-  pairs
    :~  confirmed+(numb p.u.b)
        unconfirmed+(numb q.u.b)
    ==
  ::
  ++  scan-progress
    |=  [main=(unit idx:bitcoin) change=(unit idx:bitcoin)]
    ^-  json
    |^
    %-  pairs
    :~  main+(from-unit main)
        change+(from-unit change)
    ==
    ++  from-unit
      |=  i=(unit idx:bitcoin)
      ?~  i  ~
      (numb u.i)
    --
  ::
  ++  btc-state
    |=  bs=btc-state:btc-wallet
    ^-  json
    %-  pairs
    :~  block+(numb block.bs)
        fee+(unit fee.bs numb)
        date+(sect t.bs)
    ==
  ::
  ++  provider
    |=  p=(unit provider:btc-wallet)
    ^-  json
    ?~  p  ~
    %-  pairs
    :~  host+(shil host.u.p)
        connected+(bool connected.u.p)
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
    %-  pairs
    :~  xpub+(cord xpub.h)
        txid+(hexb txid.h)
        confs+(numb confs.h)
        recvd+(unit recvd.h sect)
        inputs+(vals inputs.h)
        outputs+(vals outputs.h)
        note+(unit note.h cord)
    ==
  ::
  ++  vals
    |=  vl=(^list [=val:tx:bitcoin s=(unit @p)])
    ^-  json
    %+  list  vl
    |=  [v=val:tx:bitcoin s=(unit @p)]
    %-  pairs
    :~  val+(val v)
        ship+(unit s shil)
    ==
  ::
  ++  val
    |=  v=val:tx:bitcoin
    ^-  json
    %-  pairs
    :~  txid+(hexb txid.v)
        pos+(numb pos.v)
        address+(address address.v)
        value+(numb value.v)
    ==
  ::
  ++  address
    |=  a=address:bitcoin
    ^-  json
    ?-  -.a
      %base58  (cord (rsh [3 2] (scot %uc +.a)))
      %bech32  (cord +.a)
    ==
  --
--
