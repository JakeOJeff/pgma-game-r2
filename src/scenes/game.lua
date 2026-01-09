local game = {}

function game:load()
    camera = require 'libs.camera'
    cam = camera()

    anim8 = require 'libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'libs.sti'
    gameMap = sti('src/maps/testMap.lua')

    
end

function game:update(dt)
    
end

function game:draw()
    
end

return game