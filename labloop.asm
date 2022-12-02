a200
db 50

a260
db 'Ivesk teksta' 0D 0A '$'

a100
mov ah, 09          ;;print Ivesk teksta
mov dx, 260   
int 21
mov ah, 0A          ;;ivestis
mov dx, 200  
int 21
mov ah, 02          ;;endl
mov dl, 0d    
int 21
mov ah, 02   
mov dl, 0a    
int 21
xor cx, cx            ;;nunulina cx
mov bx, 201           ;; bx yra ivesties dydzio adresas  
mov cl, [bx]          ;; cl yra ivesties dy
mov si, cl
mov di, cl
xor cx, cx
xor dx, dx            ;;nunulina dx, ax
xor ax, ax
mov dl, [bx + si]     ;;dl yra paskutinis simbolis
clc 
mov cl, 8              ;;vidinio ciklo sk
rcr dl, 1             ;;dl rotate per 1 i kaire
adc al, 0             ;;jei yra cf ji sudeda i al
loop 0130
mov dl, [bx + si] 
jp 013c              ;;jei skaicius nelyginis nera parity flag ir ivyksta jump
mov dl, 30           ;;jei lyginis dl tampa 0
mov cl, di
dec di
mov ah, 02       
int 21
loop 0121            
int 20

n labloop.com
r cx 
500
w
q 