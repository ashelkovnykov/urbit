/-  *gcp
|%
++  token-to-json
  |=  =token
  ^-  json
  =,  enjs:format
  %+  ob  %gcp-token
  %-  pr
  :~
    'accessKey'^(co access-key.token)
    'expiresIn'^(nu (div (mul 1.000 expires-in.token) ~s1))
  ==
--
