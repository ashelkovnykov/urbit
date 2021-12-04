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
  %+  frond  %s3-update
  %-  pairs
  :~  ?-  -.upd
          %set-current-bucket  [%'setCurrentBucket' (cord bucket.upd)]
          %add-bucket          [%'addBucket' (cord bucket.upd)]
          %remove-bucket       [%'removeBucket' (cord bucket.upd)]
          %set-endpoint        [%'setEndpoint' (cord endpoint.upd)]
          %set-access-key-id   [%'setAccessKeyId' (cord access-key-id.upd)]
          %set-secret-access-key
        [%'setSecretAccessKey' (cord secret-access-key.upd)]
      ::
          %credentials
        :-  %credentials
        %-  pairs
        :~  [%endpoint (cord endpoint.credentials.upd)]
            [%'accessKeyId' (cord access-key-id.credentials.upd)]
            [%'secretAccessKey' (cord secret-access-key.credentials.upd)]
        ==
      ::
          %configuration
        :-  %configuration
        %-  pairs
        :~  [%buckets (set buckets.configuration.upd cord)]
            [%'currentBucket' (cord current-bucket.configuration.upd)]
        ==
      ==
  ==
--
