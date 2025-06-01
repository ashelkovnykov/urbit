::  Kiln: Continuously merge local desk from (optionally-)foreign one
::
::::  /hoon/ota/hood/gen
  ::
/?    310
::
::::
  ::
:-  %say
|=  $:  [now=@da eny=@uvJ bec=beak]
        arg=?([%disable ~] [her=@p sud=(unit desk)])
        ~
    ==
:-  %kiln-install
?:  ?=([%disable ~] arg)
  [%base p.bec %base]
:+  %base  her.arg
?~(sud.arg %kids u.sud.arg)
