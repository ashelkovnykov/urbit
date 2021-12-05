::  blit: runtime blit structure
::
|_  =blit:dill
++  grad  %noun
::  +grab: convert from
::
++  grab
  |%
  ++  noun  blit:dill
  --
::  +grow: convert to
::
++  grow
  |%
  ++  noun  blit
  ++  json
    ^-  ^json
    =,  enjs:format
    %+  ob  -.blit
    ?-  -.blit
      %bel  (bo &)
      %clr  (bo &)
      %hop  (nu p.blit)
      %lin  (ls p.blit (cork tuft co))
      %mor  (bo &)
      %url  (co p.blit)
    ::
        %sag
      %-  pr
      :~  'path'^(pa p.blit)
          'file'^(co (en:base64:mimes:html (as-octs:mimes:html (jam q.blit))))
      ==
    ::
        %sav
      %-  pr
      :~  'path'^(pa p.blit)
          'file'^(co (en:base64:mimes:html (as-octs:mimes:html q.blit)))
      ==
    ::
        %klr
      %+  ls  p.blit
      |=  [=stye text=(list @c)]
      |^
      %-  pr
      :~
        'text'^(ls text (cork tuft co))
        ::
          :-  'stye'
          %-  pr
          :~
            'back'^(color p.q.stye)
            'fore'^(color q.q.stye)
            'deco'^(st p.stye null-or-cord)
          ==
      ==
      ++  null-or-cord
        |=  t=?(~ @t)
        ?~  t  ~
        (co t)
      ++  color
        |=  =tint
        ?@  tint  (null-or-cord tint)
        (ta ((x-co:^co 6) (rep 3 ~[b g r]:tint)))
      --
    ==
  --
--
