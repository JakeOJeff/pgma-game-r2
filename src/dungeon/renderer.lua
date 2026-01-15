-- dungeon/renderer.lua
local Renderer = {}
Renderer.__index = Renderer

function Renderer:new(tileSize)
    local r = setmetatable({}, Renderer)

    r.tileSize = tileSize
    r.tileset = love.graphics.newImage("src/maps/tileset2.png")
    r.tileset:setFilter("nearest", "nearest")

    r.quads = {
        floor = love.graphics.newQuad(0, 0, tileSize, tileSize,
                                      r.tileset:getDimensions()),
        wall  = love.graphics.newQuad(tileSize, 0, tileSize, tileSize,
                                      r.tileset:getDimensions())
    }

    return r
end
function Renderer:draw(dungeon)
    for y = 1, dungeon.height do
        for x = 1, dungeon.width do
            local tile = dungeon.tiles[y][x]
            if tile ~= 0 then
                local quad = (tile == 1) and self.quads.floor or self.quads.wall
                love.graphics.draw(
                    self.tileset,
                    quad,
                    (x - 1) * self.tileSize,
                    (y - 1) * self.tileSize
                )
            end
        end
    end
end

return Renderer
