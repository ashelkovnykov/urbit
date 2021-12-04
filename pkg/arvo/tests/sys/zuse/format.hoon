/+  *test
=,  format
|%
:: split a cord on newlines
::
++  test-to-wain
  ;:  weld
    ::  basic usage
    ::
    %+  expect-eq
      !>  ~['hello' 'world']
      !>  (to-wain 'hello\0aworld')
    :: string with no newlines
    ::
    %+  expect-eq
      !>  ~['hey']
      !>  (to-wain 'hey')
    ::  empty string works fine
    ::
    %+  expect-eq
      !>  ~
      !>  (to-wain '')
    ::  leading/trailing/consecutive newlines all work fine
    ::
    %+  expect-eq
      !>  ~['' 'hi' '' '' 'there']
      !>  (to-wain '\0ahi\0a\0a\0athere\0a')
  ==
::  join a list of lines (cords) into a single cord
::
++  test-of-wain
  ;:  weld
    ::  basic usage
    ::
    %+  expect-eq
      !>  'hey\0athere\0aworld!'
      !>  (of-wain ~['hey' 'there' 'world!'])
    ::  empty list
    ::
    %+  expect-eq
      !>  ''
      !>  (of-wain ~)
    :: single list
    ::
    %+  expect-eq
      !>  'hey'
      !>  (of-wain ~['hey'])
    ::  list with empties
    ::
    %+  expect-eq
      !>  'hey\0a\0athere'
      !>  (of-wain ~['hey' '' 'there'])
  ==
::  join a list of lines (tapes) into a single cord.
::
::    Appends an extra newline - this matches unix conventions of a
::    trailing newline. Also see #1, #2
::
++  test-of-wall
  ;:  weld
    ::  basic usage
    ::
    %+  expect-eq
      !>  "hey\0athere\0aworld!\0a"
      !>  (of-wall ~["hey" "there" "world!"])
    ::  empty list
    ::
    %+  expect-eq
      !>  ""
      !>  (of-wall ~)
    :: single list
    ::
    %+  expect-eq
      !>  "hey\0a"
      !>  (of-wall ~["hey"])
    ::  list with empties
    ::
    %+  expect-eq
      !>  "hey\0a\0athere\0a"
      !>  (of-wall ~["hey" "" "there"])
  ==
::  encoding and decoding of beams <-> paths
::    (a beam is a fully-qualified file reference. ship, desk, version,
::    path)
::
++  test-beam
  =/  b=beam  [[p=~zod q=%home r=[%ud p=12]] s=/sys/zuse/hoon]
  =/  p=path  /~zod/home/12/sys/zuse/hoon
  ;:  weld
    ::  proper encode
    ::
    %+  expect-eq
      !>  p
      !>  (en-beam b)
    ::  proper decode
    ::
    %+  expect-eq
      !>  (some b)
      !>  (de-beam p)
    ::  proper round trip
    ::
    %+  expect-eq
      !>  (some b)
      !>  (de-beam (en-beam b))
    ::  path too short
    ::
    %+  expect-eq
      !>  ~
      !>  (de-beam /~zod/home)
    ::  invalid ship
    ::
    %+  expect-eq
      !>  ~
      !>  (de-beam /'~zodisok'/home/12/sys/zuse/hoon)
    ::  invalid desk
    ::
    %+  expect-eq
      !>  ~
      !>  (de-beam /~zod/12/12/sys/zuse/hoon)
    ::  invalid case
    ::
    %+  expect-eq
      !>  ~
      !>  (de-beam /~zod/home/~zod/sys/zuse/hoon)
  ==
::  example values used in test
::
++  ex
  |%
  ++  nul  `json`~
  ++  tru  `json`[%b &]
  ++  num  `json`[%n '101']
  ++  tms  `json`[%n '1000']
  ++  tsc  `json`[%n '1']
  ++  str  `json`[%s 'hey']
  ++  wal  `json`[%s 'hello\0Aworld\0A']
  ++  foo  ['foo' num]
  ++  bar  ['bar' str]
  ++  obj  `json`(frond:enjs foo)
  ++  pai  `json`(pairs:enjs ~[foo bar])
  --
