Enemy = {}
Enemy.__index = Enemy

Enemies = {}

function Enemy:new(x, y)

    local self = setmetatable({}, Enemy)

    self.x = x
    self.y = y

    self.xVel = 0
    self.yVel = 0

    self.width = 12
    self.height = 18

    self.speed = 40
    self.friction = 1000

    self.spriteSheet = lg.newImage('assets/sprites/player-sheet.png')
    self.grid = anim8.newGrid(self.width, self.height, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {
        down = anim8.newAnimation(self.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(self.grid('1-4', 2), 0.2),
        right = anim8.newAnimation(self.grid('1-4', 3), 0.2),
        up = anim8.newAnimation(self.grid('1-4', 4), 0.2)
    }

    self.anim = self.animations.left

    self.isMoving = true

    self.collectedScraps = 0

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    -- height of foot collider
    local FOOT_HEIGHT = self.height / 3
    local FOOT_OFFSET_Y = (self.height - FOOT_HEIGHT) / 2

    self.physics.shape = love.physics.newRectangleShape(0, FOOT_OFFSET_Y, self.width, FOOT_HEIGHT)

    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)

    table.insert(Enemies, self)

    return self
end

function Enemy:update(dt)
    local dx, dy = 0, 0

    if self.isMoving then

        if self:detectedPlayer() then
            dx, dy = self:moveCoord(player.x, player.y, self.x, self.y)
        else
            dx = 0
        end

    end
    if math.abs(dx) > math.abs(dy) then
        if dx > 0 then
            self.anim = self.animations.right
        elseif dx < 0 then
            self.anim = self.animations.left
        end
    else
        if dy > 0 then
            self.anim = self.animations.down
        elseif dy < 0 then
            self.anim = self.animations.up
        end
    end

    -- Normalize diagonal movement
    local len = math.sqrt(dx * dx + dy * dy)
    if len > 0 then
        dx = dx / len
        dy = dy / len

        self.xVel = dx * self.speed
        self.yVel = dy * self.speed
    else
        -- Apply friction when not moving
        self.xVel = math.max(math.min(0, self.xVel - self.friction * dt), 0)
        self.yVel = math.max(math.min(0, self.yVel - self.friction * dt), 0)
    end

    if dx == 0 and dy == 0 then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)
    self:syncPhysics()
end

function Enemy:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 1, nil, self.width / 2, self.height / 2)
end

function Enemy:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

function Enemy:detectedPlayer()
    return coordDist(player.x, player.y, self.x, self.y) <= 100
end

function Enemy:moveCoord(x1, y1, x2, y2)
    dx = (x1 > x2 and 1) or (x1 < x2 and -1) or 0
    dy = (y1 > y2 and 1) or (y1 < y2 and -1) or 0
    return dx, dy
end
-- DEBUG
function Enemy:drawPhysics()
    if not self.physics.body or not self.physics.shape then
        return
    end

    love.graphics.setColor(0, 1, 0, 0.7)

    local points = {self.physics.body:getWorldPoints(self.physics.shape:getPoints())}
    love.graphics.polygon("line", points)

    love.graphics.setColor(1, 1, 1, 1)
end

function coordDist(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

return Enemy
