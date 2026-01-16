local game = {}
local Dungeon = require("src.dungeon.dungeon")
local Renderer = require("src.dungeon.renderer")

local WallPhysics = require("src.dungeon.physics")

local Lighter= require("src.libs.lighter-master")

function game:load()
    lighter=Lighter()
    anim8 = require 'src.libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'src.libs.sti'
    -- gameMap = sti('src/maps/game.lua')

    -- self:spawnCollisionObjectsFromTiled()

    self.dungeon = Dungeon:new(50, 50, love.timer.getTime())
    self.dungeon:generate()

    WallPhysics:build(self.dungeon)

    self.renderer = Renderer:new(16)

    player = require 'src.classes.player'
    player:load()
    light=lighter:addLight(player.x,player.y,250,1, 0.988, 0.914)

    Textbox = require "src.classes.textbox"
    Scrap = require "src.classes.scrap"

    camera = require 'src.libs.camera'
    cam = camera(player.x, player.y, zoom)
    self:spawnPlayer()
    self:spawnScrap(6)

    -- gameMap.layers.blocks.visible = false
    -- gameMap.layers.entities.visible = false

    -- for i, v in ipairs(gameMap.layers.entities.objects) do
    --     if v.name == "scrap" then 
    --         Scrap:new(v.x + v.width / 2, v.y + v.height / 2)
    --     end
    -- end

    Textbox:new("Collected Scrap, ")

    World:setCallbacks(beginContact)

end

function game:spawnPlayer()
    local tileX, tileY = self.dungeon:getRandomRoomCenter()

    local tileSize = 16
    player.x = (tileX - 0.5) * tileSize
    player.y = (tileY - 0.5) * tileSize

    -- sync physics body if player uses physics
    if player.physics and player.physics.body then
        player.physics.body:setPosition(player.x, player.y)
        player.physics.body:setLinearVelocity(0, 0)
    end
end

function game:spawnScrap(count)
    count = count or 6

    local tileSize = 16
     
    for i = 1, count do
        local tx, ty = self.dungeon:getRandomFloorTile()

        local x = (tx + 0.5) * tileSize
        local y = (ty - 0.5) * tileSize
        x = x + (0.5 * tileSize)
        y = y + (0.5 * tileSize)
        Scrap:new(x, y)
    end
end

function game:update(dt)
    World:update(dt)
    input:update()

    Scrap:updateAll()
    local nx = player.x + player.speed * dt
    local ny = player.y + player.speed * dt

    player:update(dt)
    lighter:updateLight(light,player.x+player.width/2,player.y+player.height/2)

    cam:zoomTo(zoom)
    cam:lookAt(player.x, player.y)

    cam.x = math.floor(cam.x * zoom)/zoom
    cam.y = math.floor(cam.y * zoom)/zoom

        Textbox.updateAll(dt)


end

local w,h=love.window.getMode()
lightCanvas=lg.newCanvas(w,h)

function preDrawLights()
  love.graphics.setCanvas({ lightCanvas, stencil = true})
  love.graphics.clear(0.3, 0.3, 0.3) -- Global illumination level
  lighter:drawLights()
  love.graphics.setCanvas()
end

-- Call after you have drawn your scene (but before UI)
function drawLights()
  love.graphics.setBlendMode("multiply", "premultiplied")
  love.graphics.draw(lightCanvas)
  love.graphics.setBlendMode("alpha")
end

function game:draw()

    lg.setColor(1, 1, 1, 1)
    cam:attach()


    -- gameMap:drawLayer(gameMap.layers["Ground"])
    -- gameMap:drawLayer(gameMap.layers["Trees"])
    -- for k, v in ipairs(gameMap.layers) do
    --     if v.visible and v.opacity > 0 then
    --         gameMap:drawLayer(v)
    --     end
    -- end
    self.renderer:draw(self.dungeon)

    Scrap:drawAll()
    player:draw()
    -- player:drawPhysics()
    -- self:drawPhysics()
    preDrawLights()
    

    cam:detach()
    drawLights()

    -- UI
            Textbox.drawAll()

    love.graphics.setColor(1,1,1)
    lg.print(player.collectedScraps.."/6 scraps collected", 0, 0)
end

function game:keypressed(key)
    self:inputReceived()
    if key == "r" then
        self:load()
    end
end

function game:gamepadpressed(joystick, button)
    self:inputReceived()
end

function game:mousepressed(x, y, button)
    self:inputReceived()
end

function game:inputReceived()

end

function game:spawnCollisionObjectsFromTiled()
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
function game:drawPhysics()
    lg.setColor(1, 0, 0, 0.6)

    -- for _, collider in ipairs(self.colliders) do
    --     local body = collider.body
    --     local shape = collider.shape

    --     local points = {body:getWorldPoints(shape:getPoints())}
    --     lg.polygon("line", points)
    -- end

    lg.setColor(1, 1, 1, 1)
end

function game:findObject(objName)

    for _, obj in ipairs(gameMap.layers["entities"].objects) do
        if obj.name == objName then
            return obj
        end
    end

end

return game
