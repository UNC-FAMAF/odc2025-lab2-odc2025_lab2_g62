.equ SCREEN_WIDTH,          640
.equ SCREEN_HEIGH,          480
.equ BITS_PER_PIXEL,        32

.equ GPIO_BASE,       0x3f200000
.equ GPIO_GPFSEL0,    0x00
.equ GPIO_GPLEV0,     0x34

.globl main

main:
    // x0 contiene la direccion base del framebuffer
    mov x20, x0 // Guarda la dirección base del framebuffer en x20

    // Carga las constantes de pantalla en registros dedicados para su uso en llamadas a subrutinas
    mov x8, #SCREEN_WIDTH
    mov x9, #SCREEN_HEIGH

// INICIO DEL CÓDIGO DEL DIBUJO ESTÁTICO QUE YA HABIAMOS HECHO PARA EL EJERCICIO 1
// Acá va a estar el bloque de código que dibuja todos los elementos que no se van a mover

    // Fondito (cielo con degradado)
    // Sección 1: violeta muy oscuro (parte superior)
    mov x21, #0; mov x22, #0; mov x23, x8; mov x24, #60 // Usamos x8 para SCREEN_WIDTH
    movz w25, #0x0010, lsl #0 // BBGG
    movk w25, #0xFF10, lsl #16 // AARR
    bl draw_rectangle

    // Sección 2: violeta oscuro
    mov x21, #0; mov x22, #60; mov x23, x8; mov x24, #60 // Usamos x8 para SCREEN_WIDTH
    movz w25, #0x0020, lsl #0
    movk w25, #0xFF20, lsl #16
    bl draw_rectangle

    // Sección 3: violeta con tonalidad media
    mov x21, #0; mov x22, #120; mov x23, x8; mov x24, #60 // Usamos x8 para SCREEN_WIDTH
    movz w25, #0x0030, lsl #0
    movk w25, #0xFF30, lsl #16
    bl draw_rectangle

    // Sección 4: violeta claro
    mov x21, #0; mov x22, #180; mov x23, x8; mov x24, #60 // Usamos x8 para SCREEN_WIDTH
    movz w25, #0x0040, lsl #0
    movk w25, #0xFF40, lsl #16
    bl draw_rectangle

    //  Sección 5: violeta más claro (cercanito al horizonte de edificios)
    mov x21, #0; mov x22, #240; mov x23, x8; mov x24, #240 // Cubre hasta la base, usamos x8
    movz w25, #0x0050, lsl #0
    movk w25, #0xFF50, lsl #16
    bl draw_rectangle

    // Edificios de fondo 
    // Color: 0xFF151515 (gris)
    movz w25, #0x1515, lsl #0
    movk w25, #0xFF15, lsl #16

    // Edificio alto y delgado izquierda 
    mov x21, #0; mov x22, #100; mov x23, #40; mov x24, #380; bl draw_rectangle
    // Edificio con antena (fondo)
    mov x21, #80; mov x22, #120; mov x23, #70; mov x24, #360; bl draw_rectangle
    // Edificio central izquierda (fondo)
    mov x21, #180; mov x22, #150; mov x23, #80; mov x24, #330; bl draw_rectangle
    // Edificio de fondo a la izquierda del central más alto
    mov x21, #220; mov x22, #150; mov x23, #30; mov x24, #330; bl draw_rectangle
    // Edificio de fondo a la derecha del central más alto
    mov x21, #390; mov x22, #150; mov x23, #30; mov x24, #330; bl draw_rectangle
    // Edificio central derecha (fondo)
    mov x21, #400; mov x22, #180; mov x23, #70; mov x24, #300; bl draw_rectangle
    // Edificio delgado derecha (fondo)
    mov x21, #500; mov x22, #160; mov x23, #50; mov x24, #320; bl draw_rectangle
    // Edificio extremo derecha (fondo)
    mov x21, #580; mov x22, #190; mov x23, #60; mov x24, #290; bl draw_rectangle
    // Edificio de fondo adicional a la izquierda
    mov x21, #40; mov x22, #200; mov x23, #40; mov x24, #280; bl draw_rectangle
    // Edificio de fondo adicional a la derecha
    mov x21, #550; mov x22, #210; mov x23, #30; mov x24, #270; bl draw_rectangle

    // Edificios que estan en primer plano
    // Color: 0xFF000000 (Negro)
    movz w25, #0x0000, lsl #0
    movk w25, #0xFF00, lsl #16

    mov x21, #0; mov x22, #280; mov x23, x8; mov x24, #200; bl draw_rectangle // Usamos x8 para SCREEN_WIDTH

    // Edificio principal izquierda (rectangulos apilados)
    mov x21, #0; mov x22, #280; mov x23, #150; mov x24, #200; bl draw_rectangle // Base
    mov x21, #10; mov x22, #260; mov x23, #130; mov x24, #20; bl draw_rectangle // Nivel medio
    mov x21, #20; mov x22, #240; mov x23, #110; mov x24, #20; bl draw_rectangle // Nivel superior

    // Edificio intermedio izquierda
    mov x21, #150; mov x22, #200; mov x23, #100; mov x24, #280; bl draw_rectangle // Base más alta 
    mov x21, #160; mov x22, #180; mov x23, #80; mov x24, #20; bl draw_rectangle // Parte superior 

    // Edificio central más alto y puntiagudo 
    mov x21, #250; mov x22, #80; mov x23, #140; mov x24, #400; bl draw_rectangle // Base más ancha
    mov x21, #290; mov x22, #60; mov x23, #60; mov x24, #20; bl draw_rectangle // Punta

    // Edificio de relleno entre el central y el de la cúpula
    mov x21, #390; mov x22, #280; mov x23, #10; mov x24, #200; bl draw_rectangle

    // Edificio con cúpula (primer plano)
    mov x21, #400; mov x22, #200; mov x23, #120; mov x24, #280; bl draw_rectangle // Base
    mov x21, #420; mov x22, #180; mov x23, #80; mov x24, #20; bl draw_rectangle // Base cúpula
    mov x21, #430; mov x22, #160; mov x23, #60; mov x24, #20; bl draw_rectangle // Cúpula inferior
    mov x21, #440; mov x22, #140; mov x23, #40; mov x24, #20; bl draw_rectangle // Cúpula superior

    // Edificio de relleno entre el de la cúpula y el extremo derecho
    mov x21, #520; mov x22, #280; mov x23, #10; mov x24, #200; bl draw_rectangle

    // Edificio extremo derecha (rectangulos apilados)
    mov x21, #530; mov x22, #250; mov x23, #110; mov x24, #230; bl draw_rectangle // Base
    mov x21, #540; mov x22, #230; mov x23, #90; mov x24, #20; bl draw_rectangle // Medio
    mov x21, #550; mov x22, #210; mov x23, #70; mov x24, #20; bl draw_rectangle // Superior

    // Dibuja ventanas iluminadas (Amarillo/Naranja)
    // Color: 0xFFF7D700 (RGB F7D700, Alpha FF)
    movz w25, #0xD700, lsl #0
    movk w25, #0xFFF7, lsl #16

    // Ventanas edificio principal izquierda 
    mov x21, #20; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #40; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #60; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #20; mov x22, #280; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #40; mov x22, #280; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #60; mov x22, #280; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #80; mov x22, #300; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #100; mov x22, #300; mov x23, #10; mov x24, #10; bl draw_rectangle

    // Ventanas edificio intermedio izquierda 
    mov x21, #170; mov x22, #200; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #190; mov x22, #200; mov x23, #10; mov x24, #10; bl draw_rectangle 
    mov x21, #210; mov x22, #200; mov x23, #10; mov x24, #10; bl draw_rectangle 
    mov x21, #170; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #190; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #210; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle

    // Ventanas edificio central más alto
    mov x21, #290; mov x22, #100; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #320; mov x22, #100; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #350; mov x22, #100; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #290; mov x22, #130; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #320; mov x22, #130; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #350; mov x22, #130; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #290; mov x22, #160; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #320; mov x22, #160; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #350; mov x22, #160; mov x23, #15; mov x24, #15; bl draw_rectangle

    // Ventanas edificio a la derecha
    mov x21, #540; mov x22, #270; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #560; mov x22, #270; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #580; mov x22, #270; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #540; mov x22, #290; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #560; mov x22, #290; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #580; mov x22, #290; mov x23, #10; mov x24, #10; bl draw_rectangle

    // Dibuja ventanas apagadas (Azul claro)
    // Color: 0xFF00B0FF (RGB 00B0FF, Alpha FF)
    movz w25, #0xB0FF, lsl #0
    movk w25, #0xFF00, lsl #16
    mov x21, #410; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #430; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #450; mov x22, #220; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #410; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #430; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #450; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle

    // Dibuja ventanas apagadas (Gris)
    // Color: 0xFF505050 (Gris oscuro)
    movz w25, #0x5050, lsl #0
    movk w25, #0xFF50, lsl #16
    mov x21, #20; mov x22, #340; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #40; mov x22, #340; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #60; mov x22, #340; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #170; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #190; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle 
    mov x21, #210; mov x22, #240; mov x23, #10; mov x24, #10; bl draw_rectangle 
    mov x21, #170; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #190; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #210; mov x22, #260; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #290; mov x22, #190; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #320; mov x22, #190; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #350; mov x22, #190; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #290; mov x22, #220; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #320; mov x22, #220; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #350; mov x22, #220; mov x23, #15; mov x24, #15; bl draw_rectangle
    mov x21, #540; mov x22, #310; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #560; mov x22, #310; mov x23, #10; mov x24, #10; bl draw_rectangle
    mov x21, #580; mov x22, #310; mov x23, #10; mov x24, #10; bl draw_rectangle

    // Estrellas (en color blanco) con diferentes tamaños
    // Color: 0xFFFFFFFF (Blanco puro)
    movz w25, #0xFFFF, lsl #0
    movk w25, #0xFFFF, lsl #16

    // Estrellas pequeñas (1x1)
    mov x21, #50; mov x22, #10; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #120; mov x22, #25; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #200; mov x22, #15; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #280; mov x22, #5; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #350; mov x22, #30; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #410; mov x22, #10; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #480; mov x22, #40; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #550; mov x22, #20; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #600; mov x22, #50; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #10; mov x22, #60; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #70; mov x22, #80; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #140; mov x22, #90; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #220; mov x22, #70; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #310; mov x22, #60; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #390; mov x22, #80; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #470; mov x22, #90; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #530; mov x22, #70; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #590; mov x22, #80; mov x23, #1; mov x24, #1; bl draw_rectangle

    // Estrellas un poco más grandes (2x2)
    mov x21, #20; mov x22, #30; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #90; mov x22, #5; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #160; mov x22, #40; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #240; mov x22, #20; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #300; mov x22, #50; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #380; mov x22, #25; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #450; mov x22, #15; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #510; mov x22, #35; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #570; mov x22, #10; mov x23, #2; mov x24, #2; bl draw_rectangle

    // Luna y los Cráteres
    // Luna
    // Color: 0xFFC0C0C0 (Gris claro)
    movz w25, #0xC0C0, lsl #0
    movk w25, #0xFFC0, lsl #16
    mov x21, #550; mov x22, #80; mov x23, #40; bl draw_circle // Luna principal

    // Cráteres (en forma de circulitos)
    // Color: 0xFF808080 (Gris oscuro)
    movz w25, #0x8080, lsl #0
    movk w25, #0xFF80, lsl #16
    mov x21, #530; mov x22, #65; mov x23, #8; bl draw_circle // Cráter 1
    mov x21, #560; mov x22, #100; mov x23, #5; bl draw_circle // Cráter 2
    mov x21, #540; mov x22, #85; mov x23, #10; bl draw_circle // Cráter 3
    mov x21, #575; mov x22, #75; mov x23, #6; bl draw_circle // Cráter 4

    // Dibuja el cartel "ODC 2025"
    // Color del texto (Fucsia brillante)
    movz w25, #0x00FF, lsl #0 // BBGG (00FF)
    movk w25, #0xFFFF, lsl #16 // AARR (FF)

    // O (12x16 pixels)
    mov x21, #298; mov x22, #290; mov x23, #12; mov x24, #2; bl draw_rectangle 
    mov x21, #298; mov x22, #306; mov x23, #12; mov x24, #2; bl draw_rectangle 
    mov x21, #298; mov x22, #292; mov x23, #2; mov x24, #12; bl draw_rectangle 
    mov x21, #308; mov x22, #292; mov x23, #2; mov x24, #12; bl draw_rectangle 

    // C (12x16 pixels)
    mov x21, #331; mov x22, #290; mov x23, #12; mov x24, #2; bl draw_rectangle 
    mov x21, #331; mov x22, #306; mov x23, #12; mov x24, #2; bl draw_rectangle 
    mov x21, #331; mov x22, #292; mov x23, #2; mov x24, #12; bl draw_rectangle
    // 0 (12x16 pixels)
    mov x21, #306; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle
    mov x21, #306; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle
    mov x21, #306; mov x22, #318; mov x23, #2; mov x24, #12; bl draw_rectangle 
    mov x21, #316; mov x22, #318; mov x23, #2; mov x24, #12; bl draw_rectangle

    // 5 (12x16 pixels)
    mov x21, #340; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle 
    mov x21, #340; mov x22, #318; mov x23, #2; mov x24, #6; bl draw_rectangle 
    mov x21, #340; mov x22, #324; mov x23, #12; mov x24, #2; bl draw_rectangle
    mov x21, #350; mov x22, #326; mov x23, #2; mov x24, #6; bl draw_rectangle 
    mov x21, #340; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle 

    // Puente (es la base)
    // Color: 0xFF304050 (Gris azulado oscuro)
    movz w25, #0x4050, lsl #0
    movk w25, #0xFF30, lsl #16
    mov x21, #0; mov x22, #380; mov x23, x8; mov x24, #20; bl draw_rectangle 

    // Las columnas del puente
    // Color: 0xFF506070 (Gris más claro)
    movz w25, #0x6070, lsl #0
    movk w25, #0xFF50, lsl #16

    // Columnas
    mov x21, #50; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 
    mov x21, #150; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 
    mov x21, #250; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 
    mov x21, #350; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 
    mov x21, #450; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 
    mov x21, #550; mov x22, #400; mov x23, #10; mov x24, #80; bl draw_rectangle 

