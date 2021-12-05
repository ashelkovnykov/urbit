/-  *s3
|%
++  json-to-action
  |=  =json
  ^-  action
  =,  format
  |^  (parse-json json)
  ++  parse-json
    %-  of:dejs
    :~  [%set-endpoint so:dejs]
        [%set-access-key-id so:dejs]
        [%set-secret-access-key so:dejs]
        [%add-bucket so:dejs]
        [%remove-bucket so:dejs]
        [%set-current-bucket so:dejs]
    ==
  --
::
++  update-to-json
  |=  upd=update
  ^-  json
  =,  enjs:format
  %+  ob  %s3-update
  %-  pr
  :~  ?-  -.upd
          %set-current-bucket  [%'setCurrentBucket' (co bucket.upd)]
          %add-bucket          [%'addBucket' (co bucket.upd)]
          %remove-bucket       [%'removeBucket' (co bucket.upd)]
          %set-endpoint        [%'setEndpoint' (co endpoint.upd)]
          %set-access-key-id   [%'setAccessKeyId' (co access-key-id.upd)]
          %set-secret-access-key
        [%'setSecretAccessKey' (co secret-access-key.upd)]
      ::
          %credentials
        :-  %credentials
        %-  pr
        :~  [%endpoint (co endpoint.credentials.upd)]
            [%'accessKeyId' (co access-key-id.credentials.upd)]
            [%'secretAccessKey' (co secret-access-key.credentials.upd)]
        ==
      ::
          %configuration
        :-  %configuration
        %-  pr
        :~  [%buckets (st buckets.configuration.upd co)]
            [%'currentBucket' (co current-bucket.configuration.upd)]
        ==
      ==
  ==
--
