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
        x = love.math.random
    }
end