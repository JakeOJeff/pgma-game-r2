local SceneryInit = require("src.libs.scenery")

lg = love.graphics
lm = love.mouse
lk = love.keyboard

defW = 800 -- Default width
defH = 600 -- Default height

wW = lg.getWidth()
wH = lg.getHeight()

scale = wW/defW -- Scale Value

zoomDefault = 4
zoom = zoomDefault * scale

World = love.physics.newWorld(0, 2000)

local scenery = SceneryInit(
    -- { path = "path.to.scene1"; key = "scene1";  },
    { path = "src.scenes.menu"; key = "menu"},
        { path = "src.scenes.intro"; key = "intro"; default = "true"},
    { path = "src.scenes.game"; key = "game"}

)


function love.resize(w, h)
    wW = w
    wH = h

    scale = wW / defW
    zoom = zoomDefault * scale

end


scenery:hook(love)
