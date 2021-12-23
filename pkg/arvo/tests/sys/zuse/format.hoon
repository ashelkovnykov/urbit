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
  ++  obj  `json`(ob:enjs foo)
  ++  pai  `json`(pr:enjs ~[foo bar])
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
      !>  (ob foo:ex)
    ::  complex object
    ::
    %+  expect-eq
      !>  [%o (molt ~[foo:ex bar:ex])]
      !>  (pr ~[foo:ex bar:ex])
    ::  list
    ::
    %+  expect-eq
      !>  [%a ~[num:ex num:ex num:ex]]
      !>  (ls ~[101 101 101] nu)
    ::  set
    ::
    %+  expect-eq
      !>  [%a ~[[%s 'c'] [%s 'a'] [%s 'b']]]
      !>  (st (silt ~['a' 'b' 'c' 'c' 'b' 'a']) co)
    ::  boolean
    ::
    %+  expect-eq
      !>  tru:ex
      !>  (bo &)
    ::  cord
    ::
    %+  expect-eq
      !>  str:ex
      !>  (co 'hey')
    ::  tape
    ::
    %+  expect-eq
      !>  str:ex
      !>  (ta "hey")
    ::  wall
    ::
    %+  expect-eq
      ::  uses of-wall, so adds the trailing newline
      ::
      !>  wal:ex
      !>  (wl ~["hello" "world"])
    ::  ship name
    ::
    %+  expect-eq
      !>  [%s '~zod']
      !>  (hp ~zod)
    ::  ship name, no '~'
    ::
    %+  expect-eq
      !>  [%s 'zod']
      !>  (hl ~zod)
    ::  number
    ::
    %+  expect-eq
      !>  [%n '0']
      !>  (nu 0)
    %+  expect-eq
      !>  [%n '10']
      !>  (nu 0xa)
    %+  expect-eq
      !>  num:ex
      !>  (nu 101)
    %+  expect-eq
      !>  [%n '1000']
      !>  (nu 1.000)
    ::  number as string
    ::
    %+  expect-eq
      !>  [%s '0']
      !>  (ns 0)
    %+  expect-eq
      !>  [%s '10']
      !>  (ns 10)
    %+  expect-eq
      !>  [%s '100']
      !>  (ns 100)
    %+  expect-eq
      !>  [%s '1000']
      !>  (ns 1.000)
    ::  hoon num as string
    ::
    %+  expect-eq
      !>  [%s '0']
      !>  (nh %u 0)
    %+  expect-eq
      !>  [%s '1.000']
      !>  (nh %ud 1.000)
    %+  expect-eq
      !>  [%s '0xa.baca']
      !>  (nh %ux 0xa.baca)
    %+  expect-eq
      !>  [%s '384.319.963']
      !>  (nh %u 0vb.egger)
    ::  sec time
    ::
    %+  expect-eq
      !>  tsc:ex
      !>  (sc ~1970.1.1..0.0.1)
    ::  ms time
    ::
    %+  expect-eq
      !>  tms:ex
      !>  (ms ~1970.1.1..0.0.1)
    %+  expect-eq
      !>  tms:ex
      !>  (ms (from-unix-ms:chrono:userlib 1.000))
    ::  date
    ::
    %+  expect-eq
      !>  [%s '~2016.11.9..07.47.00']
      !>  (da (from-unix:chrono:userlib 1.478.677.620))
    ::  path
    ::
    %+  expect-eq
      !>  [%s (crip "/~zod/base")]
      !>  (pa [~.~zod ~.base ~])
    ::  tank
    ::
    %+  expect-eq
      !>  [%a ~[[%s 'abc']]]
      !>  (tk leaf+"abc")
    %+  expect-eq
      !>  [%a ~[[%s '[a b c]']]]
      !>  (tk [%rose [" " "[" "]"] leaf+"a" leaf+"b" leaf+"c" ~])
    %+  expect-eq
      !>  [%a ~[[%s '!(a:b:c)']]]
      !>  (tk [%palm [":" "!" "(" ")"] leaf+"a" leaf+"b" leaf+"c" ~])
    ::  unit
    ::
    %+  expect-eq
      !>  ~
      !>  (un ~ nu)
    %+  expect-eq
      !>  num:ex
      !>  (un (some 101) nu)
  ==
