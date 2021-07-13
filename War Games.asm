
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

jmp inicio

mapa   db "00..........................WAR.GAMES.-.1983..............................",10,13,
       db "01.......-.....:**:::*=-..-++++:............:--::=WWW***+-++-.............",10,13,
       db "02...:=WWWWWWW=WWW=:::+:..::...--....:=+W==WWWWWWWWWWWWWWWWWWWWWWWW+-.....",10,13,
       db "03..-....:WWWWWWWW=-=WW*.........--..+::+=WWWWWWWWWWWWWWWWWWWW:..:=.......",10,13,
       db "04.......+WWWWWW*+WWW=-:-.........-+*=:::::=W*W=WWWW*++++++:+++=-.........",10,13,
       db "05......*WWWWWWWWW=..............::..-:--+++::-++:::++++++++:--..-........",10,13,
       db "06.......:**WW=*=...............-++++:::::-:+::++++++:++++++++............",10,13,
       db "07........-+:...-..............:+++++::+:++-++::-.-++++::+:::-............",10,13,
       db "08..........--:-...............::++:+++++++:-+:.....::...-+:...-..........",10,13,
       db "09..............-+++:-..........:+::+::++++++:-......-....-...---.........",10,13,
       db "10..............:::++++:-............::+++:+:.............:--+--.-........",10,13,
       db "11..............-+++++++++:...........+:+::+................--.....---....",10,13,
       db "12................:++++++:...........-+::+::.:-................-++:-:.....",10,13,
       db "13.................++::+-.............::++:..:...............++++++++-....",10,13,
       db "14.................:++:-...............::-..................-+:--:++:.....",10,13,
       db "15.................:+-............................................-.....--",10,13,
       db "16.................:....................................................--",10,13,
       db "17.......UNITED STATES.........................SOVIET UNION...............",10,13,
       db "0  3  6  9  12 15 18 21 24 27 30 33 36 39 42 45 48 51 54 57 60 63 66 69 72",10,13,"$"

cleanP db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,"$"
cleanC db "                                                                          ",10,13,
       db "                                                                          ",10,13,"$"
cleanD db "                                                                          ",10,13,
       db "                                                                          ",10,13,
       db "                                                                          ",10,13,"$"
cleanLine db "                                                                          ",10,13,"$"
msj1 db "EEUU, ingrese la coordenada X de su base (00;33): $"
msj2 db "EEUU, ingrese la coordenada Y de su base (00;18): $"
msj3 db "URSS, ingrese la coordenada X de su base (33;74): $"
msj4 db "URSS, ingrese la coordenada Y de su base (00;18): $"
msj5 db "Juega EEUU$"
msj6 db "Juega URSS$"
msj7 db "Ingrese la coordenada X: $"
msj8 db "Ingrese la coordenada Y: $"
xEEUU db ?
yEEUU db ?
xURSS db ?
yURSS db ? 
turno db 0 ; 0=EE.UU
coordenada_x db ?
coordenada_y db ?
diez db 10 
disparo db " "
x_prueba db 3
y_prueba db 2
contW_EEUU db 0
contW_URSS db 0
contFilas db 0
gameOver db 0 ;0= FALSE
msj9 db "Gano EEUU!$"
msj10 db "Gano URSS!$"
cleanM db "         $"
cantFilas db 0
msj11 db "Verificando si hay ganador...$"
ganador db 0 ;0=EEUU
nombreArchivo db 'planillaResultado.txt',0
handle dw ?
msj12 db "Ganador: EEUU",0
cantBytes dw $-offset msj12
msj13 db "Ganador: URSS",0

inicio: 
    
    call initJuego
    call jugar
    call guardarGanador
    ret

;************************************ PROCEDIMIENTOS *****************************************

proc initJuego
    
    call printMap
    call pedirCoordenadas
    call elegirTurno
    
    ret
    endp initJuego

