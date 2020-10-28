EntityDeadState = Class{__includes = BaseState}


function EntityDeadState:init(entity)
    self.entity = entity
end


function EntityDeadState:enter(params)
    self.entity.dead = true
    if math.random(3) == 1 then
        Event.dispatch('spawn-heart', self.entity)
    end
end

function EntityDeadState:update(dt)

end

function EntityDeadState:render()

end
