Hitbox = Class{}

function Hitbox:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Hitbox:render(r, g, b, a)
    love.graphics.setColor(r, g, b, a)
    love.graphics.rectangle('line', self.x, self.y,
        self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end