;***************************
 proc printMap
    
    mov dh,0
	mov dl,0
	mov bh,0
	mov ah,2
	int 10h
	
    mov ah,09
    mov dx,offset mapa
    int 21h
    
    ret
    endp printMap 
 
 ;***************************
 
 proc pedirCoordenadas
    
    pedirX_EEUU:
    mov dh, 20             ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09              ;limpiar pantalla
    mov dx,offset cleanC
    int 21h 
                           ;poner el cursor debajo del mapa
    mov dh, 20
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    
    mov ah,09              ;pedir coordenada x a EEUU
    mov dx,offset msj1
    int 21h
    
    mov ah,01              ;ingresar coordenada
	int 21h
	sub al,30h
	mul diez
	mov xEEUU,al
	mov ah,01
	int 21h
	sub al,30h
	add xEEUU,al
    
    cmp xEEUU,33           ;verificar coordenada
    jb pedirY_EEUU
    jmp pedirX_EEUU
    
    pedirY_EEUU:
    mov dh, 21             ;poner cursor debajo del pedido de la x
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h 
    
    mov ah,09              ;limpiar pantalla
    mov dx,offset cleanC
    int 21h
    
    mov dh, 21             ;poner cursor debajo del pedido de la x
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    
    mov ah,09               ;pedir coordenada y a EEUU
    mov dx,offset msj2
    int 21h
    
    mov ah,01               ;ingresar coordenada                
    int 21h
    sub al,30h
    mul diez
    mov yEEUU,al
    mov ah,01
    int 21h
    sub al,30h
    add yEEUU,al 
    
    cmp yEEUU,18           ;verificar coordenada
    jb pedirX_URSS
    jmp pedirY_EEUU
     
    pedirX_URSS:
    mov dh, 20             ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09              ;limpiar pantalla
    mov dx,offset cleanC
    int 21h 
                           ;poner el cursor debajo del mapa
    mov dh, 20
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09              ;pedir la coordenada x a la URSS
    mov dx,offset msj3
    int 21h       
    
    mov ah,01              ;ingresar coordenada
	int 21h
	sub al,30h
	mul diez
	mov xURSS,al
	mov ah,01
	int 21h
	sub al,30h
	add xURSS,al
    
    cmp xURSS,33           ;verificar si es mayor a 33 
    ja seguirVerificandoX
    jmp pedirX_URSS
    
    seguirVerificandoX:    ;verificar si es menor a 74
    cmp xURSS,74
    jb pedirY_URSS
    jmp pedirX_URSS
    
    pedirY_URSS:
    mov dh, 21             ;poner cursor debajo del pedido de la x
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h 
    
    mov ah,09              ;limpiar pantalla
    mov dx,offset cleanC
    int 21h
    
    mov dh, 21             ;poner cursor debajo del pedido de la x
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    
    mov ah,09              ;pedir la coordenada y a la URSS
    mov dx,offset msj4
    int 21h
    
    mov ah,01               ;ingresar coordenada                
    int 21h
    sub al,30h
    mul diez
    mov yURSS,al
    mov ah,01
    int 21h
    sub al,30h
    add yURSS,al
    
    cmp yURSS,18           ;verificar coordenada
    jb finPedirCoordenadas
    jmp pedirY_URSS
    
    finPedirCoordenadas:
    mov dh, 0              ;poner cursor al principio de la pantalla
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
    ret
    endp pedirCoordenadas
 
 ;***************************
 
 proc elegirTurno
    
    mov ah, 2Ch                ;obtener la hora del sistema
    int 21h
    cmp dl,50                  ;comparar los microsegundos con 50
    jb finElegirTurno          ;si es menor, el turno es para EEUU
    mov turno,01               ;si no, el turno es para URSS
    
    finElegirTurno:
    ret
    endp elegirTurno
 
 ;*********************************************************************************************
 
 proc jugar                     
                                
    seguirJugando:
    call informarPaisTurno
    call leerCoordenadas
    call disparar
    call printMap
    call verificarGanador
    call actualizarTurno        
    cmp gameOver,0
    je seguirJugando
    
    ret
    endp jugar

;****************************

