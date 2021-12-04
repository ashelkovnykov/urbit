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
    %+  frond  -.blit
    ?-  -.blit
      %bel  (bool &)
      %clr  (bool &)
      %hop  (numb p.blit)
      %lin  (list p.blit (cork tuft cord))
      %mor  (bool &)
      %url  (cord p.blit)
    ::
        %sag
      %-  pairs
      :~  'path'^(path p.blit)
          'file'^(cord (en:base64:mimes:html (as-octs:mimes:html (jam q.blit))))
      ==
    ::
        %sav
      %-  pairs
      :~  'path'^(path p.blit)
          'file'^(cord (en:base64:mimes:html (as-octs:mimes:html q.blit)))
      ==
    ::
        %klr
      %+  list  p.blit
      |=  [=stye text=(^list @c)]
      |^
      %-  pairs
      :~
        'text'^(list text (cork tuft cord))
        ::
          :-  'stye'
          %-  pairs
          :~
            'back'^(color p.q.stye)
            'fore'^(color q.q.stye)
            'deco'^(set p.stye null-or-cord)
          ==
      ==
      ++  null-or-cord
        |=  t=?(~ @t)
        ?~  t  ~
        (cord t)
      ++  color
        |=  =tint
        ?@  tint  (null-or-cord tint)
        (tape ((x-co:co 6) (rep 3 ~[b g r]:tint)))
      --
    ==
  --
--
