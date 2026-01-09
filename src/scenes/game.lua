local game = {}

function game:load()
    camera = require 'src.libs.camera'
    cam = camera()

    anim8 = require 'src.libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'src.libs.sti'
    gameMap = sti('src/maps/testMap.lua')

    player = require 'src.classes.player'

    player:load()
end

function game:update(dt)
    player:update(dt)

    cam:lookAt(player.x, player.y)

    if cam.x < wW / 2 then
        cam.x = wW / 2
    end

    if cam.y < wH / 2 then
        cam.y = wH / 2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight


    if cam.x > (mapW - wW / 2) then
        cam.x = (mapW - wW / 2)
    end
    -- Bottom border
    if cam.y > (mapH - wH / 2) then
        cam.y = (mapH - wH / 2)
    end
end

function game:draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])
        player:draw()
    cam:detach()
end

return game
