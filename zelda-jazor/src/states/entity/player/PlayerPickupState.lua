PlayerPickupState = Class{__includes = BaseState}

function PlayerPickupState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon
    self.currentRoom = self.dungeon.currentRoom

    self.entity.offsetY = 5
    self.entity.offsetX = 0

    local direction = self.entity.direction

    local pickupBoxX, pickupBoxY, pickupBoxWidth, pickupBoxHeight

    if direction == 'left' then
        pickupBoxWidth = 8
        pickupBoxHeight = 16
        pickupBoxX = self.entity.x - pickupBoxWidth
        pickupBoxY = self.entity.y + 2
    elseif direction == 'right' then
        pickupBoxWidth = 8
        pickupBoxHeight = 16
        pickupBoxX = self.entity.x + self.entity.width
        pickupBoxY = self.entity.y + 2
    elseif direction == 'up' then
        pickupBoxWidth = 16
        pickupBoxHeight = 8
        pickupBoxX = self.entity.x
        pickupBoxY = self.entity.y - pickupBoxHeight
    else
        pickupBoxWidth = 16
        pickupBoxHeight = 8
        pickupBoxX = self.entity.x
        pickupBoxY = self.entity.y + self.entity.height
    end

    self.pickupBox = Hitbox(pickupBoxX, pickupBoxY, pickupBoxWidth, pickupBoxHeight)
    self.entity:changeAnimation('pickup-' .. self.entity.direction)
end

function PlayerPickupState:enter(params)
    gSounds['pickup']:stop()
    gSounds['pickup']:play()

    self.entity.currentAnimation:refresh()
end

function PlayerPickupState:update(dt)
    for k, object in pairs(self.currentRoom.objects) do
        if object.canCarry and object:collides(self.pickupBox) then
            gSounds['pickedup']:play()
            -- TODO: picking up
            if self.entity.currentAnimation.timesPlayed > 0 then
                self.entity.currentAnimation.timesPlayed = 0
                self.entity.stateMachine:change('carry-idle', {
                    object = object
                })
                object.isCarried = true
                object.solid = false
            end
        end
    end

    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('idle')
    end
end

function PlayerPickupState:render()
    local anim = self.entity.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.entity.x - self.entity.offsetX),
        math.floor(self.entity.y - self.entity.offsetY))

        if DEBUG then
            if DEBUG_PICKUP then
                self.pickupBox:render(0, 1, 0, 1)
            end
        end
end