::  functions for creating `json` values
::
++  test-enjs
  =,  enjs
  ;:  weld
    ::  simple object
    ::
    %+  expect-eq
      !>  [%o (molt ~[foo:ex])]
      !>  (frond foo:ex)
    ::  complex object
    ::
    %+  expect-eq
      !>  [%o (molt ~[foo:ex bar:ex])]
      !>  (pairs ~[foo:ex bar:ex])
    ::  list
    ::
    %+  expect-eq
      !>  [%a ~[num:ex num:ex num:ex]]
      !>  (list ~[101 101 101] numb)
    ::  set
    ::
    %+  expect-eq
      !>  [%a ~[[%s 'c'] [%s 'a'] [%s 'b']]]
      !>  (set (silt ~['a' 'b' 'c' 'c' 'b' 'a']) cord)
    ::  boolean
    ::
    %+  expect-eq
      !>  tru:ex
      !>  (bool &)
    ::  cord
    ::
    %+  expect-eq
      !>  str:ex
      !>  (cord 'hey')
    ::  tape
    ::
    %+  expect-eq
      !>  str:ex
      !>  (tape "hey")
    ::  wall
    ::
    %+  expect-eq
      ::  uses of-wall, so adds the trailing newline
      ::
      !>  wal:ex
      !>  (wall ~["hello" "world"])
    ::  ship name
    ::
    %+  expect-eq
      !>  [%s '~zod']
      !>  (ship ~zod)
    ::  ship name, no '~'
    ::
    %+  expect-eq
      !>  [%s 'zod']
      !>  (shil ~zod)
    ::  number
    ::
    %+  expect-eq
      !>  [%n '0']
      !>  (numb 0)
    %+  expect-eq
      !>  [%n '10']
      !>  (numb 0xa)
    %+  expect-eq
      !>  num:ex
      !>  (numb 101)
    %+  expect-eq
      !>  [%n '1000']
      !>  (numb 1.000)
    ::  number as string
    ::
    %+  expect-eq
      !>  [%s '0']
      !>  (nums 0)
    %+  expect-eq
      !>  [%s '10']
      !>  (nums 10)
    %+  expect-eq
      !>  [%s '100']
      !>  (nums 100)
    %+  expect-eq
      !>  [%s '1000']
      !>  (nums 1.000)
    ::  hoon num as string
    ::
    %+  expect-eq
      !>  [%s '0']
      !>  (numh %u 0)
    %+  expect-eq
      !>  [%s '1.000']
      !>  (numh %ud 1.000)
    %+  expect-eq
      !>  [%s '0xa.baca']
      !>  (numh %ux 0xa.baca)
    %+  expect-eq
      !>  [%s '384.319.963']
      !>  (numh %u 0vb.egger)
    ::  sec time
    ::
    %+  expect-eq
      !>  tsc:ex
      !>  (sect ~1970.1.1..0.0.1)
    ::  ms time
    ::
    %+  expect-eq
      !>  tms:ex
      !>  (time ~1970.1.1..0.0.1)
    %+  expect-eq
      !>  tms:ex
      !>  (time (from-unix-ms:chrono:userlib 1.000))
    ::  date
    ::
    %+  expect-eq
      !>  [%s '~2016.11.9..07.47.00']
      !>  (date (from-unix:chrono:userlib 1.478.677.620))
    ::  path
    ::
    %+  expect-eq
      !>  [%s (crip "/~zod/base")]
      !>  (path [~.~zod ~.base ~])
    ::  tank
    ::
    %+  expect-eq
      !>  [%a ~[[%s 'abc']]]
      !>  (tank leaf+"abc")
    %+  expect-eq
      !>  [%a ~[[%s '[a b c]']]]
      !>  (tank [%rose [" " "[" "]"] leaf+"a" leaf+"b" leaf+"c" ~])
    %+  expect-eq
      !>  [%a ~[[%s '!(a:b:c)']]]
      !>  (tank [%palm [":" "!" "(" ")"] leaf+"a" leaf+"b" leaf+"c" ~])
    ::  unit
    ::
    %+  expect-eq
      !>  ~
      !>  (unit ~ numb)
    %+  expect-eq
      !>  num:ex
      !>  (unit (some 101) numb)
  ==
