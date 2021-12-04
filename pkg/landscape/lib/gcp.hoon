/-  *gcp
|%
++  token-to-json
  |=  =token
  ^-  json
  =,  enjs:format
  %+  frond  %gcp-token
  %-  pairs
  :~
    'accessKey'^(cord access-key.token)
    'expiresIn'^(numb (div (mul 1.000 expires-in.token) ~s1))
  ==
--
