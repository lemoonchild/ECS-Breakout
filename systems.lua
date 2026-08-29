local Collision = require("collision")

local Systems = {}

-- Mueve todo lo que tenga la etiqueta "paddleControlled"
function Systems.input(world, dt, C)
    for entity in world:each("paddleControlled") do
        local pos = world:getComponent(entity, "position")
        local size = world:getComponent(entity, "size")
        local speed = world:getComponent(entity, "speed")

        if love.keyboard.isDown("left") then
            pos.x = pos.x - speed.value * dt
        elseif love.keyboard.isDown("right") then
            pos.x = pos.x + speed.value * dt
        end

        pos.x = math.max(0, math.min(pos.x, C.WINDOW_WIDTH - size.width))
    end
end

-- Mueve todo lo que tenga "velocity" 
function Systems.movement(world, dt)
    for entity in world:each("velocity") do
        local pos = world:getComponent(entity, "position")
        local vel = world:getComponent(entity, "velocity")

        pos.x = pos.x + vel.dx * dt
        pos.y = pos.y + vel.dy * dt
    end
end

-- Rebote de la pelota contra las paredes de arriba, izquierda y derecha.
-- Cada rebote invierte el eje correspondiente Y escala dx/dy juntos por
-- BALL_SPEEDUP, para que la pelota se acelere pero mantenga la misma
-- dirección relativa 
function Systems.wallCollision(world, C)
    for entity in world:each("ball") do
        local pos = world:getComponent(entity, "position")
        local size = world:getComponent(entity, "size")
        local vel = world:getComponent(entity, "velocity")
        local bounced = false

        if pos.x <= 0 then
            pos.x = 0
            vel.dx = -vel.dx
            bounced = true
        elseif pos.x + size.width >= C.WINDOW_WIDTH then
            pos.x = C.WINDOW_WIDTH - size.width
            vel.dx = -vel.dx
            bounced = true
        end

        if pos.y <= 0 then
            pos.y = 0
            vel.dy = -vel.dy
            bounced = true
        end

        if bounced then
            vel.dx = vel.dx * C.BALL_SPEEDUP
            vel.dy = vel.dy * C.BALL_SPEEDUP
        end
    end
end

-- Rebote de la pelota contra el paddle: invierte Y, aumenta velocidad,
-- y la saca de encima del paddle para que no se quede "pegada" rebotando
-- varias veces en el mismo frame.
function Systems.paddleCollision(world, C)
    for ball in world:each("ball") do
        local ballPos = world:getComponent(ball, "position")
        local ballSize = world:getComponent(ball, "size")
        local vel = world:getComponent(ball, "velocity")

        for paddle in world:each("paddleControlled") do
            local paddlePos = world:getComponent(paddle, "position")
            local paddleSize = world:getComponent(paddle, "size")

            if Collision.aabb(ballPos, ballSize, paddlePos, paddleSize) then
                ballPos.y = paddlePos.y - ballSize.height
                vel.dy = -vel.dy
                vel.dx = vel.dx * C.BALL_SPEEDUP
                vel.dy = vel.dy * C.BALL_SPEEDUP
            end
        end
    end
end

-- Si la pelota toca un bloque, lo destruye
-- (world:destroyEntity lo borra de TODOS los componentes de una vez) e
-- invierte dy. El "break" corta el loop de bloques apenas resuelve uno,
-- para no destruir varios bloques en el mismo frame por la misma pelota.
function Systems.brickCollision(world)
    for ball in world:each("ball") do
        local ballPos = world:getComponent(ball, "position")
        local ballSize = world:getComponent(ball, "size")
        local vel = world:getComponent(ball, "velocity")

        for brick in world:each("brick") do
            local brickPos = world:getComponent(brick, "position")
            local brickSize = world:getComponent(brick, "size")

            if Collision.aabb(ballPos, ballSize, brickPos, brickSize) then
                world:destroyEntity(brick)
                vel.dy = -vel.dy
                break
            end
        end
    end
end

-- Cuenta cuántos bloques quedan vivos. Si llega a 0, ganaste.
function Systems.countBricks(world)
    local count = 0
    for _ in world:each("brick") do
        count = count + 1
    end
    return count
end

-- Devuelve true si alguna pelota cayó por debajo de la pantalla (perdiste).
function Systems.ballFellBelow(world, C)
    for entity in world:each("ball") do
        local pos = world:getComponent(entity, "position")
        local size = world:getComponent(entity, "size")

        if pos.y + size.height >= C.WINDOW_HEIGHT then
            return true
        end
    end
    return false
end

-- Dibuja todo lo que tenga position + size + color, sin importar si es
-- paddle, pelota o bloque.
function Systems.render(world)
    for entity in world:each("position") do
        local pos = world:getComponent(entity, "position")
        local size = world:getComponent(entity, "size")
        local color = world:getComponent(entity, "color")

        if size and color then
            love.graphics.setColor(color.r, color.g, color.b)
            love.graphics.rectangle("fill", pos.x, pos.y, size.width, size.height)
        end
    end
end

return Systems
