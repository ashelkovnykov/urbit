/-  sur=file-server
^?
=<  [sur .]
=,  sur
|%
++  enjs
  =,  enjs:format
  |%
  ++  update
    |=  upd=^update
    ^-  json
    |^  (frond %file-server (frond (encode upd)))
    ::
    ++  encode
      |=  upd=^update
      ^-  [^cord json]
      ?-  -.upd
          %configuration
        =*  prefix  landscape-homepage-prefix.configuration.upd
        :-  %configuration
        (frond %landscape-homepage-prefix (unit prefix cord))
      ==
    --
  --
--
