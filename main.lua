local SceneryInit = require("src.libs.scenery")
local scenery = SceneryInit(
    -- { path = "path.to.scene1"; key = "scene1";  },
    { path = "src.scenes.game"; key = "game"; default = "true"}
)

scenery:hook(love)
