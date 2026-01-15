-- dungeon/collision.lua
local Collision = {}

function Collision:isBlocked(dungeon, px, py, w, h)
    local tileSize = 16

    local left   = math.floor(px / tileSize) + 1
    local right  = math.floor((px + w - 1) / tileSize) + 1
    local top    = math.floor(py / tileSize) + 1
    local bottom = math.floor((py + h - 1) / tileSize) + 1

    for y = top, bottom do
        for x = left, right do
            if dungeon.tiles[y] and dungeon.tiles[y][x] == 2 then
                return true
            end
        end
    end

    return false
end

return Collision
