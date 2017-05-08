Define NewList _shHTTPFIELDS()

Procedure ProcessHTTP(socket, *request)
  Protected Request.HTTPREQUEST
  Protected Request$ = PeekS(*request,-1,#PB_UTF8)
  Protected *send = AllocateMemory(200)
  
  RequestData$ = StringField(Request$,1,#LF$)
  RequestParams$ = Right(Request$,Len(Request$)-Len(RequestData$))
  
  With Request
    \Type = StringField(RequestData$,1," ")
    \Target = StringField(RequestData$,2," ")
    \Version = StringField(RequestData$,3," ")
    
    \Source = GetHTTPField(Request$,"Host")
    
    If Right(\Target,1) = "/"
      \Target + DefaultIndex$
    EndIf
    
  EndWith
  
  Select Request\Type
    Case "GET"
      *send = GenerateHTTPPacket(*send, DefaultRoot$ + ReplaceString(Request\Target, "/", "\"))
      
      If *send
        SendPacket(socket, *send)
      Else
        *send = AllocateMemory(200)
        BuildHeader(*send,#HTTP_NOT_FOUND$,0,"none/none")
        SendPacket(socket, *send)
        
        *send = GenerateHTTPPacket(*send,DefaultError$ + Default404$)
         SendPacket(socket, *send)
      EndIf
      
    Case "POST"
      BuildHeader(*send,#HTTP_NOT_IMPL$,0,"none/none")
      SendPacket(socket, *send)
      
    Default
      BuildHeader(*send,#HTTP_INTERNAL_ERR$,0,"none/none")
      SendPacket(socket, *send)
      
  EndSelect
  
EndProcedure

Procedure.s GetHTTPField(Request$, Label$)
  Protected Field$
  
  For i=1 To CountString(Request$,#LF$)
    Field$ = StringField(Request$,i,#LF$)
    Debug Field$
    If FindString(Field$,Label$)
      Break 
    EndIf
  Next
  
  ProcedureReturn StringField(Field$,2,": ")
EndProcedure

Procedure ExamineHTTPFields(Request$)
  
EndProcedure

Procedure NextHTTPField()
  
EndProcedure

Procedure GetHTTPFieldName()
  
EndProcedure

Procedure GetHTTPFieldValue()
  
EndProcedure


; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 35
; FirstLine = 15
; Folding = --
; EnableXP