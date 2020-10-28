GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
        scale = 1,
        ttl = nil,
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        }
    },

    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 8,
        height = 8,
        solid = false,
        defaultState = 'idle',
        scale = 0.5,
        ttl = 10,
        states = {
            ['idle'] = {
                frame = 5
            },
            ['falshing'] = {
                frame = 1
            }
        }
    },
    ['pot'] = {
        -- TODO
    }

}
