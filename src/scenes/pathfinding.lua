local pf = {}

function pf:load()
    tileSize = 50
    points = {{
        x = 0,
        y = 0,
        draggable = true
    }, {
        x = 200,
        y = 300,
        draggable = false
    }}

end

function pf:update(dt)
    for i, v in ipairs(points) do
        if v.dragging then
            if love.mouse.isDown(1) then
                local mx, my = love.mouse.getPosition()
                v.x = mx - v.offsetX
                v.y = my - v.offsetY
            end
        end
    end
end
function pf:mousepressed(x, y, button)
    for i, v in ipairs(points) do
        if v.draggable and x > v.x and x < v.x + tileSize and y > v.y and y < v.y + tileSize then
            v.dragging = true
            v.offsetX = x - v.x
            v.offsetY = y - v.y
        end
    end

end

function pf:mousereleased(x, y, button)
    for i, v in ipairs(points) do
        if v.dragging then
            local tmpX = math.ceil((v.x + (tileSize / 2)) / tileSize) * tileSize
            local tmpY = math.ceil((v.y + (tileSize / 2)) / tileSize) * tileSize

            v.x = tmpX
            v.y = tmpY
        end
    end
end

function pf:findPath()
    local ts = tileSize

    local startTX = math.floor(points[1].x / ts)
    local startTY = math.floor(points[1].y / ts)
    local goalTX = math.floor(points[2].x / ts)
    local goalTY = math.floor(points[2].y / ts)

    local open = {}
    local close = {}

    
end


function pf:draw()
    for i = 0, 40 do
        for j = 0, 40 do
            love.graphics.rectangle("line", i * tileSize, j * tileSize, tileSize, tileSize)

        end
    end
    for i, v in ipairs(points) do
        love.graphics.rectangle("fill", v.x, v.y, 50, 50)
    end
end

local function heuristic(ax, ay, bx, by)
    return math.abs(ax - bx) + math.abs(ay - by)
end


return pf
