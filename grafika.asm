;
;

;------------------------------------------------------------------------
%include 'yasmmac.inc'
org 100h                        ; visos COM programos prasideda nuo 100h
                                ; Be to, DS=CS=ES=SS !

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text                   ; kodas prasideda cia

   startas:                     ; nuo cia vykdomas kodas
      call procSetGraphicsMode
      mov si, 160
      mov di, 100
      mov cl, 15
      call procPutPixel


      finit
      fldpi
      fadd st0, st0
      fild word [N]
      fdivr st0, st1
      fstp dword [dphi]

      mov ax, [N]

      .ciklas:
      finit
      fld dword [phi]
      fcos
      fmul dword [R]
      fild word [xc]
      fadd st0, st1
      frndint
      fistp word [x]
      fdecstp

      fld dword [phi]
      fsin
      fmul dword [R]
      fild word [yc]
      fadd st0, st1
      frndint
      fistp word [y]
      fdecstp

      mov si, [x]
      mov di, [y]
      mov cl, 4
      call procPutPixel

      fld dword [phi]
      fadd dword [dphi]
      fstp  dword [phi]

      dec ax
      jne .ciklas

     ; call procWaitForEsc
      ;exit
      startas1:                     ; nuo cia vykdomas kodas
      call procSetGraphicsMode
      mov si, 100
      mov di, 50
      mov cl, 10
      call procPutPixel


      finit
      fldpi
      fadd st0, st0
      fild word [N]
      fdivr st0, st1
      fstp dword [dphi]

      mov ax, [N]

      .ciklas1:
      finit
      fld dword [phi]
      fcos
      fmul dword [R]
      fild word [xc]
      fadd st0, st1
      frndint
      fistp word [x]
      fdecstp

      fld dword [phi]
      fsin
      fmul dword [R]
      fild word [yc]
      fadd st0, st1
      frndint
      fistp word [y]
      fdecstp

      mov si, [x]
      mov di, [y]
      mov cl, 2
      call procPutPixel

      fld dword [phi]
      fadd dword [dphi]
      fstp  dword [phi]

      dec ax
      jne .ciklas1


%include 'yasmlib.asm'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data                   ; duomenys
     R:
     dd  50.0

     phi:
     dd  0.0

     dphi:
     dd  0.0

     xc:
     dw 160
     yc:
     dw 100


     x:
     dw  0
     y:
     dw 0

     N:
     dw 360


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss                    ; neinicializuoti duomenys


