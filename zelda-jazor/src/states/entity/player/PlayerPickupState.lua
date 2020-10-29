PlayerPickupState = Class{__includes = BaseState}

function PlayerPickupState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.player.offsetY = 5
    self.player.offsetX = 0

    local direction = self.player.direction

    local pickupBoxX, pickupBoxY, pickupBoxWidth, pickupBoxHeight

    if direction == 'left' then
        pickupBoxWidth = 8
        pickupBoxHeight = 16
        pickupBoxX = self.player.x - pickupBoxWidth
        pickupBoxY = self.player.y + 2
    elseif direction == 'right' then
        pickupBoxWidth = 8
        pickupBoxHeight = 16
        pickupBoxX = self.player.x + self.player.width
        pickupBoxY = self.player.y + 2
    elseif direction == 'up' then
        pickupBoxWidth = 16
        pickupBoxHeight = 8
        pickupBoxX = self.player.x
        pickupBoxY = self.player.y - pickupBoxHeight
    else
        pickupBoxWidth = 16
        pickupBoxHeight = 8
        pickupBoxX = self.player.x
        pickupBoxY = self.player.y + self.player.height
    end

    self.pickupBox = Hitbox(pickupBoxX, pickupBoxY, pickupBoxWidth, pickupBoxHeight)
    self.player:changeAnimation('pickup-' .. self.player.direction)
end

function PlayerPickupState:enter(params)
    gSounds['pickup']:stop()
    gSounds['pickup']:play()

    self.player.currentAnimation:refresh()
end

function PlayerPickupState:update(dt)
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.canCarry and object.collides(self.pickupBox) then
            gSounds['pickedup']:play()
            -- TODO: picking up
            if self.player.currentAnimation.timesPlayed > 0 then
                self.player.currentAnimation.timesPlayed = 0
                self.player:changeState('carry', object)
            end
        end
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end
end

function PlayerPickupState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX),
        math.floor(self.player.y - self.player.offsetY))

        if DEBUG then
            if DEBUG_PICKUP then
                self.pickupBox:render(0, 1, 0, 1)
            end
        end
end
