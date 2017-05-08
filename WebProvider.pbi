
Procedure BuildHeader(*out, Code$, Length, ContentType$)  ;Construit le header HTTP en mémoire
  Protected ptr, *init = *out
  ptr = PokeS(*out, "HTTP/1.1 " + Code$   + #CRLF$, -1, #PB_UTF8)                      : *out + ptr
  ptr = PokeS(*out, "Date: " + GetDate() + #CRLF$, -1, #PB_UTF8)                      : *out + ptr
  ptr = PokeS(*out, "Server: "+ Server$ + #CRLF$, -1, #PB_UTF8)                      : *out + ptr
  ptr = PokeS(*out, "Content-Length: " + Str(Length) + #CRLF$, -1, #PB_UTF8)          : *out + ptr
  ptr = PokeS(*out, "Content-Type: " + ContentType$  + #CRLF$, -1, #PB_UTF8)          : *out + ptr
  ptr = PokeS(*out, #CRLF$, -1, #PB_UTF8)                                             : *out + ptr
  
  ProcedureReturn *out - *init
EndProcedure

Procedure GenerateIndexDocument(Path$)
  Protected file, Header$, Footer$, Name$, Content$, *out
  
  If FileSize(DefaultHeader$) <> -1
    file = ReadFile(#PB_Any,DefaultHeader$,#PB_File_SharedRead)
    Header$ = ReadString(file, #PB_File_IgnoreEOL)
    CloseFile(file)
  EndIf 
  
  If FileSize(DefaultFooter$) <> -1
    file = ReadFile(#PB_Any,DefaultFooter$,#PB_File_SharedRead)
    Footer$ = ReadString(file, #PB_File_IgnoreEOL)
    CloseFile(file)
  EndIf 
  
  
  Content$ = ~"<ul class=\"filelist\">\n"
  
  If ExamineDirectory(1,GetPathPart(Path$), "*.*")
    RelPath$ = ReplaceString(StringField(GetPathPart(Path$),2,DefaultRoot$),"\","/")
    
    While NextDirectoryEntry(1)
      Name$ = DirectoryEntryName(1)
      
      If DirectoryEntryType(1) = #PB_DirectoryEntry_File
        Content$ + ~"<li class=\"fileitem " + GetExtensionPart(Name$) + ~"\"><a href=\""+RelPath$+Name$+~"\">"+Name$ + ", size :  " + DirectoryEntrySize(1) + "</a></li>" + #CRLF$
      Else
        Content$ + ~"<li class=\"folder\"><a href=\""+RelPath$+Name$+~"/\">" + Name$ + "</a></li>"+#CRLF$
      EndIf
    Wend 
    
    FinishDirectory(1)
    
    Content$ + "</ul>"
    
    Content$ = Header$ + Content$ + Footer$
    
    Content$ = ReplaceString(Content$,"{{path}}",RelPath$)
    Content$ = ReplaceString(Content$,"{{ip}}","127.0.0.1")
    Content$ = ReplaceString(Content$,"{{date}}",GetDate())
    
    *out = AllocateMemory(StringByteLength(Content$,#PB_UTF8) +1)
    PokeS(*out,Content$,-1,#PB_UTF8)
    
    ProcedureReturn *out 
    
  Else
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure LoadData(Path$)
  Protected file = ReadFile(#PB_Any,Path$,#PB_File_SharedRead)
  
  If file
    *out = AllocateMemory(Lof(file))
    ReadData(file, *out, Lof(file))
    CloseFile(file)
    
    ProcedureReturn *out
  Else
    ProcedureReturn 0
  EndIf
  
EndProcedure

Procedure GenerateHTTPPacket(*out, Path$)
  Protected *data = AllocateMemory(100)
  Protected *header, size, headerSize
  Protected MIME$
  
  MIME$ = GetMIMEType(Path$)
  
  *data = LoadData(Path$)
  
  If Not *data
    *data = GenerateIndexDocument(Path$)
    
    If Not *data
      ProcedureReturn 0
    EndIf
    
    MIME$ = "text/html"
  EndIf
  
  size = MemorySize(*data)
  *out = AllocateMemory(1024)
  
  headerSize = BuildHeader(*out, #HTTP_OK$, size, MIME$)
  *out = ReAllocateMemory(*out,headerSize + size)
  
  CopyMemory(*data, *out + headerSize, size)
  FreeMemory(*data)
  
  ProcedureReturn *out
  ;     
  ;   Else
  ;     
  ;     ProcedureReturn 0
  ;   EndIf
  
EndProcedure

Procedure SendPacket(socket, *packet)
  If Not socket
    ProcedureReturn #ERR_SOCKET
  EndIf
  
  If *packet
    Protected PacketSize = MemorySize(*packet)
    Protected SendedSize, cpt
    
    While SendedSize < PacketSize And cpt < #NET_MAXRETRY
      SendedSize + SendNetworkData(socket, *packet + SendedSize, PacketSize)
      PrintN("Sending "+Str(SendedSize)+" of "+PacketSize+" bytes ("+Str((SendedSize/PacketSize)*100)+"%).")
      cpt +1
    Wend
    
    If SendedSize = PacketSize
      ProcedureReturn 1
    Else
      ProcedureReturn #ERR_SEND
    EndIf
    
    FreeMemory(*packet)
    
  Else
    ProcedureReturn #ERR_MEMORY
  EndIf
  
EndProcedure

; IDE Options = PureBasic 5.60 (Windows - x64)
; CursorPosition = 128
; FirstLine = 111
; Folding = -
; EnableXP