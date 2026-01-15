-- dungeon/dungeon.lua
local Dungeon = {}
Dungeon.__index = Dungeon

function Dungeon:new(w, h)
    local d = setmetatable({}, Dungeon)
    d.width = w
    d.height = h
    d.tiles = {} -- 0 = empty, 1 = floor, 2 = wall
    return d
end

function Dungeon:generate()
    for y = 1, self.height do
        self.tiles[y] = {}
        for x = 1, self.width do
            if x == 1 or y == 1 or x == self.width or y == self.height then
                self.tiles[y][x] = 2
            else
                self.tiles[y][x] = 1
            end
        end
    end
end

return Dungeon
