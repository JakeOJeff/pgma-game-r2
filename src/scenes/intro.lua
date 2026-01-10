local intro = {}

function intro:load()
    camera = require 'src.libs.camera'
    cam = camera()

    anim8 = require 'src.libs.anim8'
    lg.setDefaultFilter("nearest", "nearest")

    sti = require 'src.libs.sti'
    introMap = sti('src/maps/intro.lua')

    player = require 'src.classes.player'

    player:load()

    self.introCutscene = true
    self.scenes = {}
    self.sceneTexts = {}
    self.currentIndex = 0
    self.cTimer = 0
    self.fadeTimer = 0

    for i = 1, 3 do
        self.scenes[i] = lg.newImage("assets/cutscenes/intro/frame" .. i .. ".png")
    end
end

function intro:update(dt)
    if self.introCutscene then
        self.cTimer = self.cTimer + dt
        if self.fadeTimer < 1 then
            self.fadeTimer = self.fadeTimer + (0.5 * dt)
        end
    else
        player:update(dt)

        cam:lookAt(player.x, player.y)

        if cam.x < wW / 2 then
            cam.x = wW / 2
        end

        if cam.y < wH / 2 then
            cam.y = wH / 2
        end

        local mapW = introMap.width * introMap.tilewidth
        local mapH = introMap.height * introMap.tileheight


        if cam.x > (mapW - wW / 2) then
            cam.x = (mapW - wW / 2)
        end
        -- Bottom border
        if cam.y > (mapH - wH / 2) then
            cam.y = (mapH - wH / 2)
        end
    end
end

function intro:draw()
    if self.introCutscene then
        

    else
        cam:attach()
            introMap:drawLayer(introMap.layers["Ground"])
            introMap:drawLayer(introMap.layers["Trees"])
            player:draw()
        cam:detach()
    end

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

return intro
