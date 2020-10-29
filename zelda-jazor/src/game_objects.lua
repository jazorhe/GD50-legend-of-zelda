GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        defaultState = 'unpressed',
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
        type = 'pot',
        texture = 'tiles',
        frame = 33,
        width = 16,
        height = 16,
        solid = true,
        defaultState = 'idle',
        ttl = 10,
        canCarry = true,
        states = {
            ['idle'] = {
                frame = 33
            },
            ['carried'] = {
                frame = 33
            },
            ['thrown'] = {
                frame = 33
            },
            ['broken'] = {
                frame = 52
            }
        },
        animations = {
            ['breaking'] = {
                frames = {33, 52},
                interval = 0.15,
                texture = 'tiles'
            }
        }
    }
}
