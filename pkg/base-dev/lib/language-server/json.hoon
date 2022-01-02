/-  lsp=language-server
|%
::
++  util
  |%
  ++  get-json-string
    |=  [jon=(map @t json) key=@t]
    ^-  (unit cord)
    =/  cord-jon=(unit json)
      (~(get by jon) key)
    ?~  cord-jon
      ~
    ?>  ?=([%s *] u.cord-jon)
    `p.u.cord-jon
  --
::
::
++  dejs
  =,  dejs:format
  |%
  ++  request
    |=  jon=json
    ?>  ?=([%o *] jon)
    =/  method=cord
      %-  method
      (trip (need (get-json-string:util p.jon 'method')))
    =/  id=cord
      (need (get-json-string:util p.jon 'id'))
    =/  params=json
      (~(got by p.jon) 'params')
    ^-  all:request:lsp
    |^
      ?+  method  [%unknown jon]
        %text-document--hover       (text-document--hover params id)
        %text-document--completion  (text-document--completion params id)
      ==
      ::
      ++  text-document--hover
        |=  [params=json id=cord]
        ^-  text-document--hover:request:lsp
        :+  %text-document--hover
          id
        %.  params
        %:  ot
          position+position
          'textDocument'^text-document-id
          ~
        ==
      ::
      ++  text-document--completion
        |=  [params=json id=cord]
        :+  %text-document--completion  id
        %.  params
        %:  ot
          position+position
          'textDocument'^text-document-id
          ~
        ==
      --
  ::
  ++  notification
    |=  jon=json
    ?>  ?=([%o *] jon)
    =/  method=cord
      %-  method
      (trip (need (get-json-string:util p.jon 'method')))
    =/  params=json
      (~(got by p.jon) 'params')
    ^-  all:notification:lsp
    |^
      ?+  method  [%unknown jon]
          %text-document--did-change
        (text-document--did-change params)
          %text-document--did-open
        (text-document--did-open params)
          %text-document--did-save
        (text-document--did-save params)
          %text-document--did-close
        (text-document--did-close params)
      ==
      ::
      ++  text-document--did-save
        |=  jon=json
        ^-  text-document--did-save:notification:lsp
        ?>  ?=([%o *] jon)
        =/  doc-id
          (~(got by p.jon) 'textDocument')
        :-  %text-document--did-save
        (text-document-id doc-id)
      ::
      ++  text-document--did-close
        |=  jon=json
        ^-  text-document--did-close:notification:lsp
        ?>  ?=([%o *] jon)
        =/  doc-id
          (~(got by p.jon) 'textDocument')
        :-  %text-document--did-close
        (text-document-id doc-id)
      ::
      ++  text-document--did-change
        |=  jon=json
        ^-  text-document--did-change:notification:lsp
        :-  %text-document--did-change
        %.  jon
        %:  ot
          'textDocument'^text-document-id
          'contentChanges'^text-document-changes
          ~
        ==
      ::
      ++  text-document--did-open
        |=  jon=json
        ^-  text-document--did-open:notification:lsp
        ?>  ?=([%o *] jon)
        :-  %text-document--did-open
        (text-document-item (~(got by p.jon) 'textDocument'))
      --
    ::  Utilities
    ::
  ++  text-document-item
    |=  jon=json
    ^-  text-document-item:lsp
    %.  jon
    %:  ot
      uri+so
      version+(mu nu)
      text+so
      ~
    ==
  ::
  ++  text-document-id
    %-  ot
    :~  'uri'^so
        'version'^(pe ~ nu)
    ==
  ::
  ++  text-document-changes
    %-  ar
    %-  ot
    :~  'range'^(pe ~ range)
        'rangeLength'^(pe ~ nu)
        'text'^so
    ==
  ::
  ++  method
    |=  =tape
    ^-  cord
    %-  crip  %-  zing
    %+  join  "--"
    ^-  (list ^tape)
    %+  turn
      ^-  (list (list ^tape))
      %+  scan
        tape
      %+  more
        fas
      ;~  plug
        (star low)
        (star ;~(plug (cook |=(a=@ (add a 32)) hig) (star low)))
      ==
    |=  words=(list ^tape)
    ^-  ^tape
    (zing (join "-" words))
  ::
  ++  range
    %:  ot
      start+position
      end+position
      ~
    ==
  ::
  ++  position
    %:  ot
        line+nu
        character+nu
        ~
    ==
  --
::
++  enjs
  =,  enjs:format
  |%
  ++  text-document--publish-diagnostics
    |=  pub=text-document--publish-diagnostics:notification:lsp
    ^-  json
    %:  pr
      uri+(co uri.pub)
      diagnostics+(ls diagnostics.pub diagnostic)
      ~
    ==
  ++  notification
    |=  notification=all:notification:lsp
    ^-  json
    =/  params=json
      ?+  -.notification  !!
            %text-document--publish-diagnostics
          (text-document--publish-diagnostics notification)
        ==
    ~!  -.notification
    =/  method=cord  (crip (unparse-method -.notification))
    %-  pr
    :~
      method+(co method)
      params+params
    ==
  ::
  ++  response
    |=  res=all:response:lsp
    ^-  json
    |^
      ?-  -.res
        %text-document--hover       (text-document--hover res)
        %text-document--completion  (text-document--completion res)
      ==
      ::
      ++  wrap-in-id
        |=  [id=cord res=json]
        %:  pr
          id+(co id)
          result+res
          ~
        ==
      ++  text-document--hover
        |=  hov=text-document--hover:response:lsp
        %+  wrap-in-id  id.hov
        %+  ob  'contents'
        ?~  contents.hov
          ~
        (co u.contents.hov)
      ::
      ++  text-document--completion
        |=  com=text-document--completion:response:lsp
        %+  wrap-in-id   id.com
        (ls completion.com completion-item)
      --
  ++  unparse-method
    |=  c=cord
    ^-  tape
    %+  rash  c
    %+  cook  |=(l=(list tape) (zing (join "/" l)))
    %+  more  (jest '--')
    %+  cook
      |=  tapes=(list tape)
      ^-  tape
      ?~  tapes  ~
      %-  zing
      :-  i.tapes
      %+  turn  t.tapes
      |=  t=tape
      ^-  tape
      ?~  t  ~
      [`@tD`(sub i.t 32) t.t]
    %+  more
      ;~(less (jest '--') hep)
    (star alf)
  ::
  ++  completion-item
    |=  com=completion-item:lsp
    ^-  json
    %:  pr
      label+(co label.com)
      detail+(co detail.com)
      kind+(nu kind.com)
      'documentation'^(co doc.com)
      'insertText'^(co insert-text.com)
      'insertTextFormat'^(nu insert-text-format.com)
      ~
    ==
  ::
  ++  position
    |=  =position:lsp
    ^-  json
    %:  pr
      line+(nu row.position)
      character+(nu col.position)
      ~
    ==
  ::
  ++  range
    |=  =range:lsp
    ^-  json
    %:  pr
      start+(position start.range)
      end+(position end.range)
      ~
    ==
  ::
  ++  diagnostic
    |=  diag=diagnostic:lsp
    ^-  json
    %:  pr
      range+(range range.diag)
      severity+(nu severity.diag)
      message+(co message.diag)
      ~
    ==
  ::
  --
--
