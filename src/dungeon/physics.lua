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
            if dungeon.tiles[y][x] == 2 or dungeon.tiles[y][x] == 3 then
                local px = (x - 0.5) * TILE_SIZE
                local py = (y - 0.5) * TILE_SIZE

                if dungeon.tiles[y+1][x] and dungeon.tiles[y+1][x]~=1 and dungeon.tiles[y][x]~=2 then
                    local px2 = (x-1) * TILE_SIZE
                    local py2 = (y-1) * TILE_SIZE

                    lighter:addPolygon({
                        px2,py2,
                        px2+TILE_SIZE,py2,
                        px2+TILE_SIZE,py2+TILE_SIZE,
                        px2,py2+TILE_SIZE
                    })
                end

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