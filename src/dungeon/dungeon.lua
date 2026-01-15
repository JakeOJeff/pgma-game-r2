local Dungeon = {}
Dungeon.__index = Dungeon

-- tiles:
-- 1 = floor
-- 2 = wall

function Dungeon:new(w, h, seed)
    local d = setmetatable({}, Dungeon)

    d.width = w
    d.height = h
    d.seed = seed or os.time()

    d.tiles = {}

    return d
end

-- initialize map with walls
function Dungeon:fillWithWalls()
    for y = 1, self.height do
        self.tiles[y] = {}
        for x = 1, self.width do
            self.tiles[y][x] = 2
        end
    end
end

-- carve a rectangular room
function Dungeon:carveRoom(rx, ry, rw, rh)
    for y = ry, ry + rh - 1 do
        for x = rx, rx + rw - 1 do
            if x > 1 and y > 1 and x < self.width and y < self.height then
                self.tiles[y][x] = 1
            end
        end
    end
end

function Dungeon:generate(roomCount)
    roomCount = roomCount or 8

    math.randomseed(self.seed)

    self:fillWithWalls()

    for i = 1, roomCount do
        local roomW = math.random(4, 8)
        local roomH = math.random(4, 8)

        local roomX = math.random(2, self.width - roomW - 1)
        local roomY = math.random(2, self.height - roomH - 1)

        self:carveRoom(roomX, roomY, roomW, roomH)
    end
end

return Dungeon