::  dejs - recursive processing of `json` values
::
::    This version crashes when used on improper input. Prefer using
::    dejs-soft (also tested below) which returns units instead.
::
::  decoding from null, booleans, numbers, strings
::
++  test-dejs-primitives
  =,  dejs
  ;:  weld
    ::  null
    ::
    %+  expect-eq
      !>  ~
      !>  (ul `json`~)
    ::  booleans
    ::
    ::  bo extracts as-is, bu negates it
    ::
    %+  expect-eq
      !>  &
      !>  (bo tru:ex)
    %+  expect-eq
      !>  |
      !>  (bu tru:ex)
    %-  expect-fail
      |.  (bo num:ex)
    %-  expect-fail
      |.  (bu num:ex)
    ::  integers
    ::
    ::  as @
    ::
    %+  expect-eq
      !>  101
      !>  (ni num:ex)
    %-  expect-fail
      |.  (ni tru:ex)
    ::  as cord
    ::
    %+  expect-eq
      !>  '101'
      !>  (no num:ex)
    %-  expect-fail
      |.  (no tru:ex)
    ::  timestamp - ms since the unix epoch
    ::
    %+  expect-eq
      !>  ~1970.1.1..00.00.01
      !>  (di [%n ~.1000])
    %-  expect-fail
      |.  (di tru:ex)
    :: strings
    ::
    :: string as tape
    ::
    %+  expect-eq
      !>  "hey"
      !>  (sa str:ex)
    %-  expect-fail
      |.  (sa tru:ex)
    :: string as cord
    ::
    %+  expect-eq
      !>  'hey'
      !>  (so str:ex)
    %-  expect-fail
      |.  (so tru:ex)
    :: string with custom parser
    ::
    %+  expect-eq
      !>  ' '
      !>  ((su (just ' ')) [%s ' '])
    %-  expect-fail
      |.  ((su (just ' ')) tru:ex)
  ==
::  decoding arrays
::
++  test-dejs-arrays
  =,  dejs
  ;:  weld
    ::  ar - as list
    ::
    %+  expect-eq
      !>  ~[1 2 3]
      !>  ((ar ni) [%a ~[[%n '1'] [%n '2'] [%n '3']]])
    %-  expect-fail
      |.  ((ar ni) str:ex)
    %-  expect-fail
      |.  ((ar ni) [%a ~[str:ex]])
    ::  at - as tuple
    ::
    ::  handlers must match exactly
    ::
    %+  expect-eq
      !>  [1 'hey']
      !>  ((at ~[ni so]) [%a ~[[%n '1'] [%s 'hey']]])
    ::  too few or many handlers crash
    ::
    %-  expect-fail
      |.  ((at ~[ni so]) [%a ~])
    %-  expect-fail
      |.  ((at ~[ni so]) [%a ~[[%n '1'] [%s 'hey'] [%b &]]])
    ::  a nested error will crash
    ::
    %-  expect-fail
      |.  ((at ~[ni]) [%a ~[[%s 'hey']]])
  ==
