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
end

function menu:update(dt)

end

function menu:draw()
    lg.draw(self.imgs.bg)
    lg.draw(self.imgs.art, self.artPos.x - 20, self.artPos.y)
end

return menu