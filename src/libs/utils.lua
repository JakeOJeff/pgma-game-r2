local utils = {}

function utils.dist(x1, y1, x2, y2)
    return (math.sqrt((x2 - x1)^2 + (y2 - y1)^2))
end

function beginContact(a, b, collision)
    Scrap.beginContact(a, b, collision)
end

return utils