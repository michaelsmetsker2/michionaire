local meetseeker = define_ball_type {
    id = 1,
    name = "meetseeker",
    texture = "meetseeker.png",
    texture_left = "meetseeker_left.png",
    texture_right = "meetseeker_right.png",
}

local oregon = define_trigger {
    id = 1,
    name = "Oregon",
    desc = "Spawns Meetseekers",
    texture = "oregon.png",
    rarity = rarities.common,
    cooldown = 0,
    synergies = { triggers.pizza, triggers.chicken },
    traits = { traits.spawner },
    can_earn = true,
    on_bonk = function(e)
        
        local price = -10 * e.api.current_tribute
        e.api.earn { source = e.self, base = price }
        
        e.api.destroy_ball { ball = e.ball }
        
        e.api.spawn_ball { from = e.self, type = meetseeker, gravity_scale = .19 }
        e.api.spawn_ball { from = e.self, type = meetseeker, gravity_scale = 1.5 }
    end,
    on_drop = function(e)
        
        for other in e.api.all_triggers() do
            if other.def ~= e.self.def then

                
                if e.api.are_triggers_adjacent { trigger = e.self, other = other} then
                    
                    e.api.earn { source = e.self, base = 1000 }
                    
                    e.api.place_trigger { def = e.self.def, slot = other.slot}
                    e.api.notify { source=e.self, silent=true, text="ASSIMILATE"}

                end
           end
        end
    end,
    on_trigger_destroyed = function(e)
        if e.reason == trigger_destroyed_reasons.forced then
            e.api.notify { source=e.self, silent=true, text="ASSIMILATE"}
        end
    end
}