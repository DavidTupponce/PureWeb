Declare.s GetHTTPField(Request$, Label$)


IncludeFile "definitions.pbi"

Debug GetHTTPField("GET /net_ui/sh/adm.ait?flags=adm&auth=ecdncert.vth.dev4{dfegbsd5xc4254zad0q04cf35.wdf4xf3nu4ds6} HTTP 1/1 "+#LF$+"Host: fs2.nui.adm.pureweb.net"+#LF$+"Content-type: application/none"+#LF$+#LF$,"Host")
Debug GetHTTPField("Host: www.pw.cf","Host")
; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 5
; EnableXP