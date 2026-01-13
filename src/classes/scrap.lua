Scrap = {}

Scrap.__index = Scrap
ActiveScraps = {}

function Scrap:new(x, y)
    local self = setmetatable({}, Scrap)

    self.x = x 
    self.y = y

    self.img = love.graphics.newImage()

    self.width = self.img:getWidth()
    self.height = self.img:getHeight()

    self.scaleX = 1
    self.randomTimeOffset = math.random(0, 100)
    self.toBeRemoved = false

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "static")
    self.physics.shape = love.physics.newBody(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    self.physics.fixture:setSensor(true)

    return self

end

function Scrap:update(dt)
    self:spin(dt)
    self:checkRemoved(dt)
end


function Scrap:remove()
    for i, v in ipairs(ActiveScraps) do
        if v == self then
            self.physics.body:destroy() 
            table.remove(ActiveScraps, i)
            Player.collectedScraps = Player.collectedScraps + 1             
        end
    end
end


function Scrap:spin(dt)
    self.scaleX = math.sin(love.timer.getTime() * 2 + self.randomTimeOffset)
end


function Scrap:updateAll(dt)
    for i, v in ipairs(ActiveScraps) do
        v:update(dt)
    end
end

function Scrap:checkRemoved()
    if self.toBeRemoved then
        -- local img = love.graphics.newImage()

        -- local iw, ih = img:getWidth(), img:getHeight()

        self:remove()
    end
end


function Scrap:draw()
    love.graphics.draw(self.img, self.x, self.y + self.scaleX * 4, 0, self.scaleX, 1, self.width/2 , self.height /2)
end

function Scrap:drawAll()
    for i, v in ipairs(ActiveScraps) do
        v:draw()
    end
end


function Scrap.beginContact(a, b, collision)
    for i, v in ipairs(ActiveScraps) do
        if a == v.physics.fixture or b == v.physics.fixture then
            if a == player.physics.fixture or b == player.physics.fixture then
                v.toBeRemoved = true
                return true
            end
        end
    end
end

