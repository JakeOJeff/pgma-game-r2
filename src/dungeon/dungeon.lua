local Dungeon = {}
Dungeon.__index = Dungeon

-- tiles:
-- 1 = floor
-- 2 = wall
-- 3 = wallBottom
-- 0 = hollow

local TUNNEL_WIDTH = 2
local FLOOR = 1
local WALL_TOP = 2
local WALL = 3
local TOP_CHECK_DEPTH = 3

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
    for x = 1, self.width do
        self.tiles[x] = {}
        for y = 1, self.height do
            self.tiles[x][y] = 0
        end
    end
end

-- carve a rectangular room
function Dungeon:carveRoom(rx, ry, rw, rh)
            for x = rx, rx + rw - 1 do

    for y = ry, ry + rh - 1 do
            if x > 1 and y > 1 and x < self.width and y < self.height  then 
                self.tiles[x][y] = 1
            end
        end
    end

    -- store room center
    local centerX = math.floor(rx + rw / 2)
    local centerY = math.floor(ry + rh / 2)

    table.insert(self.rooms, {
        x = rx,
        y = ry,
        w = rw,
        h = rh,
        cx = centerX,
        cy = centerY
    })
end

-- carve a horizontal tunnel
function Dungeon:carveHTunnel(x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
        for w = 0, TUNNEL_WIDTH - 1 do
            if x > 1 and x < self.width and y + w > 1 and y + w < self.height then
                self.tiles[y + w][x] = 1
            end
        end
    end
end

-- carve a vertical tunnel
function Dungeon:carveVTunnel(y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
        for w = 0, TUNNEL_WIDTH - 1 do
            if y > 1 and y < self.height and x + w > 1 and x + w < self.width then
                self.tiles[y][x + w] = 1
            end
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
    roomCount = roomCount or 6

    math.randomseed(self.seed)

    self.rooms = {}
    self:fillWithWalls()

    for i = 1, roomCount do
        local rw = math.random(4, 12)
        local rh = math.random(4, 12)

        local rx = math.random(2, self.width - rw - 1)
        local ry = math.random(2, self.height - rh - 1)

        self:carveRoom(rx, ry, rw, rh)  



        -- connect to previous room
        if i > 1 then
            local currentRoom = self.rooms[i]
            local closestRoom = self:findClosestRoom(currentRoom)
            self:connectRooms(closestRoom, currentRoom)
        end

    end

    self:createWalls()
end
function Dungeon:getRandomFloorTile()
    while true do
        local x = math.random(2, self.width - 1)
        local y = math.random(2, self.height - 1)

        if self.tiles[y][x] == 1 then
            return x, y
        end
    end
end
function Dungeon:getRandomRoomCenter()
    local room = self.rooms[math.random(#self.rooms)]
    return room.cx, room.cy
end

function Dungeon:roomDistance(a, b)
    local dx = a.cx - b.cx
    local dy = a.cy - b.cy
    return dx * dx + dy * dy -- squared distance (faster, no sqrt)
end
function Dungeon:findClosestRoom(room)
    local closest = nil
    local closestDist = math.huge

    for i = 1, #self.rooms - 1 do
        local other = self.rooms[i]
        local dist = self:roomDistance(room, other)

        if dist < closestDist then
            closestDist = dist
            closest = other
        end
    end

    return closest
end


function Dungeon:checkTopAdjacents(x, y)
    -- do not overwrite floor
    if self.tiles[y][x] == FLOOR then return end

    for dy = 1, TOP_CHECK_DEPTH do
        local ny = y + dy
        if self.tiles[ny] and self.tiles[ny][x] == FLOOR then
            self.tiles[y][x] = WALL_TOP
            return
        end
    end
end

function Dungeon:checkBottomAdjacents(x, y)
    if self.tiles[y][x] == FLOOR then return end

    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dx == 0 and dy == 0) then
                local ny = y + dy
                local nx = x + dx

                if self.tiles[ny] and self.tiles[ny][nx] == FLOOR then
                    self.tiles[y][x] = WALL
                    return
                end
            end
        end
    end
end
function Dungeon:createWalls()
    for y = 1, self.height do
        for x = 1, self.width do
                        self:checkBottomAdjacents(x, y)

            self:checkTopAdjacents(x, y)
        end
    end
end

return Dungeon
