local pf = {}

function pf:load()
    points = {
        {
            x = 0,
            y = 0,
            draggable = true
        },
        {
            x = 0,
            y = 0,
            draggable = false
        }
    }
end

function pf:update(dt)
    for i, v in ipairs(points) do
        local mx, my = love.mouse.getPosition()
        if v.draggable and mx > v.x and mx < v.x + 50 and my > v.y and my < v.y + 50 then
            v.x, v.y = mx, my
        end
    end
end

function pf:draw()
    
end



return pf