
## Integrantes nombre y apellido

Integrante 1: Sofía Ortega Rodas
Integrante 2: Vilca Juan Ignacio
Integrante 3: Ezequiel Asael Jara
Integrante 4: Cristian Gustavo Canavides


## Descripción ejercicio 1: 
Realizamos un paisaje urbano nocturno con un cielo degradado y estrellado, luna, edificios, un tren sobre un puente en primer plano, y un cartel neón con el texto OdC 2025. Se logró dibujando figuras básicas mediante subrutinas parametrizadas y manipulando pixeles.



## Descripción ejercicio 2:

Al paisaje anterior se le añade la sig. animación: el tren se desplaza cruzando el puente, y el cartel neón parpadea. Se actualizaron las coordenadas del tren en movimiento, y se alteraron los colores del cartel de neón, borrando y redibujando objetos en cada frame.


## Justificación instrucciones ARMv8:

> Ejercicio 1: 

* Se utilizan los registros generales Xn (64-bit) y Wn (32-bit), así como los registros especiales SP (Stack Pointer), XZR (Zero Register de 64-bit) y WZR (Zero Register de 32-bit)

* mov: Utilizada para mover valores entre registros. La usamos mucho: para guardar la dirección base del framebuffer (x0) en x20 al inicio del programa, para configurar los parámetros x_start, y_start, width y height (registros x21, x22, x23, x24) para las llamadas a las subrutinas de dibujo de rectángulos y círculos, cargar las constantes SCREEN_WIDTH y SCREEN_HEIGH en registros temporales (x14, x15) dentro de las subrutinas draw_rectangle y draw_circle, inicializar un puntero local al framebuffer (x9) y los contadores de bucle (x26, x27, x24) en las subrutinas de dibujo, implementar la lógica de "clipping" (recorte) al establecer coordenadas a cero o a los límites de la pantalla si exceden los rangos válidos, etc.

* movz y movk: Empleadas para la construcción de valores inmediatos de 32 bits (para colores ARGB). Movz se utiliza para establecer la parte baja (16 bits) de los valores de color ARGB de 32 bits que se almacenan en el registro w25 antes de dibujar, luego movk complementa a movz para construir los valores de color ARGB completos. movk se encarga de establecer la parte alta (los otros 16 bits, que contienen el componente Alpha y Rojo) de los colores, combinándose con el valor previamente establecido por movz.

* bl (Branch and Link): Utilizada para llamar a subrutinas (draw_rectangle, draw_circle)

* b (Branch): Utilizada para saltos incondicionales dentro de bucles y etiquetas. En nuestro código lo usamos para crear un bucle infinito (InfLoop) al final de main para mantener la imagen en pantalla, controlar el flujo dentro de los bucles de las subrutinas draw_rectangle y draw_circle (loop_x_rect, loop_y_rect, loop_x_circle, loop_y_circle), regresando al inicio del bucle o saliendo de él o saltar secciones de código (como la lógica de clipping) si no es necesario aplicarlas (.Lskip_clip_x_start, .Lskip_clip_y_start, etc.)

* stp ("Store Pair of Registers": Guarda dos registros en ubicaciones de memoria consecutivas en la pila) y ldp ("Load Pair of Registers": carga dos registros desde ubicaciones de memoria consecutivas en la pila): ambas utilizadas para guardar y restaurar pares de registros en la pila (para callee-saved registers)


* mul (Multiplicar): Realiza una multiplicación entera de dos operandos de registro y escribe el resultado en un registro de destino. Ej: mul x19, x23, x23: Calcula el radio al cuadrado (radius * radius) para la lógica de dibujo de círculos.

* add (Sumar): Realiza la suma de dos registros o de un registro y un valor inmediato. Ej: add x10, x21, x23, add x11, x22, x24: Calcula las coordenadas finales (x_end, y_end) de un rectángulo sumando el inicio y el ancho/alto

* lsl ("Logical Shift Left": Desplazamiento Lógico a la Izquierda) inmediato. Desplaza los bits de un registro a la izquierda por una cantidad inmediata, insertando ceros en el extremo menos significativo. Es equivalente a multiplicar por potencias de 2. Uso en nuestro ejercicio: lsl x12, x12, #2 y lsl x17, x17, #2: Multiplica el desplazamiento total del píxel por 4 (#2 es un desplazamiento de 2 bits a la izquierda, que es 2^2 = 4) para obtener el desplazamiento en bytes, ya que cada píxel ocupa 4 bytes (32 bits)

