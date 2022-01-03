::  API: input auth2 client_secret_*.json for .googleapis.com
::
::::  /hoon/google/init-oauth2/hood/gen
  ::
/?  314
/-  sole
/+  generators
::
::::
  ::
=,  generators
=,  html
=,  format
:-  %ask
|=  $:  [now=@da eny=@uvJ bec=beak]
        [arg=$@(~ [jon=json ~])]
        ~
    ==
^-  (sole-result:sole [%write-sec-atom p=host:eyre q=@])
%+  print  leaf+"Accepting credentials for https://*.googleapis.com"
=+  hot=[%& /com/googleapis]
=-  ?~  arg  -
    (fun.q.q jon.arg)
%+  prompt
  [%& %oauth-json "json credentials: "]
%+  parse  apex:de-json
|=  jon=json
=/  [cid=@t cis=@t]
  ~|  bad-json+jon
  (ot web+(ot 'client_id'^so 'client_secret'^so ~) ~):dejs:format
%+  produce  %write-sec-atom    :: XX typed pair
[hot (of-wain:format cid cis ~)]