// FIN DEL CÓDIGO DE IMAGEN ESTÁTICA QUE HABIAMOS HECHO PARA EL EJECICIO 1

// INICIO DE LA ANIMACIÓN DEL TREN Y LETRAS

    // x29: train_x_pos (posición X actual del tren)
    // x19: train_speed (velocidad del tren)
    // x16: train_width (ancho total del tren)
    // x27: old_train_x_pos (posición X anterior del tren)
    // x5: blinking_counter (contador para el parpadeo de letras)

    mov x16, #460 // train_width (ancho total del tren en píxeles)
    mov x29, x8 // train_x_pos = SCREEN_WIDTH (para que inicie fuera de pantalla a la derecha)
    mov x19, #-2 // train_speed (velocidad del tren, -2 píxeles por frame para mover a la izquierda)
    mov x5, #0 // Inicializa el contador de parpadeo

AnimationLoop:
    // Guarda la posición X actual del tren para borrarlo después de moverlo
    mov x27, x29 // x27 = old_train_x_pos

    // Actualiza la posición X del tren
    add x29, x29, x19 // train_x_pos += train_speed (se resta por ser x19 negativo)

    // Calcula el límite izquierdo para el reinicio del tren
    mov x10, #460 // Carga el ancho del tren en un registro temporal (train_width)
    sub x10, xzr, x10 // x10 = 0 - train_width (posición donde el tren está completamente fuera por la izquierda)

    // Comprueba si el tren salió de la pantalla por la izquierda y resetea su posición
    cmp x29, x10 // Compara la posición actual del tren con el límite izquierdo
    ble ResetTrainPosition // Si train_x_pos <= (0 - train_width), resetear la posición

