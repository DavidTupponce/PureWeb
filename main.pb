
XIncludeFile "definitions.pbi"

OpenConsole(Server$)

ConsoleColor(0,7)
Print(Space(30)+Server$+Space(30))
ConsoleColor(7,0)
Print(#CRLF$)

*input = InitServer()
Select *input
  Case #ERR_NETWORK
    Error("Error : Can't initialize the network.") : End
  Case #ERR_SERVER
    Error("Error : Can't open server on port "+Str(Port)+". Port in use?") : End
  Case #ERR_MEMORY
    Error("Not enougth memory.") : End
  Default
    ConsoleTitle(Server$ + "Port : "+Port)
    PrintN("Server running on port "+Port)
EndSelect

Repeat
  
  sEvent = NetworkServerEvent()
  socket = EventClient()
  
  If socket
    clientIP = GetClientIP(socket)
  EndIf
  
  Select sEvent
    Case #PB_NetworkEvent_Connect
      PrintN("New client connected : "+IPString(clientIP))
      
    Case #PB_NetworkEvent_Data
      PrintN(IPString(clientIP) + " : data received")
      
      ReceiveNetworkData(socket, *input, #NET_INPUTBUFFER)
      
      ProcessHTTP(socket, *input)
      
    Case #PB_NetworkEvent_Disconnect
      PrintN("Client "+IPString(clientIP)+" has disconnected.")
      
    Case #PB_NetworkEvent_None
      Delay(10)
      
  EndSelect
ForEver


; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 41
; FirstLine = 18
; EnableXP