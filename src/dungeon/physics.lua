local physics = {}

physics.bodies = {}


local TILE_SIZE = 16


function physics:clear()
    for _, body in ipairs(self.bodies) do
        body.distory()
    end
    self.bodies={}
end
function physics:build(dungeon)
    self:clear()

    for y = 1, dungeon.height do
        for x = 1, dungeon.width do
            if dungeon.tiles[y][x] == 2 then
                local px = (x - 0.5) * TILE_SIZE
                local py = (y - 0.5) * TILE_SIZE

                local body = love.physics.newBody(World, px, py, "static")
                local shape = love.physics.newRectangleShape(TILE_SIZE, TILE_SIZE)
                local fixture = love.physics.newFixture(body, shape)

                -- fixture:setFriction(0.8)

                table.insert(self.bodies, body)
            end
        end
    end
end
return physics