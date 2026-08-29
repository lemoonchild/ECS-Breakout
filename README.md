# ECS-Breakout

Reimplementación del clon de Breakout de la tarea de game loops (Game-Loops-Breakout) usando un **ECS (Entity-Component-System)** propio, escrito en [Lua](https://www.lua.org/) sobre el framework [LÖVE](https://love2d.org/). 

## Demo



## Gameplay

- Mueve el paddle a la izquierda y a la derecha para rebotar la pelota.
- La pelota se mueve sola de forma continua por la pantalla.
- Rebota (e incrementa su velocidad) al chocar con el paddle o con las paredes de arriba, izquierda y derecha.
- Si toca un bloque, el bloque se destruye y la pelota rebota.
- Si no queda ningún bloque, ganaste.
- Si la pelota pasa la pared de abajo, el juego termina: se imprime un mensaje en consola y la ventana se cierra.

## Controles

| Tecla | Acción |
| --- | --- |
| ← | Mover paddle a la izquierda |
| → | Mover paddle a la derecha |

## Requisitos

- [LÖVE](https://love2d.org/) 11.x o superior

## Cómo correrlo

```bash
love .
```

Ejecutar este comando desde la raíz del proyecto (la carpeta que contiene `main.lua`).

## Arquitectura: ECS propio

En vez de modelar `paddle`, `ball` y cada `brick` como tablas con estructura distinta (como en la tarea 1), acá todo el juego se construye sobre tres piezas separadas:

- **Entity**: no es más que un número (un id). No tiene datos ni comportamiento propio.
- **Component**: datos puros sin lógica, guardados por tipo (`position`, `velocity`, `size`, `color`, `speed`) o como simples etiquetas (`paddleControlled`, `ball`, `brick`).
- **System**: una función que recorre las entidades que tienen ciertos componentes y actúa sobre ellas, sin saber "qué es" cada una. Por ejemplo, `Systems.movement` mueve cualquier entidad con `position` + `velocity`, sin importarle si es la pelota o cualquier otra cosa.

Esto es composición en vez de herencia: el paddle, la pelota y un bloque comparten los mismos componentes de posición/tamaño/color para poder dibujarse igual, y lo único que los distingue es qué etiqueta llevan encima.

### Módulos

| Archivo | Responsabilidad |
| --- | --- |
| `ecs.lua` | El motor ECS: `World` con crear/destruir entidades y agregar/leer/quitar componentes. |
| `constants.lua` | Todos los valores configurables del juego (tamaños, velocidades, colores). |
| `components.lua` | Fábricas de datos de cada componente (`position`, `velocity`, `size`, `color`, `speed`). |
| `entities.lua` | Fábricas de entidades completas: `createPaddle`, `createBall`, `createBricks`. |
| `collision.lua` | Chequeo de colisión AABB entre dos rectángulos, reutilizado por varios sistemas. |
| `systems.lua` | La lógica del juego: input, movimiento, colisiones (paredes, paddle, bloques) y condiciones de fin de juego. |
| `main.lua` | Callbacks de LÖVE (`love.load`, `love.update`, `love.draw`) que arman el `World` y ejecutan los sistemas en orden cada frame. |

### Ciclo por frame

`love.update(dt)` corre, en orden:

1. `Systems.input` — mueve el paddle según el teclado (time-based, con `dt`).
2. `Systems.movement` — mueve la pelota según su velocidad.
3. `Systems.wallCollision` — rebota la pelota en las paredes de arriba/izquierda/derecha y aumenta su velocidad.
4. `Systems.paddleCollision` — rebota la pelota en el paddle (invierte Y) y aumenta su velocidad.
5. `Systems.brickCollision` — destruye el bloque golpeado e invierte la pelota en Y.
6. Se revisa la condición de victoria (`Systems.countBricks == 0`) y de derrota (`Systems.ballFellBelow`), cada una imprime un mensaje y cierra el juego con `love.event.quit()`.

`love.draw()` corre `Systems.render`, que dibuja cualquier entidad con `position` + `size` + `color` — paddle, pelota y bloques, todos con el mismo código.

## Estructura del proyecto

```
.
├── main.lua        # Callbacks de LÖVE, arma el World y corre los sistemas
├── ecs.lua         # Motor ECS (World: entidades y componentes)
├── constants.lua   # Configuración del juego
├── components.lua  # Fábricas de componentes
├── entities.lua    # Fábricas de entidades (paddle, ball, bricks)
├── collision.lua   # Chequeo de colisión AABB
├── systems.lua     # Sistemas: input, movimiento, colisiones, fin de juego
├── LICENSE
└── README.md
```

## Licencia

MIT — ver [LICENSE](LICENSE) para más detalles.
