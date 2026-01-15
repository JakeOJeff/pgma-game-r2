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

        if r1 then
            local x1 = r1.x + math.floor(r1.w / 2)
            local y1 = r1.y + math.floor(r1.h / 2)
            local x2 = r2.x + math.floor(r2.w / 2)
            local y2 = r2.y + math.floor(r2.h / 2)

            for x = math.min(x1, x2), math.max(x1, x2) do
                self.tiles[y1][x] = 1
            end

            for y = math.min(y1, y2), math.max(y1, y2) do
                self.tiles[y][x2] = 1
            end
        end

    end
end

function dungeon:addWalls()
    for y = 2, self.height - 1 do
        for x = 2, self.width - 1 do
            if self.tiles[y][x] == 1 then
                for oy = -1, 1 do
                    for ox = -1, 1 do
                        if self.tiles[y + oy][x + ox] == 0 then
                            self.tiles[y + oy][x + ox] = 2
                        end
                    end
                end
            end
        end
    end
end

function dungeon:toSTI()
    local floorLayer = {
    type = "tilelayer",
    name = "Ground",
    x = 0,
    y = 0,
    width = self.width,
    height = self.height,
    visible = true,
    opacity = 1,
    offsetx = 0,
    offsety = 0,
    parallaxx = 1,
    parallaxy = 1,
    properties = {},
    encoding = "lua",
    data = {}
}

local blocksLayer = {
    type = "objectgroup",
    draworder = "topdown",
    id = 2,
    name = "blocks",
    class = "",
    visible = true,
    opacity = 1,
    offsetx = 0,
    offsety = 0,
    parallaxx = 1,
    parallaxy = 1,
    properties = {},
    objects = {}
}


    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.tiles[y][x]

            if tile == 1 then
                table.insert(floorLayer.data, 59) -- floor tile id
            else
                table.insert(floorLayer.data, 0)
            end

           local objId = 1

for y = 1, self.height do
    for x = 1, self.width do
        local tile = self.tiles[y][x]

        if tile == 1 then
            table.insert(floorLayer.data, 1)
        else
            table.insert(floorLayer.data, 0)
        end

        if tile == 2 then
            table.insert(blocksLayer.objects, {
                id = objId,
                name = "",
                type = "",
                shape = "rectangle",
                x = (x - 1) * 16,
                y = (y - 1) * 16,
                width = 16,
                height = 16,
                rotation = 0,
                visible = true,
                properties = {}
            })
            objId = objId + 1
        end

    end
end

        end
    end

    return {
    version = "1.10",
    luaversion = "5.1",
    tiledversion = "1.11.2",
    orientation = "orthogonal",
    renderorder = "right-down",
    width = self.width,
    height = self.height,
    tilewidth = 16,
    tileheight = 16,
    nextlayerid = 3,
    nextobjectid = 1,
    layers = { floorLayer, blocksLayer },
        tilesets = {
            {
            name = "tileset2",
            firstgid = 55,
            class = "",
            tilewidth = 16,
            tileheight = 16,
            spacing = 0,
            margin = 0,
            columns = 16,
            image = "src/maps/tileset2.png",
            imagewidth = 256,
            imageheight = 256,
            objectalignment = "unspecified",
            tilerendersize = "tile",
            fillmode = "stretch",
            tileoffset = {
                x = 0,
                y = 0
            },
            grid = {
                orientation = "orthogonal",
                width = 16,
                height = 16
            },
            properties = {},
            wangsets = {},
            tilecount = 256,
            tiles = {}
            }
        }

        
    }
end

return dungeon
