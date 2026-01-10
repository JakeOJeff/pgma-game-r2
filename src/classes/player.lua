local player = {}

function player:load()
    self.x = 400
    self.y = 200

    self.xVel = 0
    self.yVel = 0

    self.speed = 2000
    self.friction = 1000

    self.spriteSheet = lg.newImage('assets/sprites/player-sheet.png')
    self.grid = anim8.newGrid(12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {
        down = anim8.newAnimation(self.grid('1-4', 1), 0.2),
        left = anim8.newAnimation(self.grid('1-4', 2), 0.2),
        right = anim8.newAnimation(self.grid('1-4', 3), 0.2),
        up = anim8.newAnimation(self.grid('1-4', 4), 0.2)
    }


    self.anim = self.animations.left


    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(12, 18)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function player:update(dt)
    local moving = false

    -- Add Baton Input Later

    if lk.isDown("right") then
        self.xVel = self.speed
        self.anim = self.animations.right
        moving = true
    elseif lk.isDown("left") then
        self.xVel = -self.speed
        self.anim = self.animations.left
        moving = true
    end

    if lk.isDown("down") then
        self.yVel = self.speed
        self.anim = self.animations.down
        moving = true
    elseif lk.isDown("up") then
        self.yVel = -self.speed
        self.anim = self.animations.up
        moving = true
    end

    if not moving then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)
    self:syncPhysics()
end

function player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end

function player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

return player
