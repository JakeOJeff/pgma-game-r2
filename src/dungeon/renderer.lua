-- dungeon/renderer.lua
local Renderer = {}
Renderer.__index = Renderer

function Renderer:new(tileSize)
    local r = setmetatable({}, Renderer)

    r.tileSize = tileSize
    r.tileset = love.graphics.newImage("src/maps/tileset2.png")
    r.tileset:setFilter("nearest", "nearest")

    -- TEXTURE POSITIONS 

    local floorTile = {
        xNo = 5,
        yNo = 1
    }

    local wallTile = {
        xNo = 6,
        yNo = 1
    }

    local wallBottomTile = {
        xNo = 6,
        yNo = 3
    }
    local emptyTile = {
        xNo = 7,
        yNo = 3
    }

    r.quads = {
        floor = love.graphics.newQuad((floorTile.xNo - 1) * tileSize, (floorTile.yNo - 1) * tileSize, tileSize, tileSize,
                                      r.tileset:getDimensions()),
        wall  = love.graphics.newQuad((wallTile.xNo - 1) * tileSize, (wallTile.yNo - 1) * tileSize, tileSize, tileSize,
                                      r.tileset:getDimensions()),
        wallBottom  = love.graphics.newQuad((wallBottomTile.xNo - 1) * tileSize, (wallBottomTile.yNo - 1) * tileSize, tileSize, tileSize,
                                      r.tileset:getDimensions()),
        hollow = love.graphics.newQuad((emptyTile.xNo - 1) * tileSize, (emptyTile.yNo - 1) * tileSize, tileSize, tileSize,
                                      r.tileset:getDimensions()),
    }

    return r
end
function Renderer:draw(dungeon)
    for y = 1, dungeon.height do
        for x = 1, dungeon.width do
            local tile = dungeon.tiles[y][x]
            if tile ~= 0 then
                local quad = (tile == 1) and self.quads.floor or (tile == 2 and self.quads.wall) or (tile == 3 and self.quads.wallBottom) or self.quads.hollow
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
