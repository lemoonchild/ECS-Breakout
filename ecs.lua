-- Motor ECS
--
-- Entidad: Es solo un número
-- Componente: Guardados en tablas separadas por tipo
-- Sistema: Es simplemente una función que recorre los componentes que le interesan 

local World = {}
World.__index = World

function World.new()
    return setmetatable({
        nextId = 1,
        entities = {},  
        components = {}, 
    }, World)
end

function World:createEntity()
    local id = self.nextId
    self.nextId = id + 1
    self.entities[id] = true
    return id
end

function World:destroyEntity(id)
    self.entities[id] = nil
    for _, store in pairs(self.components) do
        store[id] = nil
    end
end

function World:addComponent(entity, name, data)
    self.components[name] = self.components[name] or {}
    self.components[name][entity] = data or {}
    return data
end

function World:getComponent(entity, name)
    local store = self.components[name]
    return store and store[entity]
end

function World:removeComponent(entity, name)
    local store = self.components[name]
    if store then
        store[entity] = nil
    end
end

function World:has(entity, name)
    return self:getComponent(entity, name) ~= nil
end

-- Itera sobre todas las entidades que tienen el componente `name`.
function World:each(name)
    return pairs(self.components[name] or {})
end

return World
