/-  *settings
|%
++  enjs
  =,  enjs:format
  |%
  ++  data
    |=  dat=^data
    ^-  json
    %+  frond  -.dat
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
    %+  frond  -.evt
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
    %-  pairs
    :~  bucket-key+(cord k)
        bucket+(bucket b)
        desk+(cord d)
    ==
  ::
  ++  del-bucket
    |=  [d=desk k=key]
    ^-  json
    %-  pairs
    :~  bucket-key+(cord k)
        desk+(cord d)
    ==
  ::
  ++  put-entry
    |=  [d=desk b=key k=key v=val]
    ^-  json
    %-  pr
    :~  bucket-key+(cord b)
        entry-key+(cord k)
        value+(value v)
        desk+(cord d)
    ==
  ::
  ++  del-entry
    |=  [d=desk buc=key =key]
    ^-  json
    %-  pr
    :~  bucket-key+(cord buc)
        entry-key+(cord key)
        desk+(cord d)
    ==
  ::
  ++  value
    |=  =val
    ^-  json
    ?-  -.val
      %s  val
      %b  val
      %n  (numb p.val)
      %a  (list p.val value)
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