DrawTrain: // Etiqueta para dibujar el tren
    // Borra la posición anterior del tren dibujando un rectángulo negro (color de la base de la ciudad)
    // La base de la ciudad es de color 0xFF000000 y se encuentra en y=280 hasta y=480
    // El tren está en y=360 con altura 20, por lo que cubre y=360 a y=379
    movz w25, #0x0000, lsl #0 // Color negro (fondo de la ciudad)
    movk w25, #0xFF00, lsl #16
    mov x21, x27; mov x22, #360; mov x23, x16; mov x24, #20; bl draw_rectangle // Borra el tren anterior

    // Dibuja el tren en su nueva posición (usando x29 para la coordenada X)
    // Color del cuerpo del tren: 0xFF404048 (Gris oscuro con toque azul)
    movz w25, #0x4048, lsl #0
    movk w25, #0xFF40, lsl #16

    // Vagón delantero
    mov x21, x29; mov x22, #360; mov x23, #70; mov x24, #20; bl draw_rectangle

    // Vagones restantes (dibujados individualmente para crear la separación)
    // Vagón 2: Inicia 10px después del vagón delantero
    add x10, x29, #80 // x_pos + 70 (vagón 1) + 10 (espacio) = x_pos + 80
    mov x21, x10; mov x22, #360; mov x23, #120; mov x24, #20; bl draw_rectangle // Vagón 2

    // Vagón 3: Inicia 10px después del vagón 2
    add x10, x29, #210 // x_pos + 80 (vagón 1 + espacio) + 120 (vagón 2) + 10 (espacio) = x_pos + 210
    mov x21, x10; mov x22, #360; mov x23, #120; mov x24, #20; bl draw_rectangle // Vagón 3

    // Vagón 4: Inicia 10px después del vagón 3
    add x10, x29, #340 // x_pos + 210 (vagón 3 + espacio) + 120 (vagón 3) + 10 (espacio) = x_pos + 340
    mov x21, x10; mov x22, #360; mov x23, #120; mov x24, #20; bl draw_rectangle // Vagón 4

    // Color de las ventanas del tren: 0xFFF7A000 (Naranja)
    movz w25, #0xA000, lsl #0
    movk w25, #0xFFF7, lsl #16

    // Ventana del vagón delantero - Centrada en 70px de ancho
    add x10, x29, #25 // Offset de 25px desde el inicio del tren (180 + 25 = 205)
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle

    // Ventanas vagón 2 (relativas al inicio del vagón 2, que es x_pos + 80)
    add x10, x29, #80 + 10 // x_pos + 90
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #80 + 30 // x_pos + 110
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #80 + 50 // x_pos + 130
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #80 + 70 // x_pos + 150
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle

    // Ventanas vagón 3 (relativas al inicio del vagón 3, que es x_pos + 210)
    add x10, x29, #210 + 10 // x_pos + 220
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #210 + 30 // x_pos + 240
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #210 + 50 // x_pos + 260
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #210 + 70 // x_pos + 280
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle

    // Ventanas vagón 4 (relativas al inicio del vagón 4, que es x_pos + 340)
    add x10, x29, #340 + 10 // x_pos + 350
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #340 + 30 // x_pos + 370
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #340 + 50 // x_pos + 390
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle
    add x10, x29, #340 + 70 // x_pos + 410
    mov x21, x10; mov x22, #365; mov x23, #15; mov x24, #10; bl draw_rectangle

    // Color de los detalles oscuros del tren (ruedas)
    // Color: 0xFF000000 (Negro)
    movz w25, #0x0000, lsl #0
    movk w25, #0xFF00, lsl #16

    // Detalles debajo del tren (ruedas)
    // Ruedas del vagón delantero (relativas al inicio del vagón delantero, que es x_pos)
    add x10, x29, #10 // Offset de 10px desde el inicio del tren (180 + 10 = 190)
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #30 // Offset de 30px desde el inicio del tren (180 + 30 = 210)
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle

    // Ruedas del vagón 2 (relativas al inicio del vagón 2, que es x_pos + 80)
    add x10, x29, #80 + 20 // x_pos + 100
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #80 + 40 // x_pos + 120
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #80 + 60 // x_pos + 140
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #80 + 80 // x_pos + 160
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle

    // Ruedas del vagón 3 (relativas al inicio del vagón 3, que es x_pos + 210)
    add x10, x29, #210 + 20 // x_pos + 230
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #210 + 40 // x_pos + 250
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #210 + 60 // x_pos + 270
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #210 + 80 // x_pos + 290
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle

    // Ruedas del vagón 4 (relativas al inicio del vagón 4, que es x_pos + 340)
    add x10, x29, #340 + 20 // x_pos + 360
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #340 + 40 // x_pos + 380
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #340 + 60 // x_pos + 400
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle
    add x10, x29, #340 + 80 // x_pos + 420
    mov x21, x10; mov x22, #375; mov x23, #10; mov x24, #5; bl draw_rectangle

    // Parpadeo para la letra 'D' y los dos '2's de "ODC 2025"
    add x5, x5, #1 // Incrementa el contador de parpadeo
    and x10, x5, #0b1 // Comprueba si el contador es par o impar (x10 = 0 si par, 1 si impar)

    cmp x10, #0 // Compara con 0 (par)
    beq .Ldraw_blinking_on // Si es par, dibuja los caracteres
    b .Ldraw_blinking_off // Si es impar, dibuja negro para apagarlos