::  dejs - recursive processing of `json` values
::
::  decoders for nulls, booleans, integers, and strings
::
++  test-dejs-primitives
  =,  dejs
  ;:  weld
    ::  null
    ::
    %+  expect-eq
      !>  ~
      !>  (ul nul:ex)
    %-  expect-fail
      |.  (ul num:ex)
    ::  boolean
    ::
    %+  expect-eq
      !>  &
      !>  (bo tru:ex)
    %+  expect-eq
      !>  |
      !>  (bo [%b |])
    %-  expect-fail
      |.  (bo [%n '0'])
    ::  number as integer
    ::
    %+  expect-eq
      !>  101
      !>  (ni num:ex)
    %-  expect-fail
      |.  (ni tru:ex)
    ::  number as hex
    ::
    %+  expect-eq
      !>  257
      !>  (nu num:ex)
    %-  expect-fail
      |.  (nu tru:ex)
    ::  number as cord
    ::
    %+  expect-eq
      !>  '101'
      !>  (no num:ex)
    %-  expect-fail
      |.  (no tru:ex)
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
  ==
::  decoder for real numbers
::
::    The json parser (+de-json:html) only matches real numbers to a regex. The
::    real parsing work is done by +ne:dejs:format. Therefore, every valid
::    +de-json:html real number regex must be tested here.
::
++  test-dejs-real
  =,  dejs
  ;:  weld
    ::  various ways of expressing 0
    ::
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e+0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e+0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e+000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e+000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e+1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e+1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e-0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e-0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e-000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e-000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0e-1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0e-1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E+0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E+0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E+000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E+000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E+1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E+1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E-0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E-0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E-000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E-000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0E-1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0E-1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e+0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e+0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e+000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e+000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e+1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e+1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e-0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e-0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e-000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e-000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0e-1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0e-1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E+0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E+0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E+000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E+000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E+1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E+1'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E-0'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E-0'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E-000'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E-000'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '0.0E-1'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-0.0E-1'])
    ::  non-zero floating points
    ::
    %+  expect-eq
      !>  .~1
      !>  (ne [%n '1.0'])
    %+  expect-eq
      !>  .~1.1
      !>  (ne [%n '1.1'])
    %+  expect-eq
      !>  .~-1.1
      !>  (ne [%n '-1.1'])
    %+  expect-eq
      !>  .~123.456
      !>  (ne [%n '123.456'])
    %+  expect-eq
      !>  .~-123.456
      !>  (ne [%n '-123.456'])
    ::  non-zero exponent & base
    ::
    %+  expect-eq
      !>  .~10
      !>  (ne [%n '1e1'])
    %+  expect-eq
      !>  .~-10
      !>  (ne [%n '-1e1'])
    %+  expect-eq
      !>  .~10
      !>  (ne [%n '1e+1'])
    %+  expect-eq
      !>  .~-10
      !>  (ne [%n '-1e+1'])
    %+  expect-eq
      !>  .~0.1
      !>  (ne [%n '1e-1'])
    %+  expect-eq
      !>  .~-0.1
      !>  (ne [%n '-1e-1'])
    %+  expect-eq
      !>  .~10
      !>  (ne [%n '1E1'])
    %+  expect-eq
      !>  .~-10
      !>  (ne [%n '-1E1'])
    %+  expect-eq
      !>  .~10
      !>  (ne [%n '1E+1'])
    %+  expect-eq
      !>  .~-10
      !>  (ne [%n '-1E+1'])
    %+  expect-eq
      !>  .~0.1
      !>  (ne [%n '1E-1'])
    %+  expect-eq
      !>  .~-0.1
      !>  (ne [%n '-1E-1'])
    ::  floating point exponent base
    ::
    %+  expect-eq
      !>  .~11
      !>  (ne [%n '1.1e1'])
    %+  expect-eq
      !>  .~-11
      !>  (ne [%n '-1.1e1'])
    %+  expect-eq
      !>  .~11
      !>  (ne [%n '1.1e+1'])
    %+  expect-eq
      !>  .~-11
      !>  (ne [%n '-1.1e+1'])
    %+  expect-eq
      !>  .~0.11
      !>  (ne [%n '1.1e-1'])
    %+  expect-eq
      !>  .~-0.11
      !>  (ne [%n '-1.1e-1'])
    %+  expect-eq
      !>  .~11
      !>  (ne [%n '1.1E1'])
    %+  expect-eq
      !>  .~-11
      !>  (ne [%n '-1.1E1'])
    %+  expect-eq
      !>  .~11
      !>  (ne [%n '1.1E+1'])
    %+  expect-eq
      !>  .~-11
      !>  (ne [%n '-1.1E+1'])
    %+  expect-eq
      !>  .~0.11
      !>  (ne [%n '1.1E-1'])
    %+  expect-eq
      !>  .~-0.11
      !>  (ne [%n '-1.1E-1'])
    ::  large base and exponent
    ::
    %+  expect-eq
      !>  .~1.23e9
      !>  (ne [%n '123e7'])
    %+  expect-eq
      !>  .~-1.23e9
      !>  (ne [%n '-123e7'])
    %+  expect-eq
      !>  .~1.23e9
      !>  (ne [%n '123e+7'])
    %+  expect-eq
      !>  .~-1.23e9
      !>  (ne [%n '-123e+7'])
    %+  expect-eq
      !>  .~1.23e-5
      !>  (ne [%n '123e-7'])
    %+  expect-eq
      !>  .~-1.23e-5
      !>  (ne [%n '-123e-7'])
    %+  expect-eq
      !>  .~1.23e9
      !>  (ne [%n '123E7'])
    %+  expect-eq
      !>  .~-1.23e9
      !>  (ne [%n '-123E7'])
    %+  expect-eq
      !>  .~1.23e9
      !>  (ne [%n '123E+7'])
    %+  expect-eq
      !>  .~-1.23e9
      !>  (ne [%n '-123E+7'])
    %+  expect-eq
      !>  .~1.23e-5
      !>  (ne [%n '123E-7'])
    %+  expect-eq
      !>  .~-1.23e-5
      !>  (ne [%n '-123E-7'])
    :: large floating point base
    ::
    %+  expect-eq
      !>  .~1.23456e9
      !>  (ne [%n '123.456e7'])
    %+  expect-eq
      !>  .~-1.23456e9
      !>  (ne [%n '-123.456e7'])
    %+  expect-eq
      !>  .~1.23456e9
      !>  (ne [%n '123.456e+7'])
    %+  expect-eq
      !>  .~-1.23456e9
      !>  (ne [%n '-123.456e+7'])
    %+  expect-eq
      !>  .~1.23456e-5
      !>  (ne [%n '123.456e-7'])
    %+  expect-eq
      !>  .~-1.23456e-5
      !>  (ne [%n '-123.456e-7'])
    %+  expect-eq
      !>  .~1.23456e9
      !>  (ne [%n '123.456E7'])
    %+  expect-eq
      !>  .~-1.23456e9
      !>  (ne [%n '-123.456E7'])
    %+  expect-eq
      !>  .~1.23456e9
      !>  (ne [%n '123.456E+7'])
    %+  expect-eq
      !>  .~-1.23456e9
      !>  (ne [%n '-123.456E+7'])
    %+  expect-eq
      !>  .~1.23456e-5
      !>  (ne [%n '123.456E-7'])
    %+  expect-eq
      !>  .~-1.23456e-5
      !>  (ne [%n '-123.456E-7'])
    ::  ambiguous input
    ::
    %+  expect-eq
      !>  .~1e-78
      !>  (ne [%n '0.0000000000000000000000000000000000000000000000\
            /00000000000000000000000000000001'])
    %+  expect-eq
      !>  .~1.23123123123123123123e29
      !>  (ne [%n '123123123123123123123123123123'])
    %+  expect-eq
      !>  .~-1.23123123123123123123e29
      !>  (ne [%n '-123123123123123123123123123123'])
    %+  expect-eq
      !>  .~inf
      !>  (ne [%n '1e88888888'])
    %+  expect-eq
      !>  .~-inf
      !>  (ne [%n '-1e88888888'])
    %+  expect-eq
      !>  .~0
      !>  (ne [%n '1e-88888888'])
    %+  expect-eq
      !>  .~-0
      !>  (ne [%n '-1e-88888888'])
    %+  expect-eq
      !>  .~inf
      !>  (ne [%n '1e0000000088888888'])
    %+  expect-eq
      !>  .~-inf
      !>  (ne [%n '-1e0000000088888888'])
    %+  expect-eq
      !>  .~1.23123e100005
      !>  (ne [%n '123123e100000'])
    %+  expect-eq
      !>  .~-1.23123e100005
      !>  (ne [%n '-123123e100000'])
    %+  expect-eq
      !>  .~1.23e-1000002
      !>  (ne [%n '123e-1000000'])
  ==