proc informarPaisTurno
    
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09                  ;limpiar pantalla
    mov dx,offset cleanD
    int 21h 
                               
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
    cmp turno,00
    je turnoEEUU
    mov ah,09
    mov dx,offset msj6
    int 21h
    jmp fin
    
    turnoEEUU:
        mov ah,09
        mov dx,offset msj5
        int 21h
       
    fin:
        ret
        endp informarPaisTurno

;********************************

proc leerCoordenadas
    
    mov dh, 21                 ;poner el cursor debajo del aviso del turno
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09                  ;limpiar pantalla
    mov dx,offset cleanC
    int 21h 
                               
    mov dh, 21                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
    
    mov ah,09                  ;pedir coordenada x
    mov dx,offset msj7
    int 21h
    
    mov ah,01                  ;ingresar coordenada
	int 21h
	sub al,30h
	mul diez
	mov coordenada_x,al
	mov ah,01
	int 21h
	sub al,30h
	add coordenada_x,al
	
	mov ah,02                  ;siguiente renglon
    mov dl,0ah
    int 21h
    mov ah,02
    mov dl,0dh
    int 21h 
    
                           
    mov ah,09                  ;pedir coordenada y
    mov dx,offset msj8
    int 21h
    
    mov ah,01                  ;ingresar coordenada
	int 21h
	sub al,30h
	mul diez
	mov coordenada_y,al
	mov ah,01
	int 21h
	sub al,30h
	add coordenada_y,al
    
    ret
    endp leerCoordenadas 

;**********************************

proc disparar
    
    cmp coordenada_x,0             ;verifico x
    ja seguirVerificando                
    jmp finDisparar
    
    seguirVerificando:
    cmp coordenada_x,73
    ja finDisparar
    
    verificarY:
    cmp coordenada_y,18             ;verifico y
    jb ok
    jmp finDisparar
    
    ok:                             ;si estan en el rango, disparo
    call borrarCoordenadas
    
    finDisparar:
    ret
    endp disparar

;***********************************

proc borrarCoordenadas
    
    mov cantFilas,0
    
    mov ax,76              ;multiplico la Y por la ctdad de columnas para acceder a la fila 
    mul coordenada_y
    sub ax,76              ;le resto una fila para acceder a la de arriba
    mov bx,ax
    
    xor ax,ax              ;resto una columna para acceder a la primera contigua
    mov al,coordenada_x
    sub ax,1
    add bx,ax
                           
    cicloPrueba:           ;empiezo a borrar
    cmp cantFilas,3
    je finPrueba
    cmp si,3
    je siguienteFila
    mov mapa[bx+si],' '
    inc si
    jmp cicloPrueba
    
    siguienteFila:
    add bx,76
    mov si,0
    inc cantFilas
    jmp cicloPrueba
    
    finPrueba:
    ret
    endp borrarCoordenadas

;*********************************

proc verificarGanador                  
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09                  ;limpiar pantalla
    mov dx,offset cleanD
    int 21h 
                               
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
    mov ah,09                  ;avisa que va a verificar
    mov dx,offset msj11
    int 21h
    
    cmp turno,0                ;si el turno es de EEUU verifica la base de URSS
    je verificarBaseURSS
    
    mov ax,76         
    mul yEEUU
    mov bx,ax
    mov ax,0
    mov al,xEEUU
    add bx,ax
    cmp mapa[bx],' '
    je ganoURSS
    
    call contarW_EEUU
    cmp contW_EEUU,0
    je ganoURSS
    jmp finVerificarGanador
    
    verificarBaseURSS:           ;multiplica 76 por Y para obtener la fila
    mov ax,76         
    mul yURSS
    mov bx,ax
    mov ax,0
    mov al,xURSS                  ;le suma X para obtener fila-columna
    add bx,ax                     ;si fue disparada
    cmp mapa[bx],' '              ;gana EEUU
    je ganoEEUU                   ;si no, verifica las W
    
    call contarW_URSS             ;si no hay, gana EEUU
    cmp contW_URSS,0
    je ganoEEUU
    jmp finVerificarGanador
    
    ganoEEUU:
    mov gameOver,1
    
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09                  ;limpiar pantalla
    mov dx,offset cleanLine
    int 21h 
                               
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	                            ;avisa que gano EEUU
    mov ah,09
    mov dx,offset msj9
    int 21h
    jmp finVerificarGanador
    
    ganoURSS:
    mov gameOver,1
    mov ganador,1
    
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ah,09                  ;limpiar pantalla
    mov dx,offset cleanLine
    int 21h 
                               
    mov dh, 20                 ;poner el cursor debajo del mapa
	mov dl, 0
	mov bh, 0
	mov ah, 2
	int 10h
	                           ;avisa que gano URSS
    mov ah,09
    mov dx,offset msj10
    int 21h
    
    finVerificarGanador:
    ret
    endp verificarGanador