.Ldraw_blinking_on:
    movz w25, #0x00FF, lsl #0 // Color Fucsia brillante (ESTA ENCENDIDO)
    movk w25, #0xFFFF, lsl #16
    // Dibuja 'D'
    mov x21, #314; mov x22, #290; mov x23, #2; mov x24, #16; bl draw_rectangle // Vertical izquierda
    mov x21, #316; mov x22, #290; mov x23, #8; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #316; mov x22, #306; mov x23, #8; mov x24, #2; bl draw_rectangle // Horizontal inferior
    mov x21, #324; mov x22, #292; mov x23, #2; mov x24, #12; bl draw_rectangle // Curva derecha
    // Dibuja el primer '2'
    mov x21, #290; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #300; mov x22, #318; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal superior derecha
    mov x21, #290; mov x22, #324; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal central
    mov x21, #290; mov x22, #326; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal inferior izquierda
    mov x21, #290; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal inferior
    // Dibuja el segundo '2'
    mov x21, #323; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #333; mov x22, #318; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal superior derecha
    mov x21, #323; mov x22, #324; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal central
    mov x21, #323; mov x22, #326; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal inferior izquierda
    mov x21, #323; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal inferior
    b .Lend_blinking_logic

.Ldraw_blinking_off:
    movz w25, #0x0000, lsl #0 // Color negro (APAGADO, es color del fondo de la ciudad)
    movk w25, #0xFF00, lsl #16
    // Dibuja 'D' con negro
    mov x21, #314; mov x22, #290; mov x23, #2; mov x24, #16; bl draw_rectangle // Vertical izquierda
    mov x21, #316; mov x22, #290; mov x23, #8; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #316; mov x22, #306; mov x23, #8; mov x24, #2; bl draw_rectangle // Horizontal inferior
    mov x21, #324; mov x22, #292; mov x23, #2; mov x24, #12; bl draw_rectangle // Curva derecha
    // Dibuja el primer '2' con negro
    mov x21, #290; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #300; mov x22, #318; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal superior derecha
    mov x21, #290; mov x22, #324; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal central
    mov x21, #290; mov x22, #326; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal inferior izquierda
    mov x21, #290; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal inferior
    // Dibuja el segundo '2' con negro
    mov x21, #323; mov x22, #316; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal superior
    mov x21, #333; mov x22, #318; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal superior derecha
    mov x21, #323; mov x22, #324; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal central
    mov x21, #323; mov x22, #326; mov x23, #2; mov x24, #6; bl draw_rectangle // Parte diagonal inferior izquierda
    mov x21, #323; mov x22, #332; mov x23, #12; mov x24, #2; bl draw_rectangle // Horizontal inferior

