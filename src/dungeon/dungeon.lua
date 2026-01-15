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
    d.rooms = {}

    return d
end

-- fill entire map with walls
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

    -- store room center
    local centerX = math.floor(rx + rw / 2)
    local centerY = math.floor(ry + rh / 2)

    table.insert(self.rooms, {
        x = rx, y = ry, w = rw, h = rh,
        cx = centerX, cy = centerY
    })
end

-- carve a horizontal tunnel
function Dungeon:carveHTunnel(x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
        if x > 1 and x < self.width and y > 1 and y < self.height then
            self.tiles[y][x] = 1
        end
    end
end

-- carve a vertical tunnel
function Dungeon:carveVTunnel(y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
        if x > 1 and x < self.width and y > 1 and y < self.height then
            self.tiles[y][x] = 1
        end
    end
end

-- connect two rooms with an L-shaped corridor
function Dungeon:connectRooms(roomA, roomB)
    if math.random() < 0.5 then
        self:carveHTunnel(roomA.cx, roomB.cx, roomA.cy)
        self:carveVTunnel(roomA.cy, roomB.cy, roomB.cx)
    else
        self:carveVTunnel(roomA.cy, roomB.cy, roomA.cx)
        self:carveHTunnel(roomA.cx, roomB.cx, roomB.cy)
    end
end

function Dungeon:generate(roomCount)
    roomCount = roomCount or 8

    math.randomseed(self.seed)

    self.rooms = {}
    self:fillWithWalls()

    for i = 1, roomCount do
        local rw = math.random(4, 8)
        local rh = math.random(4, 8)

        local rx = math.random(2, self.width - rw - 1)
        local ry = math.random(2, self.height - rh - 1)

        self:carveRoom(rx, ry, rw, rh)

        -- connect to previous room
        if i > 1 then
            self:connectRooms(self.rooms[i - 1], self.rooms[i])
        end
    end
end

return Dungeon