::  decoding objects
::
++  test-dejs-objects
  =,  dejs
  ;:  weld
    ::  of - single-property objects
    ::
    %+  expect-eq
      !>  ['foo' 101]
      !>  ((of ~[['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  ['foo' 'e']
      !>  ((of ~[['bar' so] ['foo' ni]]) obj:ex)
    %-  expect-fail
      ::  the handler needs to apply properly to the value
      ::
      |.  ((of ~[['foo' ni]]) num:ex)
    %-  expect-fail
      ::  the key of the frond needs to exist in the handler list
      ::
      |.  ((of ~[['bar' so]]) obj:ex)
    %-  expect-fail
      ::  an object with multiple properties is an error
      ::
      |.  ((of ~[['bar' so] ['foo' ni]]) pai:ex)
    ::  ot - exact-shape objects to tuple
    ::
    %+  expect-eq
      !>  [101 'hey']
      !>  ((ot ~[['foo' ni] ['bar' so]]) pai:ex)
    %-  expect-fail
      ::  it checks it's called on an actual object
      ::
      |.  ((ot ~[['foo' ni]]) num:ex)
    %-  expect-fail
      ::  missing property on the object
      ::
      |.  ((ot ~[['foo' ni] ['baz' so]]) pai:ex)
    ::  ou - object to tuple, with optional properties. value handlers
    ::
    ::  are passed (unit json)
    ::
    %+  expect-eq
      !>  [101 14]
      !>  ((ou ~[['foo' (uf 14 ni)] ['baz' (uf 14 ni)]]) pai:ex)
    ::  om - simple object as map
    ::
    %+  expect-eq
      !>  (molt ~[['foo' num:ex] ['bar' str:ex]])
      !>  ((om same) pai:ex)
    ::  op - object to map, but run a parsing function on the keys
    ::
    %+  expect-eq
      !>  (molt ~[[12 num:ex] [14 str:ex]])
      !>  ((op dem same) (pairs:enjs ~[['12' num:ex] ['14' str:ex]]))
  ==
::  decoder transformers
::
++  test-dejs-transformers
  =,  dejs
  ;:  weld
    ::  cu - decode, then transform
    ::
    %+  expect-eq
      !>  11
      !>  ((cu dec ni) [%n ~.12])
    ::  ci - decode, then assert a transformation succeeds
    ::
    %+  expect-eq
      !>  101
      !>  ((ci some ni) num:ex)
    %-  expect-fail
      |.  ((ci |=(* ~) ni) num:ex)
    ::  mu - decode if not null
    ::
    %+  expect-eq
      !>  ~
      !>  ((mu ni) nul:ex)
    %+  expect-eq
      !>  (some 101)
      !>  ((mu ni) num:ex)
    ::  pe - add prefix to decoded value
    ::
    %+  expect-eq
      !>  ['a' 101]
      !>  ((pe 'a' ni) num:ex)
    ::  uf - defaults for empty (unit json)
    ::
    %+  expect-eq
      !>  'nah'
      !>  ((uf 'nah' ni) ~)
    %+  expect-eq
      !>  'e'
      !>  ((uf 'nah' ni) (some num:ex))
    ::  un - dangerous ensure a (unit json)
    ::
    %+  expect-eq
      !>  101
      !>  ((un ni) (some num:ex))
    %-  expect-fail
      |.  ((un ni) ~)
  ==
::  various unit/collection helpers
::
++  test-dejs-helpers
  =,  dejs
  =+  all=`(list (unit @))`~[(some 1) (some 2) (some 3)]
  =+  nall=`(list (unit @))`~[(some 1) ~ (some 3)]
  ;:  weld
    ::  za - are all units in this list full?
    ::
    %+  expect-eq
      !>  &
      !>  (za ~)
    %+  expect-eq
      !>  &
      !>  (za all)
    %+  expect-eq
      !>  |
      !>  (za nall)
    ::  zl - collapse (list (unit)) -> (unit (list))
    ::
    %+  expect-eq
      !>  (some ~[1 2 3])
      !>  (zl all)
    %+  expect-eq
      !>  ~
      !>  (zl nall)
    %+  expect-eq
      !>  (some ~)
      !>  (zl ~)
    ::  zp - force unwrap a (list (unit)) as tuple
    ::
    %+  expect-eq
      !>  [1 2 3]
      !>  (zp all)
    %-  expect-fail
      |.  (zp nall)
    %-  expect-fail
      |.  (zp ~)
    ::  zm - collapse a (map @tas (unit *)) -> (unit (map @tas *))
    ::
    %+  expect-eq
      !>  (some (molt ~[['a' 1] ['b' 2]]))
      !>  (zm (molt ~[['a' (some 1)] ['b' (some 2)]]))
    %+  expect-eq
      !>  ~
      !>  (zm (molt ~[['a' `(unit @)`(some 1)] ['b' ~]]))
    %+  expect-eq
      !>  (some ~)
      !>  (zm ~)
  ==
::
::  dejs-soft recursive processing of `json` values
::
::    These functions return units, which will be nil if the input
::    doesn't match the defined structure.
::
++  test-dejs-soft-primitives
  =,  dejs-soft
  ;:  weld
    ::  null
    ::
    %+  expect-eq
      !>  `~
      !>  (ul `json`~)
    ::  booleans
    ::
    ::  bo extracts as-is, bu negates it
    ::
    %+  expect-eq
      !>  `&
      !>  (bo tru:ex)
    %+  expect-eq
      !>  `|
      !>  (bu tru:ex)
    %+  expect-eq
      !>  ~
      !>  (bo num:ex)
    %+  expect-eq
      !>  ~
      !>  (bu num:ex)
    ::  integers
    ::  as @
    ::
    %+  expect-eq
      !>  `101
      !>  (ni num:ex)
    %+  expect-eq
      !>  ~
      !>  (ni tru:ex)
    ::  as cord
    ::
    %+  expect-eq
      !>  `'101'
      !>  (no num:ex)
    %+  expect-eq
      !>  ~
      !>  (no tru:ex)
    ::  timestamp - ms since the unix epoch
    ::
    %+  expect-eq
      !>  `~1970.1.1..00.00.01
      !>  (di [%n ~.1000])
    %+  expect-eq
      !>  ~
      !>  (di tru:ex)
    :: string as tape
    ::
    %+  expect-eq
      !>  `"hey"
      !>  (sa str:ex)
    %+  expect-eq
      !>  ~
      !>  (sa tru:ex)
    :: string as cord
    ::
    %+  expect-eq
      !>  `'hey'
      !>  (so str:ex)
    %+  expect-eq
      !>  ~
      !>  (so tru:ex)
    :: string with custom parser
    ::
    %+  expect-eq
      !>  `' '
      !>  ((su (just ' ')) [%s ' '])
    %+  expect-eq
      !>  ~
      !>  ((su (just ' ')) tru:ex)
  ==
::  decoding arrays
::
++  test-dejs-soft-arrays
  =,  dejs-soft
  ;:  weld
    ::  ar - as list
    ::
    %+  expect-eq
      !>  `~[1 2 3]
      !>  ((ar ni) [%a ~[[%n '1'] [%n '2'] [%n '3']]])
    %+  expect-eq
      !>  ~
      !>  ((ar ni) str:ex)
    %+  expect-eq
      !>  ~
      !>  ((ar ni) [%a ~[str:ex]])
    ::  at - as tuple
    ::
    ::  handlers must match exactly
    ::
    %+  expect-eq
      !>  `[1 'hey']
      !>  ((at ~[ni so]) [%a ~[[%n '1'] [%s 'hey']]])
    ::  too few or many handlers won't match
    ::
    %+  expect-eq
      !>  ~
      !>  ((at ~[ni so]) [%a ~])
    %+  expect-eq
      !>  ~
      !>  ((at ~[ni so]) [%a ~[[%n '1'] [%s 'hey'] [%b &]]])
    ::  a nested failure to match will propagate upwards
    ::
    %+  expect-eq
      !>  ~
      !>  ((at ~[ni]) [%a ~[[%s 'hey']]])
  ==
::  decoding objects
::
++  test-dejs-soft-objects
  =,  dejs-soft
  ;:  weld
    ::  of - single-property objects
    ::
    %+  expect-eq
      !>  `['foo' 101]
      !>  ((of ~[['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  `['foo' 'e']
      !>  ((of ~[['bar' so] ['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  ~
      ::  the handler needs to apply properly to the value
      ::
      !>  ((of ~[['foo' ni]]) num:ex)
    %+  expect-eq
      !>  ~
      ::  the key of the frond needs to exist in the handler list
      ::
      !>  ((of ~[['bar' so]]) obj:ex)
    %+  expect-eq
      !>  ~
      ::  an object with multiple properties is an error
      ::
      !>  ((of ~[['bar' so] ['foo' ni]]) pai:ex)
    ::  ot - exact-shape objects to tuple
    ::
    %+  expect-eq
      !>  `[101 'hey']
      !>  ((ot ~[['foo' ni] ['bar' so]]) pai:ex)
    %+  expect-eq
      !>  ~
      ::  missing property on the object
      ::
      !>  ((ot ~[['foo' ni] ['baz' so]]) pai:ex)
    ::  om - simple object as map
    ::
    %+  expect-eq
      !>  `(molt ~[['foo' num:ex] ['bar' str:ex]])
      !>  ((om some) pai:ex)
    ::  op - object to map, but run a parsing function on the keys
    ::
    %+  expect-eq
      !>  `(molt ~[[12 num:ex] [14 str:ex]])
      !>  ((op dem some) (pairs:enjs ~[['12' num:ex] ['14' str:ex]]))
  ==
::  decoder transformers
::
++  test-dejs-soft-transformers
  =,  dejs-soft
  ;:  weld
    ::  cu - decode, then transform
    ::
    %+  expect-eq
      !>  `11
      !>  ((cu dec ni) [%n ~.12])
    ::  ci - decode, then transform, adapting the transformer to return a
    ::  unit
    ::
    %+  expect-eq
      !>  `101
      !>  ((ci some ni) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((ci |=(* ~) ni) num:ex)
    ::  mu - decode if not null
    ::
    %+  expect-eq
      !>  `~
      !>  ((mu ni) nul:ex)
    %+  expect-eq
      !>  `(some 101)
      !>  ((mu ni) num:ex)
    ::  pe - add prefix to decoded value
    ::
    %+  expect-eq
      !>  `['a' 101]
      !>  ((pe 'a' ni) num:ex)
  ==
::  various unit/collection helpers
::
++  test-dejs-soft-helpers
  =,  dejs-soft
  =+  all=`(list (unit @))`~[(some 1) (some 2) (some 3)]
  =+  nall=`(list (unit @))`~[(some 1) ~ (some 3)]
  ;:  weld
    ::  za - are all units in this list full?
    ::
    %+  expect-eq
      !>  &
      !>  (za ~)
    %+  expect-eq
      !>  &
      !>  (za all)
    %+  expect-eq
      !>  |
      !>  (za nall)
    ::  zl - collapse (list (unit)) -> (unit (list))
    ::
    %+  expect-eq
      !>  (some ~[1 2 3])
      !>  (zl all)
    %+  expect-eq
      !>  ~
      !>  (zl nall)
    %+  expect-eq
      !>  (some ~)
      !>  (zl ~)
    ::  zp - force unwrap a (list (unit)) as tuple
    ::
    %+  expect-eq
      !>  [1 2 3]
      !>  (zp all)
    %-  expect-fail
      |.  (zp nall)
    %-  expect-fail
      |.  (zp ~)
    ::  zm - collapse a (map @tas (unit *)) -> (unit (map @tas *))
    ::
    %+  expect-eq
      !>  (some (molt ~[['a' 1] ['b' 2]]))
      !>  (zm (molt ~[['a' (some 1)] ['b' (some 2)]]))
    %+  expect-eq
      !>  ~
      !>  (zm (molt ~[['a' `(unit @)`(some 1)] ['b' ~]]))
    %+  expect-eq
      !>  (some ~)
      !>  (zm ~)
  ==
--
