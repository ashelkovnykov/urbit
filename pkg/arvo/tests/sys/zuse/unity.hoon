/+  *test
=,  unity
|%
::  collapse (list (unit)) -> (unit (list))
::
++  test-drop-list
  =+  all=`(list (unit @))`~[(some 1) (some 2) (some 3)]
  =+  nall=`(list (unit @))`~[(some 1) ~ (some 3)]
  ;:  weld
    %+  expect-eq
      !>  (some ~[1 2 3])
      !>  (drop-list all)
    %+  expect-eq
      !>  (some ~)
      !>  (drop-list ~)
    %+  expect-eq
      !>  ~
      !>  (drop-list nall)
  ==
::  collapse (set (unit)) -> (unit (set))
::
++  test-drop-set
  =+  all=(silt (limo ~[(some 1) (some 2) (some 3)]))
  =+  nall=(silt (limo ~[(some 1) ~ (some 3)]))
  ;:  weld
    %+  expect-eq
      !>  (some (silt ~[1 2 3]))
      !>  (drop-set all)
    %+  expect-eq
      !>  (some ~)
      !>  (drop-set ~)
    %+  expect-eq
      !>  ~
      !>  (drop-set nall)
  ==
::  collapse (map * (unit)) -> (unit (map * *))
::
++  test-drop-map
  =+  all=(malt (limo ~[['a' (some 1)] ['b' (some 2)] ['c' (some 3)]]))
  =+  nall=(malt (limo ~[['a' (some 1)] ['b' ~] ['c' (some 3)]]))
  ;:  weld
  %+  expect-eq
    !>  (some (malt ~[['a' 1] ['b' 2] ['c' 3]]))
    !>  (drop-map all)
  %+  expect-eq
    !>  (some ~)
    !>  (drop-map ~)
  %+  expect-eq
    !>  ~
    !>  (drop-map nall)
  ==
::  collapse (pole (unit)) -> (unit (pole))
::
++  test-drop-pole
  =+  all=`(list (unit @))`~[(some 1) (some 2) (some 3)]
  =+  nall=`(list (unit @))`~[(some 1) ~ (some 3)]
  ;:  weld
    %+  expect-eq
      !>  (some [1 2 3])
      !>  (drop-pole all)
    %+  expect-eq
      !>  ~
      !>  (drop-pole ~)
    %+  expect-eq
      !>  ~
      !>  (drop-pole nall)
  ==
--
