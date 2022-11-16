modifier_pumpkin_king_passive = class({})

function modifier_pumpkin_king_passive:IsHidden()
	return true
end

function modifier_pumpkin_king_passive:IsDebuff()
	return true
end

function modifier_pumpkin_king_passive:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end


function modifier_pumpkin_king_passive:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end

function modifier_pumpkin_king_passive:GetMinHealth()
	return 1000
end
