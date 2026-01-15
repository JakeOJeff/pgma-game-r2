local dungeon = {
    width = 30,
    height = 30,
    tiles = {}, -- 0 = empty, 1 = floor, 2 = wall
    rooms = {}
}

function dungeon:init()
    for y = 1, self.height do
        self.tiles[y] = {}
        for x = 1, self.width do
            self.tiles[y][x] = 0
        end
    end
end

function dungeon:addRoom()
    local room = {
        x = love.math.random(2, self.width - 8),
        y = love.math.random(2, self.height - 8),
        w = love.math.random(4, 7),
        h = love.math.random(4, 7)
    }


    for y = room.y, room.y + room.h do
        for x = room.x, room.x + room.w do
            self.tiles[y][x] = 1
        end
    end

    table.insert(self.rooms, room)
end

function dungeon:connectRooms()
    
    for i = 1, #self.rooms do
        local r1 = self.rooms[i - 1]
        local r2 = self.rooms[i]

        local x1 = r1.x + r1.w 
        local y1 = r1.y + r1.h

        local x2 = r2.x + r2.w 
        local y2 = r2.y + r2.h

        for x = math.min(x1, x2), math.max(x1, x2) do
            self.tiles[y1][x] = 1
        end

        for y = math.min(y1, y2), math.max(y1, y2) do
            self.tiles[y][x2] = 1
        end
    end
end