.Lend_blinking_logic:
    add x6, x6, #1 // Incrementa el contador de parpadeo
    and x10, x6, #0b11 // 
    cmp x10, #0 // Compara con 0 
    beq .Ldraw_stars_on
    b .Ldraw_stars_off
    
.Ldraw_stars_on:
    // Estrellas encendidas 
    movz w25, #0xFFFF, lsl #0
    movk w25, #0xFFFF, lsl #16
    b .Ldraw_stars

.Ldraw_stars_off:
    // Estrellas menos blancas
    movz w25, #0xAAAA, lsl #0 // un blanco mas apagado
    movk w25, #0xFFAA, lsl #16

.Ldraw_stars:
    // Dibuja las estrellas (1x1) y (3x3)
    mov x21, #50; mov x22, #10; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #120; mov x22, #25; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #200; mov x22, #15; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #280; mov x22, #5; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #350; mov x22, #30; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #410; mov x22, #10; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #480; mov x22, #40; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #550; mov x22, #20; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #600; mov x22, #50; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #10; mov x22, #60; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #70; mov x22, #80; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #140; mov x22, #90; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #220; mov x22, #70; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #310; mov x22, #60; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #390; mov x22, #80; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #470; mov x22, #90; mov x23, #1; mov x24, #1; bl draw_rectangle
    mov x21, #530; mov x22, #70; mov x23, #3; mov x24, #3; bl draw_rectangle
    mov x21, #590; mov x22, #80; mov x23, #1; mov x24, #1; bl draw_rectangle

    // Dibuja las estrellas más grandes (2x2)
    mov x21, #20; mov x22, #30; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #90; mov x22, #5; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #160; mov x22, #40; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #240; mov x22, #20; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #300; mov x22, #50; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #380; mov x22, #25; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #450; mov x22, #15; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #510; mov x22, #35; mov x23, #2; mov x24, #2; bl draw_rectangle
    mov x21, #570; mov x22, #10; mov x23, #2; mov x24, #2; bl draw_rectangle
    
    // Retardo para controlar la velocidad de la animación
    mov x0, #0x1000000 // Valor de retardo
    bl delay

    // Bucle infinito para mantener la animacion en pantalla
    b AnimationLoop

