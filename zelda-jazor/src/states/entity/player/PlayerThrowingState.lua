PlayerThrowingState = Class{__includes = BaseState}

function PlayerThrowingState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.currentRoom = self.dungeon.currentRoom

    self.entity.offsetY = 5
    self.entity.offsetX = 0

    local direction = self.entity.direction

    self.entity:changeAnimation('throwing-' .. self.entity.direction)
end

function PlayerThrowingState:enter(params)
    self.entity.carry = params.object
    gSounds['throw']:stop()
    gSounds['throw']:play()

    self.entity.currentAnimation:refresh()
end

function PlayerThrowingState:update(dt)
    if self.entity.carry.isCarried then
        self.entity.carry:fly(0.3, self.entity.direction)
        self.entity.carry.isCarried = false
        self.entity.carry.isFlying = self.entity.direction
    end

    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('idle')
        self.entity.carry = nil
    end
end

function PlayerThrowingState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX),
        math.floor(self.entity.y - self.entity.offsetY))

end
