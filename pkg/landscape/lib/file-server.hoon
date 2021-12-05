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
    |^  (ob %file-server (ob (encode upd)))
    ::
    ++  encode
      |=  upd=^update
      ^-  [cord json]
      ?-  -.upd
          %configuration
        =*  prefix  landscape-homepage-prefix.configuration.upd
        :-  %configuration
        (ob %landscape-homepage-prefix (un prefix co))
      ==
    --
  --
--