;**********************************

proc contarW_EEUU
    
    mov contW_EEUU,0
    mov bx,offset mapa
    add bx,159              ;le sumo 159 porque es la posicion de la W mas a la izquierda
    mov contFilas,0         ;cada vez que se llama al proc, lo resetea
    
    cicloE: 
    cmp contFilas,5         ;el tope de filas es 5 porque son 5 filas donde hay Ws
    je finContarW_EEUU
    cmp si,16               ;si es para las columnas.Y el tope es 16 porque son 16
    je siguienteFilaE       ;columnas que tienen Ws
    cmp [bx+si],'W'         
    je contarE
    
    seguirE:
    inc si
    jmp cicloE
    
    contarE:
    inc contW_EEUU
    jmp seguirE
    
    siguienteFilaE:
    add bx,76               ;para pasar a la sig fila, le sumo 76 porque son 76 posiciones
    mov si,0                ;que tiene la matriz. Y vuelvo a poner si en 0 para que ahora
    inc contFilas           ;ahora recorra las columnas de esa fila
    jmp cicloE
    
    finContarW_EEUU:
    ret
    endp contarW_EEUU

;**********************************

proc contarW_URSS
    
    mov contW_URSS,0
    mov bx,offset mapa
    add bx,116
    mov contFilas,0
    
    cicloU: 
    cmp contFilas,4
    je finContarW_URSS
    cmp si,27
    je siguienteFilaU
    cmp [bx+si],'W'
    je contarU
    
    seguirU:
    inc si
    jmp cicloU
    
    contarU:
    inc contW_URSS
    jmp seguirU
    
    siguienteFilaU:
    add bx,76
    mov si,0
    inc contFilas
    jmp cicloU
    
    finContarW_URSS:
    ret
    endp contarW_URSS

;**********************************

proc actualizarTurno
    
    cmp turno,0
    je turnoURSS
    mov turno,0                  
    jmp finActualizarTurno
    
    turnoURSS:
    mov turno,1
    
    finActualizarTurno:
    ret
    endp actualizarTurno

;**********************************************************************************************

proc guardarGanador
    
    cmp ganador,0
    je guardarEEUU
    
    mov ax,@data                  ;crear
    mov ds,ax
    mov ah,3ch
    mov cx,0
    mov dx,offset nombreArchivo
    int 21h
    jc finGuardarGanador
    mov handle,ax

    mov ah,40h                    ;escribir
    mov bx,handle
    mov cx,cantBytes
    mov dx,offset msj13
    int 21h
    jc finGuardarGanador

    mov ah,3eh                    ;cerrar
    mov bx,handle
    int 21h
    jmp finGuardarGanador
    
    guardarEEUU:
    
    mov ax,@data                  ;crear
    mov ds,ax
    mov ah,3ch
    mov cx,0
    mov dx,offset nombreArchivo
    int 21h
    jc finGuardarGanador
    mov handle,ax

    mov ah,40h                    ;escribir
    mov bx,handle
    mov cx,cantBytes
    mov dx,offset msj12
    int 21h
    jc finGuardarGanador

    mov ah,3eh                    ;cerrar
    mov bx,handle
    int 21h
    
    finGuardarGanador:
    ret
    endp guardarGanador

;**************************


                                 














