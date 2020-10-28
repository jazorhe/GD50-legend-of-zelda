GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.scale = def.scale

    -- default empty collision callback
    self.onCollide = function() end
    self.inPlay = true
    self.display = true
    self.ttl = def.ttl
    self.timer = 0
end

function GameObject:update(dt)
    if self.inPlay then
        self.timer = self.timer + dt

        if self.ttl and self.ttl - self.timer < 4 then
            if self.ttl < self.timer then
                self.inPlay = false
            else
                self:flash()
            end
        end
    end

end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if self.display then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY, 0, self.scale)
    end

    if DEBUG and self.type == 'heart' then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.print('heart: ' .. tostring(self.display), 20, VIRTUAL_HEIGHT - 15)
        love.graphics.setColor(1, 1, 1, 1)
    end
end

function GameObject:flash()
    if self.timer % 0.2 < 0.01 then
        self.display = not self.display
    end
end
