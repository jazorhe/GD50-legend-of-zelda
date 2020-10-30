GameObject = Class{}

function GameObject:init(def, x, y)
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1
    self.scale = def.scale or 1
    self.animation = def.animation or nil

    -- whether it acts as an obstacle or not
    self.solid = def.solid or false
    self.canCarry = def.canCarry or false
    self.isCarried = false
    self.isFlying = false
    self.breakable = def.breakable

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- default empty collision callback
    self.onCollide = function() end
    self.display = def.display or true
    self.ttl = def.ttl or nil
    self.inPlay = true
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

    if not self.isCarried then
        if self.x < MAP_XMIN or self.x + self.width > MAP_XMAX or self.y < MAP_YMIN or self.y + self.height > MAP_YMAX then

            if self.x < MAP_XMIN then
                self.x = MAP_XMIN
            elseif self.x + self.width > MAP_XMAX then
                self.x = MAP_XMAX - self.width
            elseif self.y < MAP_YMIN then
                self.y = MAP_YMIN
            elseif self.y > MAP_YMIN then
                self.y = MAP_YMAX - self.height
            end

            self:onBreak()
        end
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)

    if self.display then
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY, 0, self.scale)
    end

    if DEBUG then
        if DEBUG_TYPE == 'heart' and self.type == 'heart' then
            love.graphics.setFont(gFonts['small'])
            love.graphics.setColor(1, 0, 1, 1)
            love.graphics.print('heart: ' .. tostring(self.display), 20, VIRTUAL_HEIGHT - 15)
            love.graphics.setColor(1, 1, 1, 1)
        elseif DEBUT_TYPE == 'pots' and self.type == 'pots' then
            love.graphics.setFont(gFonts['small'])
            love.graphics.setColor(1, 0, 1, 1)
            love.graphics.print('pot: ' .. tostring(self.display), 20, VIRTUAL_HEIGHT - 15)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    if DEBUG then
        if DEBUG_OBJECTBOX then
            love.graphics.setColor(0, 1, 0, 1)
            love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

end

function GameObject:flash()
    if self.timer % 0.2 < 0.03 then
        self.display = not self.display
    end
end

function GameObject:fly(time, direction)

    local newX = nil
    local newY = nil

    if direction == 'left' then
        newX = self.x - THROW_POWER * TILE_SIZE
        newY = self.y + 16
    elseif direction == 'right' then
        newX = self.x + THROW_POWER * TILE_SIZE
        newY = self.y + 16
    elseif direction == 'up' then
        newY = self.y - THROW_POWER * TILE_SIZE
    elseif direction == 'down' then
        newY = self.y + THROW_POWER * TILE_SIZE
    end

    Timer.tween(time, {
        [self] = {x = newX, y = newY}
    }):finish(function()
        self.isFlying = false
        self.isCarried = false
        if self.breakable then
            self:onBreak()
        end
    end)
end

function GameObject:onBreak()
    gSounds['break']:stop()
    gSounds['break']:play()
    self.state = 'broken'
    self.ttl = self.timer + 2
    self.canCarry = false
    self.solid = false
end

function GameObject:collides(target)
    -- local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    if not (self.x + self.width < target.x or self.x > target.x + target.width or self.y + self.height < target.y or self.y > target.y + target.height) then

        local diffX = (self.x + self.width / 2) - (target.x + target.width / 2)
        local diffY = (self.y + self.height / 2) - (target.y + target.height / 2)
        diffX = math.abs(diffX)
        diffY = math.abs(diffY)

        if diffX > diffY then
            if self.x > target.x then
                return "right"
            else
                return "left"
            end
        else
            if self.y > target.y then
                return "down"
            else
                return "up"
            end
        end

    end

    return false
end