::  decoder transformers
::
++  test-dejs-transformers
  =,  dejs
  ;:  weld
    ::  generic transformer
    ::
    %+  expect-eq
      !>  100
      !>  ((cu dec ni) num:ex)
    %+  expect-eq
      !>  1
      !>  ((cu |=(a=@u (mod a 10)) ni) num:ex)
    %+  expect-eq
      !>  10
      !>  ((cu |=(a=@u (div a 10)) ni) num:ex)
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((cu |=(a=@u (div a 10)) ni) tru:ex)
    ::  parse to unit
    ::
    %+  expect-eq
      !>  ~
      !>  ((mu ni) nul:ex)
    %+  expect-eq
      !>  (some 101)
      !>  ((mu ni) num:ex)
    %-  expect-fail
      |.  ((mu ni) tru:ex)
    ::  generic string parser
    ::
    %+  expect-eq
      !>  'hey'
      !>  ((su (jest 'hey')) str:ex)
    %+  expect-eq
      !>  "hey"
      !>  ((su (stun [3 3] alf)) str:ex)
    %-  expect-fail
      |.  ((su nix) tru:ex)
  ==
::  transformed primitive decoders
::
++  test-dejs-transformed-primitives
  =,  dejs
  ;:  weld
    ::  date as unix ms timestamp
    ::
    %+  expect-eq
      !>  ~1970.1.1..00.00.01
      !>  (di tms:ex)
    %-  expect-fail
      |.  (di tru:ex)
    ::  date as unix ms timestamp
    ::
    %+  expect-eq
      !>  ~1970.1.1..00.00.01
      !>  (du tsc:ex)
    %-  expect-fail
      |.  (du tru:ex)
    ::  add prefix to decoded value
    ::
    %+  expect-eq
      !>  ['a' 101]
      !>  ((pe 'a' ni) num:ex)
    %-  expect-fail
      |.  ((pe 'a' ni) tru:ex)
    ::  path
    ::
    %+  expect-eq
      !>  ~[%a %b %c]
      !>  (pa [%s '/a/b/c'])
    %-  expect-fail
      |.  (pa tru:ex)
  ==