ResetTrainPosition:
    // Reinicia la posición del tren para que aparezca por la derecha
    mov x29, x8 // train_x_pos = SCREEN_WIDTH (para que aparezca totalmente fuera por la derecha)
    b DrawTrain // Vuelve a dibujar el tren en su posición inicial (y se borrará el rastro anterior)

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

.align 4 // Asegura la alineación para las secciones de datos y código

//INCLUIMOS LAS SUBRUTINAS

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
    // Guarda los registros callee-saved que serán modificados por esta subrutina.
    // x29 (Frame Pointer) y x30 (Link Register) son esenciales para el flujo de llamadas.
    // x26 y x27 se usarán como contadores de bucle y son callee-saved.
    stp x29, x30, [sp, #-16]! // Guarda FP y LR en la pila
    stp x26, x27, [sp, #-16]! // Guarda x26 y x27 en la pila

    // x9 se usará como puntero al pixel actual en el framebuffer.
    // x10, x11, x12, x13, x14 se usarán para cálculos temporales.
    // Estos son caller-saved, por lo que no es necesario guardarlos aquí.

    // Carga SCREEN_WIDTH en un registro para usarlo en la multiplicación
    mov x14, #SCREEN_WIDTH
    mov x15, #SCREEN_HEIGH // Carga SCREEN_HEIGH

    // Inicializa el puntero base del framebuffer para uso local en x9
    mov x9, x20

    // Calcula las coordenadas finales del rectángulo (exclusivas)
    add x10, x21, x23 // x_end = x_start + width
    add x11, x22, x24 // y_end = y_start + height

    // Clipping de las coordenadas de inicio
    cmp x21, #0
    blt .Lclip_x_start_to_zero
    b .Lskip_clip_x_start
.Lclip_x_start_to_zero:
    mov x21, #0
.Lskip_clip_x_start:

    cmp x22, #0
    blt .Lclip_y_start_to_zero
    b .Lskip_y_start
.Lclip_y_start_to_zero:
    mov x22, #0
.Lskip_y_start:

    // Clipping de las coordenadas finales
    cmp x10, x14 // Compara x_end con SCREEN_WIDTH
    bgt .Lclip_x_end_to_width
    b .Lskip_x_end
.Lclip_x_end_to_width:
    mov x10, x14
.Lskip_x_end:

    cmp x11, x15 // Compara y_end con SCREEN_HEIGH
    bgt .Lclip_y_end_to_height
    b .Lskip_y_end
.Lclip_y_end_to_height:
    mov x11, x15
.Lskip_y_end:

    // Inicializa el contador de fila (current_y) con y_start
    mov x26, x22 // x26 = current_y

loop_y_rect:
    // Comprueba si hemos dibujado todas las filas
    cmp x26, x11 // Compara current_y con y_end
    bge end_draw_rectangle_proc // Si current_y >= y_end, termina la subrutina

    // Inicializa el contador de columna (current_x) con x_start para cada nueva fila
    mov x27, x21 // x27 = current_x

loop_x_rect:
    // Comprueba si hemos dibujado todos los píxeles en la fila actual
    cmp x27, x10 // Compara current_x con x_end
    bge end_loop_x_rect // Si current_x >= x_end, pasa a la siguiente fila

    // Calcula el offset del píxel: (current_y * SCREEN_WIDTH + current_x) * 4
    // Multiplica current_y por SCREEN_WIDTH para obtener el inicio de la fila en píxeles
    mul x12, x26, x14 // x12 = current_y * SCREEN_WIDTH (x14 contiene SCREEN_WIDTH)
    // Suma current_x para obtener la posición del píxel dentro de la fila
    add x12, x12, x27 // x12 = (current_y * SCREEN_WIDTH) + current_x
    // Multiplica por 4 (bytes por píxel, ya que BITS_PER_PIXEL es 32) para obtener el offset en bytes
    lsl x12, x12, #2 // x12 = x12 * 4 

    // Calcula la dirección de memoria del píxel actual
    add x13, x9, x12 // x13 = framebuffer_base + offset

    // Almacena el color de 32 bits (w25) en la dirección calculada
    str w25, [x13] // Guarda el color en el pixel actual

    // Incrementa el contador de columna
    add x27, x27, #1 // current_x++
    b loop_x_rect // Vuelve al inicio del bucle de columnas

end_loop_x_rect:
    // Incrementa el contador de fila
    add x26, x26, #1 // current_y++
    b loop_y_rect // Vuelve al inicio del bucle de filas

end_draw_rectangle_proc:
    // Restaura los registros callee-saved que fueron guardados al inicio
    ldp x26, x27, [sp], #16 // Restaura x26 y x27
    ldp x29, x30, [sp], #16 // Restaura FP y LR
    ret // Regresa al punto de llamada (main)

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
    stp x29, x30, [sp, #-16]! // Guarda FP y LR
    stp x19, x24, [sp, #-16]! // Guarda x19 (radius_squared) y x24 (current_y)
    stp x26, x27, [sp, #-16]! // Guarda x26 (current_x) y x27 (dy)
    stp x28, xzr, [sp, #-16]! // Guarda x28 (dx)

    // Calcula radius_squared = radius * radius
    mul x19, x23, x23 // x19 = radius * radius

    // Carga SCREEN_WIDTH y SCREEN_HEIGH en registros para usarlo en la multiplicación y clipping
    mov x18, #SCREEN_WIDTH
    mov x17, #SCREEN_HEIGH // Usamos x17 para SCREEN_HEIGH

    // Inicializa el puntero base del framebuffer para uso local en x9
    mov x9, x20

    // Calcula los límites del bucle para y (bounding box del círculo)
    sub x12, x22, x23 // y_min = y_center - radius
    add x13, x22, x23 // y_max = y_center + radius

    // Clipping de y_min
    cmp x12, #0
    blt .Lclip_y_min_to_zero_circle
    b .Lskip_clip_y_min_circle
.Lclip_y_min_to_zero_circle:
    mov x12, #0
.Lskip_clip_y_min_circle:

    // Clipping de y_max
    cmp x13, x17 // Compara y_max con SCREEN_HEIGH
    bgt .Lclip_y_max_to_height_circle
    b .Lskip_clip_y_max_circle
.Lclip_y_max_to_height_circle:
    mov x13, x17
.Lskip_clip_y_max_circle:

    // Bucle para cada fila (current_y)
    mov x24, x12 // x24 = current_y = y_min

loop_y_circle:
    cmp x24, x13 // Compara current_y con y_max
    bgt end_draw_circle_proc // Si current_y > y_max, termina la subrutina

    // Calcula dy = current_y - y_center
    sub x27, x24, x22 // x27 = dy

    // Calcula dy_squared = dy * dy
    mul x10, x27, x27 // x10 = dy_squared

    // Calcula los límites del bucle para x (bounding box del círculo)
    sub x14, x21, x23 // x_min = x_center - radius
    add x15, x21, x23 // x_max = x_center + radius

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
    mov x26, x14 // x26 = current_x = x_min

loop_x_circle:
    cmp x26, x15 // Compara current_x con x_max
    bgt end_loop_x_circle // Si current_x > x_max, pasa a la siguiente fila

    // Calcula dx = current_x - x_center
    sub x28, x26, x21 // x28 = dx

    // Calcula dx_squared = dx * dx
    mul x11, x28, x28 // x11 = dx_squared

    // Calcula distance_squared = dx_squared + dy_squared
    add x16, x11, x10 // x16 = distance_squared

    // Comprueba si el píxel está dentro del círculo
    cmp x16, x19 // Compara distance_squared con radius_squared
    bgt skip_pixel // Si distance_squared > radius_squared, salta este píxel

    // Dibuja el píxel
    // Calcula el offset del píxel: (current_y * SCREEN_WIDTH + current_x) * 4
    mul x17, x24, x18 // x17 = current_y * SCREEN_WIDTH (x18 contiene SCREEN_WIDTH)
    add x17, x17, x26 // x17 = (current_y * SCREEN_WIDTH) + current_x
    lsl x17, x17, #2 // x17 = x17 * 4 

    // Calcula la dirección de memoria del píxel actual
    add x17, x9, x17 // x17 = framebuffer_base + offset

    // Almacena el color de 32 bits (w25) en la dirección calculada
    str w25, [x17] // Guarda el color en el pixel actual

skip_pixel:
    // Incrementa el contador de columna
    add x26, x26, #1 // current_x++
    b loop_x_circle // Vuelve al inicio del bucle de columnas

end_loop_x_circle:
    // Incrementa el contador de fila
    add x24, x24, #1 // current_y++
    b loop_y_circle // Vuelve al inicio del bucle de filas

end_draw_circle_proc:
    // Restaura los registros callee-saved que fueron guardados al inicio
    ldp x28, xzr, [sp], #16 // Restaura x28
    ldp x26, x27, [sp], #16 // Restaura x26 y x27
    ldp x19, x24, [sp], #16 // Restaura x19 y x24
    ldp x29, x30, [sp], #16 // Restaura FP y LR
    ret // Regresa al punto de llamada (main)

// Subrutina de retardo
// x0: Valor para el contador de retardo
delay:
    // Guarda registros callee-saved que se modificarán
    stp x29, x30, [sp, #-16]! // Guarda FP y LR
    stp x19, xzr, [sp, #-16]! // Guarda x19 (contador)
    mov x19, x0 // Copia el valor de retardo a x19
DelayLoop:
    subs x19, x19, #1 // Decrementa el contador
    bne DelayLoop // Si no es cero, continúa el bucle
    // Restaura registros callee-saved
    ldp x19, xzr, [sp], #16 // Restaura x19
    ldp x29, x30, [sp], #16 // Restaura FP y LR
    ret
