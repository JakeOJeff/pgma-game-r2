local intro = {
}

function intro:load()


    anim8 = require 'src.libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'src.libs.sti'
    introMap = sti('src/maps/intro.lua')

    player = require 'src.classes.player'
    player:load()

    camera = require 'src.libs.camera'
    cam = camera(player.x, player.y, zoom)

    self.introCutscene = true
    self.scenes = {}
    self.sceneTexts = {
        "...",
        "'Boss Man asked me to give this to you'",
        "Oh lord, what is this"
    }
    self.currentIndex = 1
    self.cTimer = 0
    self.fadeTimer = 0

    for i = 1, 3 do
        self.scenes[i] = lg.newImage("assets/cutscenes/intro/frame" .. i .. ".png")
    end

    self:spawnCollisionObjectsFromTiled()

end

function intro:update(dt)
    World:update(dt)

    if self.introCutscene then
        self.cTimer = self.cTimer + dt
        if self.fadeTimer < 1 then
            self.fadeTimer = self.fadeTimer + (0.5 * dt)
        end
    else
        player:update(dt)

        -- local desiredX = player.x
        -- local desiredY = player.y

        -- desiredX = math.max(wW/2 / 2, math.min(desiredX, introMap.width - wW/2 / 2))
        -- desiredY = math.max(wH/2 / 2, math.min(desiredY,introMap.height - wH/2 / 2))

        -- cam:move((desiredX - cam.x) * 0.1, (desiredY - cam.y) * 0.1)

        cam:zoomTo(zoom)
        cam:lookAt(player.x, player.y)


        -- if cam.x < wW / 2 then
        --     cam.x = wW / 2
        -- end

        -- if cam.y < wH / 2 then
        --     cam.y = wH / 2
        -- end

        -- local mapW = introMap.width * introMap.tilewidth
        -- local mapH = introMap.height * introMap.tileheight

        -- if cam.x > (mapW - wW / 2) then
        --     cam.x = (mapW - wW / 2)
        -- end
        -- -- Bottom border
        -- if cam.y > (mapH - wH / 2) then
        --     cam.y = (mapH - wH / 2)
        -- end
    end
end

function intro:draw()
    if self.introCutscene then
        lg.setColor(1, 1, 1, self.fadeTimer)

        lg.push()
            lg.scale(scale, scale)
            lg.translate(0, 0)
            if self.scenes[self.currentIndex] then
                lg.draw(self.scenes[self.currentIndex], 0, 0)
            end
        lg.pop()

        local text = self.sceneTexts[self.currentIndex]
        local font = love.graphics.getFont()
        local textW = font:getWidth(text)
        local textH = font:getHeight()

        lg.setColor(1, 1, 1, (self.fadeTimer / 0.6))
        lg.print(text, (wW - textW) / 2, (wH - textH - 30))
    else
        lg.setColor(1,1,1,1)
        cam:attach()
        introMap:drawLayer(introMap.layers["Ground"])
        introMap:drawLayer(introMap.layers["Trees"])
        player:draw()
        player:drawPhysics()
        self:drawPhysics()
        cam:detach()
    end
end

function intro:keypressed(key)
    self:inputReceived()
end

function intro:gamepadpressed(joystick, button)
    self:inputReceived()
end

function intro:mousepressed(x, y, button)
    self:inputReceived()
end

function intro:inputReceived()
    if self.currentIndex < #self.sceneTexts then
        self.currentIndex = self.currentIndex + 1
        self.cTimer = 0
        self.fadeTimer = 0
    else
        self.introCutscene = false
    end
end

function intro:spawnCollisionObjectsFromTiled()
    self.colliders = {}


    local layer = introMap.layers["blocks"]
    if not layer or not layer.objects then return end


    for _, obj in ipairs(layer.objects) do
        local body = love.physics.newBody(
            World,
            obj.x + obj.width / 2,
            obj.y + obj.height / 2,
            "static"
        )
        local shape = love.physics.newRectangleShape(obj.width, obj.height)
        local fixture = love.physics.newFixture(body, shape)

        table.insert(self.colliders, {
            body = body,
            shape = shape
        })
    end
end

-- TEMPORARY DEBUG
function intro:drawPhysics()
    lg.setColor(1, 0, 0, 0.6)

    for _, collider in ipairs(self.colliders) do
        local body = collider.body
        local shape = collider.shape

        local points = { body:getWorldPoints(shape:getPoints()) }
        lg.polygon("line", points)
    end

    lg.setColor(1, 1, 1, 1)
end


return intro
