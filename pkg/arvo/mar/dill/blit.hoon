::
::::  /hoon/blit/dill/mar
  ::
/?    310
/-    sole
=,  sole
=,  enjs:format
|_  dib=dill-blit:dill
++  grad  %noun
::
++  grab                                                   ::  convert from
  |%
  ++  noun  dill-blit:dill                                 ::  clam from %noun
  --
++  grow
  |%
  ++  noun  dib
  ++  json
    ^-  ^json
    ?+  -.dib  ~|(unsupported-blit+-.dib !!)
      %mor  (ls p.dib |=(a=dill-blit:dill json(dib a)))
      %hop  (ob %hop (nu p.dib))
      ?(%pro %out)  (ob -.dib (ta (tufa p.dib)))
      ?(%bel %clr)  (ob %act %s -.dib)
    ==
  --
--
