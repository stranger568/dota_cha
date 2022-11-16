test_kill_one = class({})

function test_kill_one:OnSpellStart()
      
    if IsServer() then
    	local hTarget =  self:GetCursorTarget()
		ApplyDamage({
			victim 			= hTarget,
			damage 			= hTarget:GetMaxHealth()*10,
			damage_type		= DAMAGE_TYPE_PURE,
			damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
			attacker 		= self:GetCaster(),
			ability 		= self
		})
    end

end
