EntityDeadState = Class{__includes = BaseState}


function EntityDeadState:init(entity)
    self.entity = entity
end


function EntityDeadState:enter(params)

    -- if not self.entity.dead then
    --     self.entity.dead = true
    --     if true then
    --         Event.dispatch('spawn-heart', self.entity)
    --     end
    -- end

    self.entity.dead = true
    if true then
        Event.dispatch('spawn-heart', self.entity)
    end

end

function EntityDeadState:update(dt)

end

function EntityDeadState:render()

end
