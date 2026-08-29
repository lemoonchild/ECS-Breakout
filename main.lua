local World = require("ecs")
local C = require("constants")
local Entities = require("entities")
local Systems = require("systems")

local world

function love.load()
    love.window.setMode(C.WINDOW_WIDTH, C.WINDOW_HEIGHT)
    love.window.setTitle("Breakout - ECS")

    world = World.new()

    Entities.createPaddle(world, C)
    Entities.createBall(world, C)
    Entities.createBricks(world, C)
end

function love.update(dt)
    Systems.input(world, dt, C)
    Systems.movement(world, dt)
    Systems.wallCollision(world, C)
    Systems.paddleCollision(world, C)
    Systems.brickCollision(world)

    if Systems.countBricks(world) == 0 then
        print("You Win!")
        love.event.quit()
    end

    if Systems.ballFellBelow(world, C) then
        print("Game Over")
        love.event.quit()
    end
end

function love.draw()
    Systems.render(world)
end
