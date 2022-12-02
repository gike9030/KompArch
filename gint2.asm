%include 'yasmmac.inc'

org 100h

section .text

start:
macPutString 'Gintare Keraite 1 kursas 2 grupe','$'
macNewLine

;SKAITYMAS

  mov di, [skaitymoFailas]
   mov bx, 82h
   call getFileName
   getFileName:
   fileName:
   mov dl, [es:bx]
   inc bx
   cmp dl, ' '
   jbe quit
   mov skaitymoFailas[di], dl
   inc di
   jmp fileName
   quit:
   mov byte skaitymoFailas[di], 0
   ;ATIDARYTI FAILA SKAITYMUI
    mov dx, skaitymoFailas
    call procFOpenForReading
    jc failedToOpen ; JEI NEPAVYKO ATIDARYTI ISMETA KLAIDA
    mov dx, buffer
    mov cx,50000
    call procFRead

   ;IRASYTI ISVEDIMO FAILA
   macPutString 'Ivesk rasomo failo varda', crlf, '$'
   mov al, 254  ; ilgiausia eilute
   mov dx, isvedimoFailas
   call procGetStr
   macNewLine

   ;SUKURIA IR ATIDARO ISVEDIMO FAILA
   mov dx, isvedimoFailas
   call procFCreateOrTruncate
   jc failedToOpen
   mov dx,isvedimoFailas
   call procFOpenForWriting
   mov [handle], bx

   mov dx, buffer
   mov di,0
   mov bp,di
   mov cx,-100 ;LYGINA SKAICIUS NUO -100 IKI 100
   mov si,0

;ANTRASTES NUSKAITYMAS/IGNORE
antraste:
   mov dh,[buffer+di]
   mov al,dh
   mov bx,[handle]
   call procFPutChar
   cmp dh,10
   je startas
   mov dh,10
   mov [buffer+di], dh
   inc di
jmp antraste

startas:
   cmp cx, 101
   je finish
   mov dl,[buffer+di]
   cmp dl, 0X0A
   je lineSave  ;JEI EILUTES PABAIGA ISSAUGO EILUTES KOORDINATES BP
continue:
   inc di
   cmp dl, 0
   je nextNumber ;JEI DUOMENU PABAIGA, TAI MAZINA CX IR PRADEDA IS NAUJO
   cmp dl, 59
   jne startas ;JEI NE ';' TAI SKAITO TOLIAU
   inc si
   cmp si, 4
   je parseNumber ;JEI YRA 4 KABL. JUMP PARSENUMBER ZIURI AR AX = CX
   jmp startas

lineSave:
   mov bp, di;EILUTES KOORDINATES BP'E
   inc bp
   jmp continue ;GRIZTA, TESIA SKAICIAVIMA TOLIAU

parseNumber: ;5 STULPELYJE LYGINA SKAICIUS
   mov si, -1
   lea dx, [buffer+di];IKELIA EFEKTYVU BUFERIS+DI ADRESA I DX (FOR PARSE)
   call procParseInt16
   cmp ax,cx ;JEI AX = CX, EILUTE ISSPAUZDINA I FAILA
   je ready
   jmp startas ;JEI NE IMA KITA EILUTE KARTOJA SKAICIAVIMUS
ready:
mov si, cx
   mov cx, -1000
   jmp sestas
sestas:
    xor ax,ax
    xor bx,bx
    ;macPutChar dl
    cmp cx, 999
    je nextNumber6
    inc cx
    inc di
    mov dl,[buffer+di];dabar buffer+di yra arba ant pirmo skaiciaus arba ant -
    mov [bufferDigits+si],dl
    cmp dl,45
    jne pab
    inc di
    inc bl
    mov dl,[buffer+di]
    mov [bufferDigits+si],dl
pab:
    inc di
    inc di
    inc bl
    mov dl,[buffer+di]
    mov [bufferDigits+si],dl
    inc di
    inc bl
    mov dl,[buffer+di]
    mov [bufferDigits+si],dl
   lea dx, [bufferDigits] ;parse R number into N number
   call procParseInt16
    cmp cx, ax
    je printLine
    jmp sestas

printLine: ;EILUTES SPAUZDINIMAS
   mov dh,[buffer+bp]
   mov al,dh
   mov bx,[handle]
   call procFPutChar
   inc bp
   cmp dh,0x0a
   je startas
jmp printLine

nextNumber: ;PADIDINA CX IR NUNULINA REGISTRUS
   inc cx
   xor bp,bp
   xor si,si
   xor di,di
jmp startas

nextNumber6: ;PADIDINA CX IR NUNULINA REGISTRUS
   mov cx, si
   xor bp,bp
   xor si,si
   xor di,di
jmp startas

finish:
call procFClose
exit

failedToOpen:
macPutString 'Failo klaida!', crlf, '$'
exit

%include 'yasmlib.asm'

 section .DATA
    skaitymoFailas:
    times 254 dw 00
    buffer:
    times 50000 db 0
    isvedimoFailas:
    times 254 dw 00
    bufferDigits:
    times 10000 db 000
    handle:
    times 100 db 00

section .bss
