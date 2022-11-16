test_kill_all_neutral = class({})

function test_kill_all_neutral:OnSpellStart()
      
    if IsServer() then
	    for _, hEnemy in pairs(FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0,0,0), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)) do               
			ApplyDamage({
				victim 			= hEnemy,
				damage 			= hEnemy:GetMaxHealth()*10,
				damage_type		= DAMAGE_TYPE_PURE,
				damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
				attacker 		= self:GetCaster(),
				ability 		= self
			})
		end
    end

end
