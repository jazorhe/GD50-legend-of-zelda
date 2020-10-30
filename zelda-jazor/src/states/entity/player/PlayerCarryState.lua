PlayerCarryState = Class{__includes = BaseState}

function PlayerCarryState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.currentRoom = self.dungeon.currentRoom

    -- render offset for spaced character sprite
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    local direction = self.entity.direction
    self.entity:changeAnimation('carry-' .. self.entity.direction)

end

function PlayerCarryState:enter(params)
    self.entity.carry = params.object
end

function PlayerCarryState:update(dt)
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('carry-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('carry-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('carry-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('carry-down')
    else
        self.entity.stateMachine:change('carry-idle', {
            object = self.entity.carry
        })
    end

    if love.keyboard.wasPressed('f') then
        self.entity.stateMachine:change('throwing', {
            object = self.entity.carry
        })
    end

    EntityWalkState.update(self, dt)
    PlayerWalkState.bumping(self, dt)

end

function PlayerCarryState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX),
        math.floor(self.entity.y - self.entity.offsetY))

    if DEBUG then
        love.graphics.setFont(gFonts['small'])
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.print('Carring: ' .. tostring(self.entity.carry), 20, VIRTUAL_HEIGHT - 20)
        love.graphics.setColor(1, 1, 1, 1)
    end
end
