local menu = {}

function menu:load()
    self.imgs = {
        bg = lg.newImage("assets/menu-bg.png"),
        art = lg.newImage("assets/menu-art.png")
    }

    self.artPos = {
        x = 0,
        y = 0
    }

    self.parallax = {
        strength = 10, -- max pixels to move left/right
        x = 0,
        targetX = 0,
        speed = 20,
        
        -- ADD DEADZONE LATER
    }
end

function menu:update(dt)
    local mx = love.mouse.getX()
    local screenW = lg.getWidth()


    local t = (mx / screenW) * 2 - 1
    self.parallax.targetX = t * self.parallax.strength


    local alpha = 1 - math.exp(-self.parallax.speed * dt)
    self.parallax.x = self.parallax.x + (self.parallax.targetX - self.parallax.x) * alpha
end

function menu:draw()
    lg.draw(self.imgs.bg)
    lg.draw(self.imgs.art, self.artPos.x - 20+ self.parallax.x, self.artPos.y)
end

return menu