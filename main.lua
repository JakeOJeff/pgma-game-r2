local SceneryInit = require("src.libs.scenery")
shove = require("src.libs.shove")

lg = love.graphics
lm = love.mouse
lk = love.keyboard

wW = lg.getWidth()
wH = lg.getHeight()

World = love.physics.newWorld(0, 2000)

local scenery = SceneryInit(
    -- { path = "path.to.scene1"; key = "scene1";  },
    { path = "src.scenes.menu"; key = "menu"},
        { path = "src.scenes.intro"; key = "intro"; default = "true"},
    { path = "src.scenes.game"; key = "game"}

)


scenery:hook(love)
