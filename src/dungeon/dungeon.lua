local Dungeon = {}
Dungeon.__index = Dungeon

-- tiles:
-- 1 = floor
-- 2 = wall top
-- 3 = wall
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

-- =========================
-- MAP INITIALIZATION
-- =========================
function Dungeon:fillWithWalls()
    for y = 1, self.height do
        self.tiles[y] = {}
        for x = 1, self.width do
            self.tiles[y][x] = 0
        end
    end
end

-- =========================
-- ROOM CARVING
-- =========================
function Dungeon:carveRoom(rx, ry, rw, rh)
    for y = ry, ry + rh - 1 do
        for x = rx, rx + rw - 1 do
            if x > 1 and y > 1 and x < self.width and y < self.height then
                self.tiles[y][x] = FLOOR
            end
        end
    end

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

-- =========================
-- TUNNELS
-- =========================
function Dungeon:carveHTunnel(x1, x2, y)
    for x = math.min(x1, x2), math.max(x1, x2) do
        for w = 0, TUNNEL_WIDTH - 1 do
            local ny = y + w
            if ny > 1 and ny < self.height then
                self.tiles[ny][x] = FLOOR
            end
        end
    end
end

function Dungeon:carveVTunnel(y1, y2, x)
    for y = math.min(y1, y2), math.max(y1, y2) do
        for w = 0, TUNNEL_WIDTH - 1 do
            local nx = x + w
            if nx > 1 and nx < self.width then
                self.tiles[y][nx] = FLOOR
            end
        end
    end
end
function Dungeon:carveCorner(cx, cy)
    for dy = 0, TUNNEL_WIDTH - 1 do
        for dx = 0, TUNNEL_WIDTH - 1 do
            local y = cy + dy
            local x = cx + dx
            if y > 1 and y < self.height and x > 1 and x < self.width then
                self.tiles[y][x] = FLOOR
            end
        end
    end
end

function Dungeon:connectRooms(roomA, roomB)
    if math.random() < 0.5 then
        -- horizontal then vertical
        self:carveHTunnel(roomA.cx, roomB.cx, roomA.cy)
        self:carveVTunnel(roomA.cy, roomB.cy, roomB.cx)

        -- FIX: fill corner
        self:carveCorner(roomB.cx, roomA.cy)

    else
        -- vertical then horizontal
        self:carveVTunnel(roomA.cy, roomB.cy, roomA.cx)
        self:carveHTunnel(roomA.cx, roomB.cx, roomB.cy)

        -- FIX: fill corner .
        self:carveCorner(roomA.cx, roomB.cy)
    end
end

-- =========================
-- GENERATION
-- =========================
function Dungeon:generate(roomCount)
    roomCount = roomCount or 6
    math.randomseed(self.seed)

    self.rooms = {}
    self:fillWithWalls()

    for i = 1, roomCount do
        local rw = math.random(8, 12)
        local rh = math.random(8, 12)

        local rx = math.random(2, self.width - rw - 1)
        local ry = math.random(2, self.height - rh - 1)

        self:carveRoom(rx, ry, rw, rh)

        if i > 1 then
            local currentRoom = self.rooms[i]
            local prevRoom = self.rooms[i - 1]
            self:connectRooms(prevRoom, currentRoom)
        end
    end

    self:createWalls()
end

-- =========================
-- HELPERS
-- =========================
function Dungeon:getRandomFloorTile()
    while true do
        local x = math.random(2, self.width - 1)
        local y = math.random(2, self.height - 1)

        if self.tiles[y][x] == FLOOR then
            return x, y
        end
    end
end

function Dungeon:getRandomRoomCenter()
    local room = self.rooms[math.random(#self.rooms)]
    return room.cx, room.cy
end

-- =========================
-- WALL LOGIC (READY FOR USE)
-- =========================
function Dungeon:checkTopAdjacents(x, y)
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
            if dx ~= 0 or dy ~= 0 then
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
    -- First pass: mark all non-floor tiles adjacent to floor as WALL
    for y = 1, self.height do
        for x = 1, self.width do
            if self.tiles[y][x] == 0 then  -- Only check hollow tiles
                self:checkBottomAdjacents(x, y)
            end
        end
    end
    
    -- Second pass: mark top walls
    for y = 1, self.height do
        for x = 1, self.width do
            if self.tiles[y][x] == WALL then  -- Only check tiles already marked as WALL
                self:checkTopAdjacents(x, y)
            end
        end
    end
end

return Dungeon
