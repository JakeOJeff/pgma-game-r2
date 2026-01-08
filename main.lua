local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit(
    -- { path = "path.to.scene1"; key = "scene1";  },
    { path = "src.scenes.game"; key = "game"; default = "true"}
)

shove = require("src.libs.shove")
shove.setResolution(144,128,{fitMethod="aspect",renderMode="direct"}) --pls change the resolution to what you want
shove.setWindowMode(800, 600, {resizable = true})

scenery:hook(love)
