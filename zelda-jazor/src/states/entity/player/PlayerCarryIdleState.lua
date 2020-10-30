PlayerCarryIdleState = Class{__includes = PlayerIdleState}


function PlayerCarryIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.currentRoom = self.dungeon.currentRoom

    self.entity.offsetY = 5
    self.entity.offsetX = 0

    local direction = self.entity.direction
    self.entity:changeAnimation('carry-idle-' .. self.entity.direction)
end


function PlayerCarryIdleState:enter(params)
    self.entity.carry = params.object
end

function PlayerCarryIdleState:update(dt)
    EntityIdleState.update(self, dt)
    self.entity:changeAnimation('carry-idle-' .. self.entity.direction)
end

function PlayerCarryIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity.stateMachine:change('carry', {
            object = self.entity.carry
        })
    end

    if love.keyboard.wasPressed('space') then
        self.entity.stateMachine:change('throwing', {
            object = self.entity.carry
        })
    end

    if love.keyboard.wasPressed('f') then
        self.entity.stateMachine:change('throwing', {
            object = self.entity.carry
        })
    end

end
