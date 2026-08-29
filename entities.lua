local Components = require("components")

local Entities = {}

-- Tiene posición, tamaño, color, velocidad de
-- movimiento y la etiqueta "paddleControlled" que dice "esto lo mueve el
-- teclado". Esa etiqueta es lo único que la distingue de cualquier otro
-- rectángulo en pantalla.
function Entities.createPaddle(world, C)
    local paddle = world:createEntity()

    world:addComponent(paddle, "position", Components.position(
        (C.WINDOW_WIDTH - C.PADDLE_WIDTH) / 2,
        C.WINDOW_HEIGHT - 40
    ))
    world:addComponent(paddle, "size", Components.size(C.PADDLE_WIDTH, C.PADDLE_HEIGHT))
    world:addComponent(paddle, "color", Components.color(C.PADDLE_COLOR.r, C.PADDLE_COLOR.g, C.PADDLE_COLOR.b))
    world:addComponent(paddle, "speed", Components.speed(C.PADDLE_SPEED))
    world:addComponent(paddle, "paddleControlled")

    return paddle
end

-- A diferencia del paddle, tiene "velocity", se
-- mueve sola cada frame sin que nadie la controle. dx/dy ya son la
-- velocidad real en píxeles por segundo así "aumentar velocidad" es simplemente escalar
-- dx y dy.
function Entities.createBall(world, C)
    local ball = world:createEntity()

    world:addComponent(ball, "position", Components.position(
        (C.WINDOW_WIDTH - C.BALL_SIZE) / 2,
        C.WINDOW_HEIGHT / 2
    ))
    world:addComponent(ball, "size", Components.size(C.BALL_SIZE, C.BALL_SIZE))
    world:addComponent(ball, "velocity", Components.velocity(C.BALL_SPEED, -C.BALL_SPEED))
    world:addComponent(ball, "color", Components.color(C.BALL_COLOR.r, C.BALL_COLOR.g, C.BALL_COLOR.b))
    world:addComponent(ball, "ball")

    return ball
end

-- Arma la grilla de bloques. Cada bloque es su propia entidad independiente
-- solo que ahora en vez de guardarlos en una lista Lua los guarda como
-- entidades del World.
function Entities.createBricks(world, C)
    local bricks = {}

    for row = 0, C.BRICK_ROWS - 1 do
        for col = 0, C.BRICK_COLS - 1 do
            local brick = world:createEntity()
            local x = col * (C.BRICK_WIDTH + C.BRICK_PADDING) + C.BRICK_PADDING
            local y = row * (C.BRICK_HEIGHT + C.BRICK_PADDING) + C.BRICK_TOP_OFFSET
            local brickColor = C.BRICK_COLORS[row + 1]

            world:addComponent(brick, "position", Components.position(x, y))
            world:addComponent(brick, "size", Components.size(C.BRICK_WIDTH, C.BRICK_HEIGHT))
            world:addComponent(brick, "color", Components.color(brickColor.r, brickColor.g, brickColor.b))
            world:addComponent(brick, "brick")

            table.insert(bricks, brick)
        end
    end

    return bricks
end

return Entities
