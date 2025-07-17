local meetseeker = define_ball_type {
    id = 1,
    name = "meetseeker",
    texture = "meetseeker.png",
    texture_left = "meetseeker_left.png",
    texture_right = "meetseeker_right.png",
}

local oregonTrigger = define_trigger {
    id = 2,
    name = "Oregon",
    desc = "Spawns Meetseekers",
    texture = "oregon.png",
    rarity = rarities.undraftable,
    cooldown = 1,
    synergies = { boons.rabbits_foot, boons.chonken, boons.zoo, triggers.chicken, triggers.whale, triggers.pizza, triggers.chicken},
    traits = { traits.spawner },
    can_earn = true,
    on_bonk = function(e)
        
        local price = -50 * e.api.current_tribute
        e.api.earn { source = e.self, base = price }
        
        e.api.destroy_ball { ball = e.ball }
        
        e.api.spawn_ball { from = e.self, type = meetseeker, gravity_scale = 1.4 }
        e.api.spawn_ball { from = e.self, type = meetseeker, gravity_scale = 1.4 }
    end,
    on_drop = function(e)
        
        for other in e.api.all_triggers() do
            if other.def ~= e.self.def then

                
                if e.api.are_triggers_adjacent { trigger = e.self, other = other} then
                    
                    e.api.earn { source = e.self, base = 1000 }
                    
                    e.api.replace_trigger { trigger = other, def = e.self.def, spawn_effect = "smoke"}
                    e.api.notify { source=e.self, silent=true, text="ASSIMILATE"}

                end
           end
        end
    end,
    on_trigger_destroyed = function(e)
        if e.reason == trigger_destroyed_reasons.forced then
            e.api.notify { source=e.self, silent=true, text="ASSIMILATE"}
        end
    end,
    on_destroying = function(e)
        if e.reason == trigger_destroyed_reasons.removed then
            e.api.replace_trigger { trigger = e.self, def = e.self.def, spawn_effect = "smoke"}
            e.api.notify { source=e.self, silent=true, text="Bad Mistake buddy."}
        end
    end
}
local oregonDraft = define_trigger_draft {
    id = 3,
    accept = function ( def, data)
        return def == oregonTrigger
    end,
    amount = 1
}

local oregonBoon = define_boon {
    id = 4,
    name = "Oregon",
    desc = "Gives a draft of an oregon",
    texture = "oregon.png",
    rarity = rarities.common,
    synergies = { boons.rabbits_foot, boons.chonken, boons.zoo, triggers.chicken, triggers.whale, triggers.pizza, triggers.chicken},
    one_shot = true,
    on_place = function(e)
        if not e.continuing then
              e.api.push_trigger_draft { can_reroll = false, draft = oregonDraft, from = e.self.def, }
        end
    end
}