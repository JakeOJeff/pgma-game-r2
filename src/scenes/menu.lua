local menu = {}

function menu:load()
    self.imgs = {
        bg = lg.newImage("assets/menu-bg.png")
    }
end

function menu:update(dt)
    
end

function menu:draw()
    lg.draw(self.imgs.bg)
end

return menu