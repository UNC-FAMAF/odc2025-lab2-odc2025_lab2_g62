.equ SCREEN_WIDTH,          640
.equ SCREEN_HEIGH,          480
.equ BITS_PER_PIXEL,        32

.equ GPIO_BASE,             0x3f200000
.equ GPIO_GPFSEL0,          0x00
.equ GPIO_GPLEV0,           0x34

    .globl main

main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0     // Guarda la dirección base del framebuffer en x20

    // ---------------- INICIO DEL CÓDIGO DE DIBUJO --------------------

    // Fondo (cielo con degradado de tonos violetas)

    // Sección 1: violeta muy oscuro (parte superior)
    mov x21, #0 ; mov x22, #0 ; mov x23, #SCREEN_WIDTH ; mov x24, #60
    movz w25, #0x0010, lsl #0   // BBGG
    movk w25, #0xFF10, lsl #16  // AARR
    bl draw_rectangle

    // Sección 2: violeta oscuro
    mov x21, #0 ; mov x22, #60 ; mov x23, #SCREEN_WIDTH ; mov x24, #60
    movz w25, #0x0020, lsl #0
    movk w25, #0xFF20, lsl #16
    bl draw_rectangle

    // Sección 3: violeta con tonalidad media
    mov x21, #0 ; mov x22, #120 ; mov x23, #SCREEN_WIDTH ; mov x24, #60
    movz w25, #0x0030, lsl #0
    movk w25, #0xFF30, lsl #16
    bl draw_rectangle

    // Sección 4: violeta claro
    mov x21, #0 ; mov x22, #180 ; mov x23, #SCREEN_WIDTH ; mov x24, #60
    movz w25, #0x0040, lsl #0
    movk w25, #0xFF40, lsl #16
    bl draw_rectangle

    // Sección 5: violeta más claro (cercanito al horizonte de edificios)
    mov x21, #0 ; mov x22, #240 ; mov x23, #SCREEN_WIDTH ; mov x24, #240 // Cubre hasta la base
    movz w25, #0x0050, lsl #0
    movk w25, #0xFF50, lsl #16
    bl draw_rectangle


    // Edificios de fondo
    // Color: 0xFF151515 (gris)
    movz w25, #0x1515, lsl #0
    movk w25, #0xFF15, lsl #16

    // Edificio alto y delgado izquierda
    mov x21, #0 ; mov x22, #100 ; mov x23, #40 ; mov x24, #380 ; bl draw_rectangle
    // Edificio con antena 
    mov x21, #80 ; mov x22, #120 ; mov x23, #70 ; mov x24, #360 ; bl draw_rectangle
    // Edificio central izquierda 
    mov x21, #180 ; mov x22, #150 ; mov x23, #80 ; mov x24, #330 ; bl draw_rectangle
    // Edificio de fondo a la izquierda del central más alto
    mov x21, #220 ; mov x22, #150 ; mov x23, #30 ; mov x24, #330 ; bl draw_rectangle
    // Edificio de fondo a la derecha del central más alto
    mov x21, #390 ; mov x22, #150 ; mov x23, #30 ; mov x24, #330 ; bl draw_rectangle
    // Edificio central derecha 
    mov x21, #400 ; mov x22, #180 ; mov x23, #70 ; mov x24, #300 ; bl draw_rectangle
    // Edificio delgado derecha 
    mov x21, #500 ; mov x22, #160 ; mov x23, #50 ; mov x24, #320 ; bl draw_rectangle
    // Edificio extremo derecha
    mov x21, #580 ; mov x22, #190 ; mov x23, #60 ; mov x24, #290 ; bl draw_rectangle
    // Edificio de fondo adicional a la izquierda
    mov x21, #40 ; mov x22, #200 ; mov x23, #40 ; mov x24, #280 ; bl draw_rectangle
    // Edificio de fondo adicional a la derecha
    mov x21, #550 ; mov x22, #210 ; mov x23, #30 ; mov x24, #270 ; bl draw_rectangle


    // Edificios que estan en primer plano
    // Color: 0xFF000000 (Negro)
    movz w25, #0x0000, lsl #0
    movk w25, #0xFF00, lsl #16

    mov x21, #0 ; mov x22, #280 ; mov x23, #SCREEN_WIDTH ; mov x24, #200 ; bl draw_rectangle

    // Edificio principal izquierda (rectangulos apilados)
    mov x21, #0 ; mov x22, #280 ; mov x23, #150 ; mov x24, #200 ; bl draw_rectangle // Base
    mov x21, #10 ; mov x22, #260 ; mov x23, #130 ; mov x24, #20 ; bl draw_rectangle // Nivel medio
    mov x21, #20 ; mov x22, #240 ; mov x23, #110 ; mov x24, #20 ; bl draw_rectangle // Nivel superior

    // Edificio intermedio izquierda
    mov x21, #150 ; mov x22, #200 ; mov x23, #100 ; mov x24, #280 ; bl draw_rectangle // Base más alta 
    mov x21, #160 ; mov x22, #180 ; mov x23, #80 ; mov x24, #20 ; bl draw_rectangle // Parte superior 

    // Edificio central más alto y puntiagudo
    mov x21, #250 ; mov x22, #80 ; mov x23, #140 ; mov x24, #400 ; bl draw_rectangle // Base más ancha
    mov x21, #290 ; mov x22, #60 ; mov x23, #60 ; mov x24, #20 ; bl draw_rectangle // Punta

    // Edificio de relleno entre el central y el de la cúpula
    mov x21, #390 ; mov x22, #280 ; mov x23, #10 ; mov x24, #200 ; bl draw_rectangle

    // Edificio con cúpula (primer plano)
    mov x21, #400 ; mov x22, #200 ; mov x23, #120 ; mov x24, #280 ; bl draw_rectangle // Base
    mov x21, #420 ; mov x22, #180 ; mov x23, #80 ; mov x24, #20 ; bl draw_rectangle // Base cúpula
    mov x21, #430 ; mov x22, #160 ; mov x23, #60 ; mov x24, #20 ; bl draw_rectangle // Cúpula inferior
    mov x21, #440 ; mov x22, #140 ; mov x23, #40 ; mov x24, #20 ; bl draw_rectangle // Cúpula superior

    // Edificio de relleno entre el de la cúpula y el extremo derecho
    mov x21, #520 ; mov x22, #280 ; mov x23, #10 ; mov x24, #200 ; bl draw_rectangle

    // Edificio extremo derecha (rectangulos apilados)
    mov x21, #530 ; mov x22, #250 ; mov x23, #110 ; mov x24, #230 ; bl draw_rectangle // Base
    mov x21, #540 ; mov x22, #230 ; mov x23, #90 ; mov x24, #20 ; bl draw_rectangle // Medio
    mov x21, #550 ; mov x22, #210 ; mov x23, #70 ; mov x24, #20 ; bl draw_rectangle // Superior


    // Ventanas iluminadas
    // Color: 0xFFF7D700 (RGB F7D700, Alpha FF)
    movz w25, #0xD700, lsl #0
    movk w25, #0xFFF7, lsl #16

    // Ventanas edificio principal izquierda
    mov x21, #20 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #40 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #60 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #20 ; mov x22, #280 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #40 ; mov x22, #280 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #60 ; mov x22, #280 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #80 ; mov x22, #300 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #100 ; mov x22, #300 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle

    // Ventanas edificio intermedio izquierda
    mov x21, #170 ; mov x22, #200 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #190 ; mov x22, #200 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #210 ; mov x22, #200 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #170 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #190 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #210 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle

    // Ventanas edificio central más alto
    mov x21, #290 ; mov x22, #100 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #100 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #100 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #290 ; mov x22, #130 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #130 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #130 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #290 ; mov x22, #160 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #160 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #160 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle

    // Ventanas edificio a la derecha
    mov x21, #540 ; mov x22, #270 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #560 ; mov x22, #270 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #580 ; mov x22, #270 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #540 ; mov x22, #290 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #560 ; mov x22, #290 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #580 ; mov x22, #290 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle


    // Ventanas apagadas (Azul claro)
    // Color: 0xFF00B0FF (RGB 00B0FF, Alpha FF)
    movz w25, #0xB0FF, lsl #0
    movk w25, #0xFF00, lsl #16

    // Ventanas edificio con cúpula (esta primer plano)
    mov x21, #410 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #430 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #450 ; mov x22, #220 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #410 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #430 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #450 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle


    // Ventanas apagadas
    // Color: 0xFF505050 (Gris oscuro)
    movz w25, #0x5050, lsl #0
    movk w25, #0xFF50, lsl #16

    // Nuevas ventanas grises en edificio principal izquierda
    mov x21, #20 ; mov x22, #340 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #40 ; mov x22, #340 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #60 ; mov x22, #340 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle

    // Nuevas ventanas grises en edificio intermedio izquierda
    mov x21, #170 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #190 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #210 ; mov x22, #240 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle 
    mov x21, #170 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #190 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #210 ; mov x22, #260 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle

    // Nuevas ventanas grises en edificio central más alto (zonas más bajas)
    mov x21, #290 ; mov x22, #190 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #190 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #190 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #290 ; mov x22, #220 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #220 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #220 ; mov x23, #15 ; mov x24, #15 ; bl draw_rectangle

    // Nuevas ventanas grises en edificio a la derecha
    mov x21, #540 ; mov x22, #310 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #560 ; mov x22, #310 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #580 ; mov x22, #310 ; mov x23, #10 ; mov x24, #10 ; bl draw_rectangle


    // Estrellas (en color blanco) con diferentes tamaños
    // Color: 0xFFFFFFFF (Blanco puro)
    movz w25, #0xFFFF, lsl #0
    movk w25, #0xFFFF, lsl #16

    // Estrellas pequeñas (1x1)
    mov x21, #50 ; mov x22, #10 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #120 ; mov x22, #25 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #200 ; mov x22, #15 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #280 ; mov x22, #5 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #350 ; mov x22, #30 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #410 ; mov x22, #10 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #480 ; mov x22, #40 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #550 ; mov x22, #20 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #600 ; mov x22, #50 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #10 ; mov x22, #60 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #70 ; mov x22, #80 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #140 ; mov x22, #90 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #220 ; mov x22, #70 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #310 ; mov x22, #60 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #390 ; mov x22, #80 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #470 ; mov x22, #90 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #530 ; mov x22, #70 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle
    mov x21, #590 ; mov x22, #80 ; mov x23, #1 ; mov x24, #1 ; bl draw_rectangle

    // Estrellas un poco más grandes (2x2)
    mov x21, #20 ; mov x22, #30 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #90 ; mov x22, #5 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #160 ; mov x22, #40 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #240 ; mov x22, #20 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #300 ; mov x22, #50 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #380 ; mov x22, #25 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #450 ; mov x22, #15 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #510 ; mov x22, #35 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #570 ; mov x22, #10 ; mov x23, #2 ; mov x24, #2 ; bl draw_rectangle


    // ---------------- Puente y el Tren -----------------------

    // Puente (es la base)
    // Color: 0xFF304050 (Gris azulado oscuro)
    movz w25, #0x4050, lsl #0
    movk w25, #0xFF30, lsl #16
    mov x21, #0 ; mov x22, #380 ; mov x23, #SCREEN_WIDTH ; mov x24, #20 ; bl draw_rectangle

    // Columnas del puente (columnas más finas y hasta el final)
    // Color: 0xFF506070 (Gris más claro)
    movz w25, #0x6070, lsl #0
    movk w25, #0xFF50, lsl #16

    // Columnas
    mov x21, #50 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 
    mov x21, #150 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 
    mov x21, #250 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 
    mov x21, #350 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 
    mov x21, #450 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 
    mov x21, #550 ; mov x22, #400 ; mov x23, #10 ; mov x24, #80 ; bl draw_rectangle 

    // Tren
    // Color del cuerpo del tren: 0xFF404048 (Gris oscuro con toque azul)
    movz w25, #0x4048, lsl #0
    movk w25, #0xFF40, lsl #16

    // Vagón delantero
    mov x21, #180 ; mov x22, #360 ; mov x23, #70 ; mov x24, #20 ; bl draw_rectangle // Vagón principal rectangular

    // Vagones restantes (3 vagones, 4 ventanas naranjas cada uno)
    mov x21, #260 ; mov x22, #360 ; mov x23, #120 ; mov x24, #20 ; bl draw_rectangle // Vagón 2
    mov x21, #390 ; mov x22, #360 ; mov x23, #120 ; mov x24, #20 ; bl draw_rectangle // Vagón 3
    mov x21, #520 ; mov x22, #360 ; mov x23, #120 ; mov x24, #20 ; bl draw_rectangle // Vagón 4

    // Color de las ventanas del tren: 0xFFF7A000 (Naranja)
    movz w25, #0xA000, lsl #0
    movk w25, #0xFFF7, lsl #16

    // Ventana del vagón delantero (conductor)
    mov x21, #205 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle

    // Ventanas vagón 2 
    mov x21, #270 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #290 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #310 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #330 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle

    // Ventanas vagón 3 
    mov x21, #400 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #420 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #440 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #460 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle

    // Ventanas vagón 4
    mov x21, #530 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #550 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #570 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle
    mov x21, #590 ; mov x22, #365 ; mov x23, #15 ; mov x24, #10 ; bl draw_rectangle

    // Color de los detalles oscuros del tren (ruedas/uniones)
    // Color: 0xFF000000 (Negro)
    movz w25, #0x0000, lsl #0
    movk w25, #0xFF00, lsl #16

    // Detalles debajo del tren
    mov x21, #190 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle // Delantero
    mov x21, #210 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle // Delantero
    mov x21, #280 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle // Vagón 2
    mov x21, #300 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #320 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #340 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #410 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle // Vagón 3
    mov x21, #430 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #450 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #470 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #540 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle // Vagón 4
    mov x21, #560 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #580 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle
    mov x21, #600 ; mov x22, #375 ; mov x23, #10 ; mov x24, #5 ; bl draw_rectangle


    // ---------------- Luna y los Cráteres -----------------------

    // La Luna
    // Color: 0xFFC0C0C0 (Gris claro)
    movz w25, #0xC0C0, lsl #0
    movk w25, #0xFFC0, lsl #16
    mov x21, #550 ; mov x22, #80 ; mov x23, #40 ; bl draw_circle // Luna principal

    // Cráteres (en forma de circulitos)
    // Color: 0xFF808080 (Gris oscuro)
    movz w25, #0x8080, lsl #0
    movk w25, #0xFF80, lsl #16

    mov x21, #530 ; mov x22, #65 ; mov x23, #8 ; bl draw_circle // Cráter 1
    mov x21, #560 ; mov x22, #100 ; mov x23, #5 ; bl draw_circle // Cráter 2
    mov x21, #540 ; mov x22, #85 ; mov x23, #10 ; bl draw_circle // Cráter 3
    mov x21, #575 ; mov x22, #75 ; mov x23, #6 ; bl draw_circle // Cráter 4


    // ---------------- Cartel neón con la leyenda "ODC 2025" -----------------------
    // Posición debajo de las ventanas del edificio central más alto
    // Edificio central más alto: x=250, y=80, width=140, height=400
    // Las ventanas más bajas están alrededor de y=190 y y=220. El cartel irá debajo de estas
    // Centraremos el texto en el edificio (para que se vea mas estpetico)

    // Color del texto (Fucsia/rosa, mas o menos ese color)
    movz w25, #0x00FF, lsl #0   // BBGG (00FF)
    movk w25, #0xFFFF, lsl #16  // AARR (FF)

    // ODC - se escribira en la parte superior
    // Ancho total de "ODC" (3 letras * 12px ancho + 2 espacios * 4px = 36 + 8 = 44px)
    // Centro del edificio: 250 + 140/2 = 320.
    // Inicio X para "O": 320 - (44 / 2) = 320 - 22 = 298.
    // Y para "ODC": 290 (posición)

    // O (12x16 pixels)
    mov x21, #298 ; mov x22, #290 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #298 ; mov x22, #306 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #298 ; mov x22, #292 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle 
    mov x21, #308 ; mov x22, #292 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle

    // D (12x16 pixels) - Espacio de 4px después de O
    mov x21, #314 ; mov x22, #290 ; mov x23, #2 ; mov x24, #16 ; bl draw_rectangle 
    mov x21, #316 ; mov x22, #290 ; mov x23, #8 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #316 ; mov x22, #306 ; mov x23, #8 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #324 ; mov x22, #292 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle 

    // C (12x16 pixels) - Espacio de 4px después de D
    mov x21, #331 ; mov x22, #290 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #331 ; mov x22, #306 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #331 ; mov x22, #292 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle 


    // 2025 - se escribirá en la parte inferior
    // Ancho total de "2025" (4 dígitos * 12px ancho + 3 espacios * 4px = 48 + 12 = 60px)
    // Centro del edificio: 320
    // Inicio X para "2": 320 - (60 / 2) = 320 - 30 = 290
    // Y para "2025": 290 (ODC_Y) + 16 (ODC_height) + 10 (spacing) = 316

    // 2 (12x16 pixels)
    mov x21, #290 ; mov x22, #316 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #300 ; mov x22, #318 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #290 ; mov x22, #324 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #290 ; mov x22, #326 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #290 ; mov x22, #332 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 

    // 0 (12x16 pixels) - Espacio de 4px después de 2
    mov x21, #306 ; mov x22, #316 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #306 ; mov x22, #332 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #306 ; mov x22, #318 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle
    mov x21, #316 ; mov x22, #318 ; mov x23, #2 ; mov x24, #12 ; bl draw_rectangle 

    // 2 (12x16 pixels) - Espacio de 4px después de 0
    mov x21, #323 ; mov x22, #316 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #333 ; mov x22, #318 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #323 ; mov x22, #324 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #323 ; mov x22, #326 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #323 ; mov x22, #332 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 

    // 5 (12x16 pixels) - Espacio de 4px después de 2
    mov x21, #340 ; mov x22, #316 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle
    mov x21, #340 ; mov x22, #318 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #340 ; mov x22, #324 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 
    mov x21, #350 ; mov x22, #326 ; mov x23, #2 ; mov x24, #6 ; bl draw_rectangle 
    mov x21, #340 ; mov x22, #332 ; mov x23, #12 ; mov x24, #2 ; bl draw_rectangle 


    // ---------------- FIN DEL CÓDIGO DE DIBUJO -----------------------

    // Ejemplo de uso de gpios (mantener como está)
    mov x9, GPIO_BASE

    // Atención: se utilizan registros w porque la documentación de broadcom
    // indica que los registros que estamos leyendo y escribiendo son de 32 bits

    // Setea gpios 0 - 9 como lectura
    str wzr, [x9, GPIO_GPFSEL0]

    // Lee el estado de los GPIO 0 - 31
    ldr w10, [x9, GPIO_GPLEV0]

    // And bit a bit mantiene el resultado del bit 2 en w10
    and w11, w10, 0b10

    // w11 será 1 si había un 1 en la posición 2 de w10, si no será 0
    // efectivamente, su valor representará si GPIO 2 está activo
    lsr w11, w11, 1

    // ---------------------------------------------------------------
    // Bucle infinito para mantener la imagen en pantalla

