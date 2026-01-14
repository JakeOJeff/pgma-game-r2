local intro = {}

function intro:load()
    anim8 = require 'src.libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'src.libs.sti'
    gameMap = sti('src/maps/game.lua')

    player = require 'src.classes.player'
    player:load()

    Scrap = require "src.classes.scrap"

    camera = require 'src.libs.camera'
    cam = camera(player.x, player.y, zoom)

    self:spawnCollisionObjectsFromTiled()

    gameMap.layers.blocks.visible = false
    gameMap.layers.entities.visible = false

    for i, v in ipairs(gameMap.layers.entities.objects) do
        if v.name == "scrap" then 
            Scrap:new(v.x + v.width / 2, v.y + v.height / 2)
        end
    end
    World:setCallbacks(beginContact)

end

function intro:update(dt)
    World:update(dt)
    input:update()

    Scrap:updateAll()

        player:update(dt)


        cam:zoomTo(zoom)
        cam:lookAt(player.x, player.y)


end

function intro:draw()
   
        lg.setColor(1, 1, 1, 1)
        cam:attach()
        -- gameMap:drawLayer(gameMap.layers["Ground"])
        -- gameMap:drawLayer(gameMap.layers["Trees"])
        for k, v in ipairs(gameMap.layers) do
            if v.visible and v.opacity > 0 then
                gameMap:drawLayer(v)
            end
        end

        Scrap:drawAll()
        player:draw()
        player:drawPhysics()
        self:drawPhysics()
        cam:detach()
end

function intro:keypressed(key)
    self:inputReceived()
end

function intro:gamepadpressed(joystick, button)
    self:inputReceived()
end

function intro:mousepressed(x, y, button)
    self:inputReceived()
end

function intro:inputReceived()

end

function intro:spawnCollisionObjectsFromTiled()
    self.colliders = {}

    local layer = gameMap.layers["blocks"]
    if not layer or not layer.objects then
        return
    end

    for _, obj in ipairs(layer.objects) do
        local body = love.physics.newBody(World, obj.x + obj.width / 2, obj.y + obj.height / 2, "static")
        local shape = love.physics.newRectangleShape(obj.width, obj.height)
        local fixture = love.physics.newFixture(body, shape)

        table.insert(self.colliders, {
            body = body,
            shape = shape
        })
    end
end

-- TEMPORARY DEBUG
function intro:drawPhysics()
    lg.setColor(1, 0, 0, 0.6)

    for _, collider in ipairs(self.colliders) do
        local body = collider.body
        local shape = collider.shape

        local points = {body:getWorldPoints(shape:getPoints())}
        lg.polygon("line", points)
    end

    lg.setColor(1, 1, 1, 1)
end

function intro:findObject(objName)

    for _, obj in ipairs(gameMap.layers["entities"].objects) do
        if obj.name == objName then
            return obj
        end
    end

end

return intro
