Macro Error(Text)
  ConsoleColor(12,0)
  Print(Text)
  ConsoleColor(7,0)
  Print(#CRLF$)
EndMacro


Procedure.s GetDate()   ;Récupérer la date du jour (EN)
  
  Hour$ = FormatDate("%hh:%ii:%ss",Date())
  Year$ = Str(Year(Date()))
  DayOfMonth$ = Str(Day(Date()))
  
  DayOfWeek$ = StringField("Sun,Mon,Tue,Wed,Thu,Fri,Sat", DayOfWeek(Date()) + 1, ",")
  
  Month$ = StringField("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec", Month(Date()), ",")
  
  ProcedureReturn DayOfWeek$ + ", " + DayOfMonth$ + " " + Month$ + " " + Year$ + " " + Hour$
EndProcedure

Procedure InitServer()
  If Not InitNetwork()
    ProcedureReturn #ERR_NETWORK
  Else
    If Not CreateNetworkServer(1,Port)
      ProcedureReturn #ERR_SERVER
    Else
      *recbuf = AllocateMemory(#NET_INPUTBUFFER)
      If Not *recbuf
        ProcedureReturn #ERR_MEMORY
      Else
        ProcedureReturn *recbuf
      EndIf
    EndIf
  EndIf
EndProcedure

Procedure.s GetMIMEType(Path$)
  Protected ContentType$
  Protected ext$ = "."+GetExtensionPart(Path$)
  
  Select ext$                     ;Déterminer le type MIME à inclure dans le header
    Case ".html"
      ContentType$ = "text/html"
      
    Case ".gif"
      ContentType$ = "image/gif"
      
    Case ".jpg"
      ContentType$ = "image/jpeg"
      
    Case ".png"
      ContentType$ = "image/png"
      
    Case ".txt"
      ContentType$ = "text/plain"
      
    Case ".zip"
      ContentType$ = "application/zip"
      
    Case ".css"
      ContentType$ = "text/css"
      
    Case ".js"
      ContentType$ = "application/javascript"
      
    Case ".xml"
      ContentType$ = "application/xml"
      
    Case ".pdf"
      ContentType$ = "application/pdf"
      
    Case ".exe"
      ContentType$ = "application/octet-stream"
      
    Case ".ogg"
      ContentType$ = "application/ogg"
      
    Case ".mp3"
      ContentType$ = "audio/mpeg" ;TODO : Compatibilté Chrome : audio/mp3
      
    Case ".mp4"
      ContentType$ = "video/mp4"
    Default
      ContentType$ = "application/octet-stream"
      
  EndSelect
  ProcedureReturn ContentType$
EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 6
; Folding = -
; EnableXP