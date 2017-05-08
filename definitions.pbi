
#HTTP_OK$ = "200 OK"
#HTTP_EMPTY$ = "201 NO CONTENT"
#HTTP_NOT_FOUND$ = "404 NOT FOUND"
#HTTP_FORBIDDEN$ = "403 FORBIDDEN"
#HTTP_ILLU$ = "420 ILLUMINATI COMPLOT"
#HTTP_INTERNAL_ERR$ = "500 INTERNAL ERROR"
#HTTP_NOT_IMPL$ = "501 NOT IMPLEMENTED"

#NET_INPUTBUFFER = 65536
#NET_MAXRETRY = 256

Enumeration Errors
  #ERR_NETWORK=-10
  #ERR_SERVER
  #ERR_SOCKET
  #ERR_MEMORY
  #ERR_SEND
  #ERR_UNABLE
  #ERR_UNKNOWN
EndEnumeration

Global Server$ = #PB_Editor_ProductName + " v"+ #PB_Editor_ProductVersion
Global Port = 80                            ;Port par défaut
Global DefaultRoot$ = "www"                 ;Répertoire Root par défaut (répertoire racine des fichiers servis)
Global DefaultIndex$ = "index.html"        ;Nom de la page index par défaut
Global DefaultHeader$ = DefaultRoot$+"/server/header.hinc";Include HTML utilisé pour la génération de pages index 
Global DefaultFooter$ = DefaultRoot$+"/server/footer.hinc";Include HTML utilisé pour la génération de pages index 

Declare InitServer()
Declare GenerateHTTPPacket(*out, Path$)
Declare LoadData(Path$)
Declare GenerateIndexDocument(Path$)
Declare BuildHeader(*out, Code$, Length, ContentType$)
Declare.s GetHTTPField(Request$, Label$)

Structure HTTPREQUEST
  Type.s
  Target.s
  Version.s
  Source.s
  Map Fields.s()
EndStructure

IncludeFile "functions.pbi"
IncludeFile "WebProvider.pbi"
IncludeFile "HTTPManager.pbi"


; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 27
; EnableXP