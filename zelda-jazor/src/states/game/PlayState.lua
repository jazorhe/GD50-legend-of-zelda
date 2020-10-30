PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,

        x = VIRTUAL_WIDTH / 2 - 8,
        y = VIRTUAL_HEIGHT / 2 - 11,

        width = 16,
        height = 22,

        -- one heart == 2 health

        -- rendering and collision offset for spaced sprites
        offsetY = 5,
        health = PLAYER_MAX_HEALTH * 2,
        maxhealth = PLAYER_MAX_HEALTH
    }

    self.dungeon = Dungeon(self.player)
    self.currentRoom = Room(self.player)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['pickup'] = function() return PlayerPickupState(self.player,  self.dungeon) end,
        ['carry'] = function() return PlayerCarryState(self.player, self.dungeon) end,
        ['carry-idle'] = function() return PlayerCarryIdleState(self.player, self.dungeon) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['throwing'] = function() return PlayerThrowingState(self.player, self.dungeon) end
    }
    self.player:changeState('idle')
end

function PlayState:enter(params)
    self:init()
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    if love.keyboard.wasPressed('r') then
        gStateMachine:change('play')
    end

    self.dungeon:update(dt)
end

function PlayState:render()
    -- render dungeon and all entities separate from hearts GUI
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()

    -- draw player hearts, top of screen
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, self.player.maxhealth do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1), 2)

        healthLeft = healthLeft - 2
    end
end