* str y ldr: Utilizadas para almacenar y cargar datos en/desde la memoria, incluyendo accesos al framebuffer y a los registros GPIO

* and: Realiza una operación AND a nivel de bits entre dos operandos. Ej: and w11, w10, 0b10: Se utiliza para extraer el valor del bit 2 del registro w10 (que contiene el estado de los GPIO)

* lsr: Utilizada para el desplazamiento lógico a la derecha

* cmp: Utilizada para comparar valores entre registros o con inmediatos, afectando los flags de condición. Aplicación en nuestro ejercicio 1: compara las coordenadas de inicio y fin (x_start, y_start, x_end, y_end) con cero o con los límites de la pantalla (SCREEN_WIDTH, SCREEN_HEIGH) para implementar el recorte, compara los contadores de bucle (current_y, current_x) con sus valores finales para controlar la terminación de los bucles de dibujo, compara la distancia al cuadrado del píxel al centro del círculo (distance_squared) con el radio al cuadrado (radius_squared) para determinar si el píxel está dentro del círculo.

* blt, bge, bgt (Conditional Branches): Utilizadas para saltos condicionales basados en los flags de condición

* ret (retorno) : Indica que se ha completado una subrutina. Uso en el Ejercicio 1: Marca el final de las subrutinas draw_rectangle y draw_circle, devolviendo el control al punto desde donde fueron llamadas (en este caso, main)

> Ejercicio 1: 

Se usaron practicamente las mismas instrucciones ARMv8, salvo las siguientes que nos permitieron añadir dinamismo a la imagen estática: 

* beq: esta vez para la lógica de parpadeo del texto "ODC 2025". Después de verificar si un contador de parpadeo (x10) es par (cmp x10, #0), beq .Ldraw_blinking_on dirige el flujo del programa a la sección que dibuja las letras con el color "encendido" si la condición es verdadera, permitiendo que el texto alterne entre visible y oculto

* subs (Subtract and Set Flags - Restar y Establecer Flags): Se emplea en la subrutina delay. La instrucción subs x19, x19, #1 decrementa un contador (x19) y establece los flags de condición, lo cual es vital para la siguiente instrucción bne que verifica si el contador ha llegado a cero

* bne (Branch if Not Equal): En la subrutina delay, después de subs x19, x19, #1, la instrucción bne DelayLoop se ejecuta, permitiendo que el bucle de retardo se repita un número específico de veces hasta que el contador x19 llegue a cero, controlando la velocidad de la animación

* ble (Branch if Less than or Equal): En el ejercicio 2, ble se utiliza para la lógica de movimiento del tren. Específicamente, cmp x29, x10 compara la posición actual del tren (x29) con un límite izquierdo (calculado como 0 - train_width en x10), y luego ble ResetTrainPosition hace que el tren se reinicie en el lado derecho de la pantalla si su posición es menor o igual al límite izquierdo, creando el efecto de que el tren reaparece después de salir de la pantalla.


Estas funciones nos fueron fundamentales para ejecutar la animación del tren y el efecto de parpadeo en el letrero "ODC 2025" que no estaban presentes en el diseño estático del ejercicio 1.

La mayoria de las instrucciones utilizadas en los códigos del ejercicio 1 y 2 son parte del subconjunto LEGv8, salvo unas cuantas: 

* stp y ldp: Aunque stp y ldp como pares específicos no están en el subconjunto LEGv8, las instrucciones de carga y almacenamiento como STUR (Store Register Unscaled offset) y LDUR (LoaD Register Unscaled offset) sí lo están. Las operaciones de guardar y cargar pares de registros son comunes en el conjunto de instrucciones ARMv8 real y se implementan a menudo con estas instrucciones base o sus variantes de carga/almacenamiento múltiple.

* str y ldr: Están listadas como STore Register Unscaled offset (STUR) y LoaD Register Unscaled offset (LDUR) en el set LEGv8.

* blt, bge, bgt, ble: Su funcionamiento se basaría en B.cond y los FLAGS de condición.

* ret: para retornar de una subrutina no aparece en LEGv8

* beq: en LEGv8 las instrucciones de salto condicional se presentan con el formato B.cond label

* bne (Branch if Not Equal): Aunque no está listada directamente como bne, las instrucciones CBZ y CBNZ (Compare & Branch if Not Zero) son formas de ramas condicionales que se utilizan para el flujo de control. bne se implementaría utilizando B.cond basándose en los FLAGS establecidos por una comparación previa.
