local player = {}

function player:load()
    self.x = 400
    self.y = 200

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


    self.collectedScraps = 0
    
    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
        -- height of foot collider
    local FOOT_HEIGHT = self.height / 3
    local FOOT_OFFSET_Y = (self.height - FOOT_HEIGHT) / 2

    self.physics.shape = love.physics.newRectangleShape(
        0,
        FOOT_OFFSET_Y,
        self.width,
        FOOT_HEIGHT
    )

    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function player:update(dt)
    local dx, dy = 0, 0
    local moving = false


    if input:down("right") then
        dx = dx + 1
        self.anim = self.animations.right
        moving = true
    elseif input:down("left") then
        dx = dx - 1
        self.anim = self.animations.left
        moving = true
    end

    if input:down("down") then
        dy = dy + 1
        self.anim = self.animations.down
        moving = true
    elseif input:down("up") then
        dy = dy - 1
        self.anim = self.animations.up
        moving = true
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

    if not moving then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)
    self:syncPhysics()
end


function player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 1, nil, self.width/2, self.height/2)
end

function player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end


-- DEBUG
function player:drawPhysics()
    if not self.physics.body or not self.physics.shape then return end

    love.graphics.setColor(0, 1, 0, 0.7)

    local points = { self.physics.body:getWorldPoints(self.physics.shape:getPoints()) }
    love.graphics.polygon("line", points)

    love.graphics.setColor(1, 1, 1, 1)
end

return player