::  array decoders
::
++  test-dejs-arrays
  =,  dejs
  ;:  weld
    ::  array as list of single type
    ::
    %+  expect-eq
      !>  ~[101]
      !>  ((ar ni) [%a ~[num:ex]])
    %+  expect-eq
      !>  ~[1 2 3]
      !>  ((ar ni) [%a ~[[%n '1'] [%n '2'] [%n '3']]])
    %-  expect-fail
      |.  ((ar ni) num:ex)
    %-  expect-fail
      |.  ((ar ni) [%a ~[str:ex]])
    %-  expect-fail
      |.  ((ar ni) [%a ~[num:ex str:ex]])
    ::  array as set of single type
    ::
    ::    `as` is just a transformed `ar`
    ::
    %+  expect-eq
      !>  (silt ~[101])
      !>  ((as ni) [%a ~[num:ex]])
    ::  array as tuple of any types
    ::
    ::    Decoders must match exactly
    ::
    %+  expect-eq
      !>  [101 'hey']
      !>  ((at ~[ni so]) [%a ~[num:ex str:ex]])
    %-  expect-fail                               ::  crash on too many decoders
      |.  ((at ~[ni so]) [%a ~[num:ex]])
    %-  expect-fail                               ::  crash on too few decoders
      |.  ((at ~[ni]) [%a ~[num:ex str:ex]])
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((at ~[ni so]) [%a ~[str:ex num:ex]])
  ==
