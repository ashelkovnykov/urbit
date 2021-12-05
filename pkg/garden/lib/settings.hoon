/-  *settings
|%
++  enjs
  =,  enjs:format
  |%
  ++  data
    |=  dat=^data
    ^-  json
    %+  ob  -.dat
    ?-  -.dat
      %all     (settings +.dat)
      %bucket  (bucket +.dat)
      %entry   (value +.dat)
      %desk    (desk-settings +.dat)
    ==
  ::
  ++  settings
    |=  s=^settings
    ^-  json
    [%o (~(run by s) desk-settings)]
  ::
  ++  desk-settings
    |=  s=(map key ^bucket)
    [%o (~(run by s) bucket)]
  ::
  ++  event
    |=  evt=^event
    ^-  json
    %+  ob  -.evt
    ?-  -.evt
      %put-bucket  (put-bucket +.evt)
      %del-bucket  (del-bucket +.evt)
      %put-entry   (put-entry +.evt)
      %del-entry   (del-entry +.evt)
    ==
  ::
  ++  put-bucket
    |=  [d=desk k=key b=^bucket]
    ^-  json
    %-  pr
    :~  bucket-key+(co k)
        bucket+(bucket b)
        desk+(co d)
    ==
  ::
  ++  del-bucket
    |=  [d=desk k=key]
    ^-  json
    %-  pr
    :~  bucket-key+(co k)
        desk+(co d)
    ==
  ::
  ++  put-entry
    |=  [d=desk b=key k=key v=val]
    ^-  json
    %-  pr
    :~  bucket-key+(co b)
        entry-key+(co k)
        value+(value v)
        desk+(co d)
    ==
  ::
  ++  del-entry
    |=  [d=desk buc=key =key]
    ^-  json
    %-  pr
    :~  bucket-key+(co buc)
        entry-key+(co key)
        desk+(co d)
    ==
  ::
  ++  value
    |=  =val
    ^-  json
    ?-  -.val
      %s  val
      %b  val
      %n  (nu p.val)
      %a  (ls p.val value)
    ==
  ::
  ++  bucket
    |=  b=^bucket
    ^-  json
    [%o (~(run by b) value)]
  --
::
++  dejs
  =,  dejs:format
  |%
  ++  event
    |=  jon=json
    ^-  ^event
    %.  jon
    %-  of
    :~  put-bucket+put-bucket
        del-bucket+del-bucket
        put-entry+put-entry
        del-entry+del-entry
    ==
  ::
  ++  put-bucket
    %-  ot
    :~  desk+so
        bucket-key+so
        bucket+bucket
    ==
  ::
  ++  del-bucket
    %-  ot
    :~  desk+so
        bucket-key+so
    ==
  ::
  ++  put-entry
    %-  ot
    :~  desk+so
        bucket-key+so
        entry-key+so
        value+value
    ==
  ::
  ++  del-entry
    %-  ot
    :~  desk+so
        bucket-key+so
        entry-key+so
    ==
  ::
  ++  value
    |=  jon=json
    ^-  val
    ?+  -.jon  !!
      %s  jon
      %b  jon
      %n  [%n (rash p.jon dem)]
      %a  [%a (turn p.jon value)]
    ==
  ::
  ++  bucket
    |=  jon=json
    ^-  ^bucket
    ?>  ?=([%o *] jon)
    (~(run by p.jon) value)
  --
--