InfLoop:
    b InfLoop

.align 4 // Asegura la alineacion para las secciones de datos y código en general

// Subrutina draw_rectangle
// Dibuja un rectángulo en el framebuffer.
// Parámetros de entrada (registros):
// x20: Dirección base del framebuffer (no modificada)
// x21: x_start (coordenada X de inicio del rectángulo)
// x22: y_start (coordenada Y de inicio del rectángulo)
// x23: width (ancho del rectángulo)
// x24: height (alto del rectángulo)
// w25: color (valor ARGB de 32 bits para el color del rectángulo)
draw_rectangle:
    // Guarda los registros callee-saved que serán modificados por esta subrutina
    // x29 (Frame Pointer) y x30 (Link Register) son necesarias para el flujo de llamadas
    // x26 y x27 se usarán como contadores de bucle y son callee-saved
    stp x29, x30, [sp, #-16]!    // Guarda FP y LR en la pila
    stp x26, x27, [sp, #-16]!    // Guarda x26 y x27 en la pila

    // x9 se usará como puntero al pixel actual en el framebuffer
    // x10, x11, x12, x13, x14 se usarán para cálculos temporales
    // Estos son caller-saved, por lo que no es necesario guardarlos aquí

    // Carga SCREEN_WIDTH en un registro para usarlo en la multiplicación
    mov x14, #SCREEN_WIDTH
    mov x15, #SCREEN_HEIGH // Carga SCREEN_HEIGH

    // Inicializa el puntero base del framebuffer para uso local en x9
    mov x9, x20

    // Calcula las coordenadas finales del rectángulo (exclusivas)
    add x10, x21, x23            // x_end = x_start + width
    add x11, x22, x24            // y_end = y_start + height

    // Clipping de las coordenadas de inicio
    cmp x21, #0
    blt .Lclip_x_start_to_zero
    b .Lskip_clip_x_start
.Lclip_x_start_to_zero:
    mov x21, #0
.Lskip_clip_x_start:

    cmp x22, #0
    blt .Lclip_y_start_to_zero
    b .Lskip_clip_y_start
.Lclip_y_start_to_zero:
    mov x22, #0
.Lskip_clip_y_start:

    // Clipping de las coordenadas finales
    cmp x10, x14 // Compara x_end con SCREEN_WIDTH
    bgt .Lclip_x_end_to_width
    b .Lskip_clip_x_end
.Lclip_x_end_to_width:
    mov x10, x14
.Lskip_clip_x_end:

    cmp x11, x15 // Compara y_end con SCREEN_HEIGH
    bgt .Lclip_y_end_to_height
    b .Lskip_clip_y_end
.Lclip_y_end_to_height:
    mov x11, x15
.Lskip_clip_y_end:


    // Inicializa el contador de fila (current_y) con y_start
    mov x26, x22                 // x26 = current_y

loop_y_rect:
    // Comprueba si hemos dibujado todas las filas
    cmp x26, x11                 // Compara current_y con y_end
    bge end_draw_rectangle_proc  // Si current_y >= y_end, termina la subrutina

    // Inicializa el contador de columna (current_x) con x_start para cada nueva fila
    mov x27, x21                 // x27 = current_x

loop_x_rect:
    // Comprueba si hemos dibujado todos los píxeles en la fila actual
    cmp x27, x10                 // Compara current_x con x_end
    bge end_loop_x_rect          // Si current_x >= x_end, pasa a la siguiente fila

    // Calcula el offset del píxel: (current_y * SCREEN_WIDTH + current_x) * 4
    // Multiplica current_y por SCREEN_WIDTH para obtener el inicio de la fila en píxeles
    mul x12, x26, x14            // x12 = current_y * SCREEN_WIDTH (x14 contiene SCREEN_WIDTH)

    // Suma current_x para obtener la posición del píxel dentro de la fila
    add x12, x12, x27            // x12 = (current_y * SCREEN_WIDTH) + current_x

    // Multiplica por 4 (bytes por píxel, ya que BITS_PER_PIXEL es 32) para obtener el offset en bytes
    lsl x12, x12, #2             // x12 = x12 * 4

    // Calcula la dirección de memoria del píxel actual
    add x13, x9, x12             // x13 = framebuffer_base + offset

    // Almacena el color de 32 bits (w25) en la dirección calculada
    str w25, [x13]               // Guarda el color en el pixel actual

    // Incrementa el contador de columna
    add x27, x27, #1             // current_x++
    b loop_x_rect                // Vuelve al inicio del bucle de columnas

end_loop_x_rect:
    // Incrementa el contador de fila
    add x26, x26, #1             // current_y++
    b loop_y_rect                // Vuelve al inicio del bucle de filas

end_draw_rectangle_proc:
    // Restaura los registros callee-saved que fueron guardados al inicio
    ldp x26, x27, [sp], #16      // Restaura x26 y x27
    ldp x29, x30, [sp], #16      // Restaura FP y LR
    ret                          // Regresa al punto de llamada (main)


// Subrutina draw_circle
// Dibuja un círculo en el framebuffer.
// Parámetros de entrada (registros):
// x20: Dirección base del framebuffer (no modificada por esta función)
// x21: x_center (coordenada X del centro del círculo)
// x22: y_center (coordenada Y del centro del círculo)
// x23: radius (radio del círculo)
// w25: color (valor ARGB de 32 bits para el color del círculo)
draw_circle:
    // Guarda los registros callee-saved que serán modificados por esta subrutina.
    stp x29, x30, [sp, #-16]!    // Guarda FP y LR
    stp x19, x24, [sp, #-16]!    // Guarda x19 (radius_squared) y x24 (current_y)
    stp x26, x27, [sp, #-16]!    // Guarda x26 (current_x) y x27 (dy)
    stp x28, xzr, [sp, #-16]!    // Guarda x28 (dx)

    // Calcula radius_squared = radius * radius
    mul x19, x23, x23            // x19 = radius * radius

    // Carga SCREEN_WIDTH y SCREEN_HEIGH en registros para usarlo en la multiplicación y clipping
    mov x18, #SCREEN_WIDTH
    mov x17, #SCREEN_HEIGH // Usamos x17 para SCREEN_HEIGH

    // Inicializa el puntero base del framebuffer para uso local en x9
    mov x9, x20

    // Calcula los límites del bucle para y (bounding box del círculo)
    sub x12, x22, x23            // y_min = y_center - radius
    add x13, x22, x23            // y_max = y_center + radius

    // Clipping de y_min
    cmp x12, #0
    blt .Lclip_y_min_to_zero
    b .Lskip_clip_y_min
.Lclip_y_min_to_zero:
    mov x12, #0
.Lskip_clip_y_min:

    // Clipping de y_max
    cmp x13, x17 // Compara y_max con SCREEN_HEIGH
    bgt .Lclip_y_max_to_height
    b .Lskip_clip_y_max
.Lclip_y_max_to_height:
    mov x13, x17
.Lskip_clip_y_max:


    // Bucle para cada fila (current_y)
    mov x24, x12                 // x24 = current_y = y_min

loop_y_circle:
    cmp x24, x13                 // Compara current_y con y_max
    bgt end_draw_circle_proc     // Si current_y > y_max, termina la subrutina

    // Calcula dy = current_y - y_center
    sub x27, x24, x22            // x27 = dy

    // Calcula dy_squared = dy * dy
    mul x10, x27, x27            // x10 = dy_squared

    // Calcula los límites del bucle para x (bounding box del círculo)
    sub x14, x21, x23            // x_min = x_center - radius
    add x15, x21, x23            // x_max = x_center + radius

    // Clipping de x_min
    cmp x14, #0
    blt .Lclip_x_min_to_zero_circle
    b .Lskip_clip_x_min_circle
.Lclip_x_min_to_zero_circle:
    mov x14, #0
.Lskip_clip_x_min_circle:

    // Clipping de x_max
    cmp x15, x18 // Compara x_max con SCREEN_WIDTH
    bgt .Lclip_x_max_to_width_circle
    b .Lskip_clip_x_max_circle
.Lclip_x_max_to_width_circle:
    mov x15, x18
.Lskip_clip_x_max_circle:


    // Bucle para cada columna (current_x)
    mov x26, x14                 // x26 = current_x = x_min

loop_x_circle:
    cmp x26, x15                 // Compara current_x con x_max
    bgt end_loop_x_circle        // Si current_x > x_max, pasa a la siguiente fila

    // Calcula dx = current_x - x_center
    sub x28, x26, x21            // x28 = dx

    // Calcula dx_squared = dx * dx
    mul x11, x28, x28            // x11 = dx_squared

    // Calcula distance_squared = dx_squared + dy_squared
    add x16, x11, x10            // x16 = distance_squared

    // Comprueba si el píxel está dentro del círculo
    cmp x16, x19                 // Compara distance_squared con radius_squared
    bgt skip_pixel               // Si distance_squared > radius_squared, salta este píxel

    // Dibuja el píxel
    // Calcula el offset del píxel: (current_y * SCREEN_WIDTH + current_x) * 4
    mul x17, x24, x18            // x17 = current_y * SCREEN_WIDTH (x18 contiene SCREEN_WIDTH)
    add x17, x17, x26            // x17 = (current_y * SCREEN_WIDTH) + current_x
    lsl x17, x17, #2             // x17 = x17 * 4 

    // Calcula la dirección de memoria del píxel actual
    add x17, x9, x17             // x17 = framebuffer_base + offset

    // Almacena el color de 32 bits (w25) en la dirección calculada
    str w25, [x17]               // Guarda el color en el pixel actual

skip_pixel:
    // Incrementa el contador de columna
    add x26, x26, #1             // current_x++
    b loop_x_circle              // Vuelve al inicio del bucle de columnas

end_loop_x_circle:
    // Incrementa el contador de fila
    add x24, x24, #1             // current_y++
    b loop_y_circle              // Vuelve al inicio del bucle de filas

end_draw_circle_proc:
    // Restaura los registros callee-saved que fueron guardados al inicio
    ldp x28, xzr, [sp], #16      // Restaura x28
    ldp x26, x27, [sp], #16      // Restaura x26 y x27
    ldp x19, x24, [sp], #16      // Restaura x19 y x24
    ldp x29, x30, [sp], #16      // Restaura FP y LR
    ret                          // Regresa al punto de llamada - main
