-- Solo forma de los datos.

local Components = {}

function Components.position(x, y)
    return {x = x, y = y}
end

function Components.velocity(dx, dy)
    return {dx = dx, dy = dy}
end

function Components.size(width, height)
    return {width = width, height = height}
end

function Components.color(r, g, b)
    return {r = r, g = g, b = b}
end

function Components.speed(value)
    return {value = value}
end

return Components