::  object decoders
::
++  test-dejs-objects
  =,  dejs
  ;:  weld
    ::  single-property object XOR
    ::
    %+  expect-eq
      !>  ['foo' 101]
      !>  ((of ~[['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  ['foo' 101]
      !>  ((of ~[['bar' so] ['foo' ni]]) obj:ex)
    %-  expect-fail
      |.  ((of ~[['foo' ni]]) num:ex)
    %-  expect-fail                               ::  crash if no matching key
      |.  ((of ~[['bar' so]]) obj:ex)
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((of ~[['foo' so]]) obj:ex)
    %-  expect-fail                               ::  crash if 2+ properties
      |.  ((of ~[['bar' so] ['foo' ni]]) pai:ex)
    ::  exact-shape object to tuple
    ::
    %+  expect-eq
      !>  [101 'hey']
      !>  ((ot ~[['foo' ni] ['bar' so]]) pai:ex)
    %+  expect-eq
      !>  ['hey' 101]
      !>  ((ot ~[['bar' so] ['foo' ni]]) pai:ex)
    %+  expect-eq
      !>  ['hey']
      !>  ((ot ~[['bar' so]]) pai:ex)
    %-  expect-fail
      |.  ((ot ~[['foo' ni]]) num:ex)
    %-  expect-fail                               ::  crash if no matching key
      |.  ((ot ~[['foo' ni] ['bar' so] ['baz' so]]) pai:ex)
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((ot ~[['foo' so] ['bar' so]]) pai:ex)
    ::  simple object to map (arbitrary keys, single type)
    ::
    %+  expect-eq
      !>  `(tree [p=@t q=@])`~
      !>  ((om ni) [%o ~])
    %+  expect-eq
      !>  (malt ~[['foo' 101]])
      !>  ((om ni) obj:ex)
    %+  expect-eq
      !>  (malt ~[['a' 101] ['b' 101]])
      !>  ((om ni) (pr:enjs ~[['a' num:ex] ['b' num:ex]]))
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((om ni) pai:ex)
    ::  simple bject to map, but keys must match rule
    ::
    %+  expect-eq
      !>  `(tree [p=@t q=@])`~
      !>  ((op nix ni) [%o ~])
    %+  expect-eq
      !>  (malt ~[['foo' 101]])
      !>  ((op nix ni) obj:ex)
    %+  expect-eq
      !>  (malt ~[['foo' 101]])
      !>  ((op (jest 'foo') ni) obj:ex)
    %+  expect-eq
      !>  (malt ~[['a' 101] ['b' 101]])
      !>  ((op alf ni) (pr:enjs ~[['a' num:ex] ['b' num:ex]]))
    %-  expect-fail                               ::  crash on decoder mismatch
      |.  ((op nix so) obj:ex)
    %-  expect-fail                               ::  crash on rule mismatch
      |.  ((op (jest 'bar') ni) obj:ex)
  ==
::  dejs-soft - recursive processing of `json` values
::
::    These functions return units, which will be nil if the input doesn't match
::    the defined structure.
::
::  decoders for nulls, booleans, numbers, and strings
::
++  test-dejs-soft-primitives
  =,  dejs-soft
  ;:  weld
    ::  null
    ::
    %+  expect-eq
      !>  `~
      !>  (ul nul:ex)
    %+  expect-eq
      !>  ~
      !>  (ul num:ex)
    ::  boolean
    ::
    %+  expect-eq
      !>  `&
      !>  (bo tru:ex)
    %+  expect-eq
      !>  `|
      !>  (bo [%b |])
    %+  expect-eq
      !>  ~
      !>  (bo [%n '0'])
    ::  number as integer
    ::
    %+  expect-eq
      !>  `101
      !>  (ni num:ex)
    %+  expect-eq
      !>  ~
      !>  (ni tru:ex)
    ::  number as cord
    ::
    %+  expect-eq
      !>  `'101'
      !>  (no num:ex)
    %+  expect-eq
      !>  ~
      !>  (no tru:ex)
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
  ==
::  decoder transformers
::
++  test-dejs-soft-transformers
  =,  dejs-soft
  ;:  weld
    ::  generic transformer (gate returns unit)
    ::
    %+  expect-eq
      !>  `100
      !>  ((ci |=(a=@u (some (dec a))) ni) num:ex)
    %+  expect-eq
      !>  `1
      !>  ((ci |=(a=@u (some (mod a 10))) ni) num:ex)
    %+  expect-eq
      !>  `10
      !>  ((ci |=(a=@u (some (div a 10))) ni) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((ci |=(a=@u (some (div a 10))) ni) tru:ex)
    %+  expect-eq
      !>  ~
      !>  ((ci |=(* ~) ni) num:ex)
    ::  generic transformer (gate returns non-unit)
    ::
    %+  expect-eq
      !>  `100
      !>  ((cu dec ni) num:ex)
    %+  expect-eq
      !>  `1
      !>  ((cu |=(a=@u (mod a 10)) ni) num:ex)
    %+  expect-eq
      !>  `10
      !>  ((cu |=(a=@u (div a 10)) ni) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((cu |=(a=@u (div a 10)) ni) tru:ex)
    ::  generic string parser
    ::
    %+  expect-eq
      !>  `'hey'
      !>  ((su (jest 'hey')) str:ex)
    %+  expect-eq
      !>  `"hey"
      !>  ((su (stun [3 3] alf)) str:ex)
    %+  expect-eq
      !>  ~
      !>  ((su nix) tru:ex)
    %+  expect-eq
      !>  ~
      !>  ((su ace) str:ex)
  ==
::  transformed primitive decoders
::
++  test-dejs-soft-transformed-primitives
  =,  dejs-soft
  ;:  weld
    ::  date as unix ms timestamp
    ::
    %+  expect-eq
      !>  `~1970.1.1..00.00.01
      !>  (di tms:ex)
    %+  expect-eq
      !>  ~
      !>  (di tru:ex)
    ::  add prefix to decoded value
    ::
    %+  expect-eq
      !>  `['a' 101]
      !>  ((pe 'a' ni) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((pe 'a' ni) tru:ex)
  ==
::  unit/collection decoder helpers
::
++  test-dejs-soft-helpers
  =,  dejs-soft
  =+  all=`(list (unit @))`~[(some 1) (some 2) (some 3)]
  =+  nall=`(list (unit @))`~[(some 1) ~ (some 3)]
  ;:  weld
    ::  collapse list of units to boolean (true if all full, false otherwise)
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
    ::  collapse (list (unit)) -> (unit (list))
    ::
    %+  expect-eq
      !>  (some ~[1 2 3])
      !>  (zl all)
    %+  expect-eq
      !>  (some ~)
      !>  (zl ~)
    %+  expect-eq
      !>  ~
      !>  (zl nall)
    ::  collapse (map * (unit *)) -> (unit (map * *))
    ::
    %+  expect-eq
      !>  (some (malt ~[['a' 1] ['b' 2]]))
      !>  (zm (malt (limo ~[['a' (some 1)] ['b' (some 2)]])))
    %+  expect-eq
      !>  (some ~)
      !>  (zm ~)
    %+  expect-eq
      !>  ~
      !>  (zm (malt (limo ~[['a' (some 1)] ['b' ~]])))
    ::  collapse (pole (unit)) -> (unit (pole))
    ::
    %+  expect-eq
      !>  [1 2 3]
      !>  (zp all)
    %-  expect-fail
      |.  (zp nall)
    %-  expect-fail
      |.  (zp ~)
    ::  collapse (set (unit *)) -> (unit (set *))
    ::
    %+  expect-eq
      !>  (some (silt ~[1 2]))
      !>  (zs (silt (limo ~[(some 1) (some 2)])))
    %+  expect-eq
      !>  (some ~)
      !>  (zs ~)
    %+  expect-eq
      !>  ~
      !>  (zs (silt (limo ~[(some 1) ~])))
  ==
::  array decoders
::
++  test-dejs-soft-arrays
  =,  dejs-soft
  ;:  weld
    ::  array as list of single type
    ::
    %+  expect-eq
      !>  `~[101]
      !>  ((ar ni) [%a ~[num:ex]])
    %+  expect-eq
      !>  `~[1 2 3]
      !>  ((ar ni) [%a ~[[%n '1'] [%n '2'] [%n '3']]])
    %+  expect-eq
      !>  ~
      !>  ((ar ni) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((ar ni) [%a ~[str:ex]])
    %+  expect-eq
      !>  ~
      !>  ((ar ni) [%a ~[num:ex str:ex]])
    ::  array as tuple of any types
    ::
    ::    Decoders must match exactly
    ::
    %+  expect-eq
      !>  `[101 'hey']
      !>  ((at ~[ni so]) [%a ~[num:ex str:ex]])
    %+  expect-eq                                 ::  too many decoders
      !>  ~
      !>  ((at ~[ni so]) [%a ~[num:ex]])
    %+  expect-eq                                 ::  too few decoders
      !>  ~
      !>  ((at ~[ni]) [%a ~[num:ex str:ex]])
    %+  expect-eq                                 ::  decoder order mismatch
      !>  ~
      !>  ((at ~[ni so]) [%a ~[str:ex num:ex]])
  ==
::  decoding objects
::
++  test-dejs-soft-objects
  =,  dejs-soft
  ;:  weld
    ::  single-property object XOR
    ::
    %+  expect-eq
      !>  `['foo' 101]
      !>  ((of ~[['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  `['foo' 101]
      !>  ((of ~[['bar' so] ['foo' ni]]) obj:ex)
    %+  expect-eq
      !>  ~
      !>  ((of ~) num:ex)
    %+  expect-eq
      !>  ~
      !>  ((of ~[['foo' ni]]) num:ex)
    %+  expect-eq                                 ::  no matching key
      !>  ~
      !>  ((of ~[['bar' so]]) obj:ex)
    %+  expect-eq                                 ::  decoder mismatch
      !>  ~
      !>  ((of ~[['foo' so]]) obj:ex)
    %+  expect-eq                                 ::  >1 property
      !>  ~
      !>  ((of ~[['bar' so] ['foo' ni]]) pai:ex)
    ::  exact-shape object to tuple
    ::
    %+  expect-eq
      !>  `[101 'hey']
      !>  ((ot ~[['foo' ni] ['bar' so]]) pai:ex)
    %+  expect-eq
      !>  `['hey' 101]
      !>  ((ot ~[['bar' so] ['foo' ni]]) pai:ex)
    %+  expect-eq
      !>  `['hey']
      !>  ((ot ~[['bar' so]]) pai:ex)
    %+  expect-eq
      !>  ~
      !>  ((ot ~[['foo' ni]]) num:ex)
    %+  expect-eq                                 ::  no matching key
      !>  ~
      !>  ((ot ~[['foo' ni] ['bar' so] ['baz' so]]) pai:ex)
    %+  expect-eq                                 ::  decoder mismatch
      !>  ~
      !>  ((ot ~[['foo' so] ['bar' so]]) pai:ex)
    ::  simple object to map (arbitrary keys, single type)
    ::
    %+  expect-eq
      !>  [~ `(tree [p=@t q=@])`~]
      !>  ((om ni) [%o ~])
    %+  expect-eq
      !>  `(malt ~[['foo' 101]])
      !>  ((om ni) obj:ex)
    %+  expect-eq
      !>  `(malt ~[['a' 101] ['b' 101]])
      !>  ((om ni) (pr:enjs ~[['a' num:ex] ['b' num:ex]]))
    %+  expect-eq                                 ::  decoder mismatch
      !>  ~
      !>  ((om ni) pai:ex)
    ::  simple object to map, but keys must match rule
    ::
    %+  expect-eq
      !>  [~ `(tree [p=@t q=@])`~]
      !>  ((op nix ni) [%o ~])
    %+  expect-eq
      !>  `(malt ~[['foo' 101]])
      !>  ((op nix ni) obj:ex)
    %+  expect-eq
      !>  `(malt ~[['foo' 101]])
      !>  ((op (jest 'foo') ni) obj:ex)
    %+  expect-eq
      !>  `(malt ~[['a' 101] ['b' 101]])
      !>  ((op alf ni) (pr:enjs ~[['a' num:ex] ['b' num:ex]]))
    %+  expect-eq                                 ::  decoder mismatch
      !>  ~
      !>  ((op nix so) obj:ex)
    %+  expect-eq                                 ::  rule mismatch
      !>  ~
      !>  ((op (jest 'bar') ni) obj:ex)
  ==
--
