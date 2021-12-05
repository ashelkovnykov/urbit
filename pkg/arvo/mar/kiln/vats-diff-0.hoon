/-  hood
|_  =diff:hood
++  grad  %noun
++  grow
  |%
  ++  noun  diff
  ++  json  
    =,  enjs:format
    |^
    %+  ob  -.diff
    ?-  -.diff
      %block  (block +.diff)
      ?(%merge-sunk %merge-fail)  (desk-arak-err +.diff)
      ?(%reset %commit %suspend %revive)  (desk-arak +.diff)
    ==
    ::
    ++  block
      |=  [=desk =arak:hood =weft:hood blockers=(set desk)]
      %+  merge  (desk-arak desk arak)
      %-  pr
      :~  weft+(weft:enjs:hood weft)
          blockers+(st blockers co)
      ==
    ::
    ++  desk-arak
      |=  [=desk =arak:hood]
      %-  pr
      :~  desk+(co desk)
          arak+(arak:enjs:hood arak)
      ==
    ::
    ++  desk-arak-err
      |=  [=desk =arak:hood =tang]
      %+  merge  (desk-arak desk arak)
      %+  ob   %tang
      (ls tang tk)
    ::
    ++  merge
      |=  [a=^json b=^json]
      ^-  ^json
      ?>  &(?=(%o -.a) ?=(%o -.b))
      o+(~(uni by p.a) p.b)
    --
  --
++  grab
  |%
  ++  noun  diff:hood
  --
--

      



