modifier_gaben_int_fixed = class({})
function modifier_gaben_int_fixed:IsHidden() return true end
function modifier_gaben_int_fixed:IsDebuff() return false end
function modifier_gaben_int_fixed:IsPurgable() return false end
function modifier_gaben_int_fixed:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_gaben_int_fixed:OnCreated()
	if not IsServer() then return end
	self:GetParent():SetDayTimeVisionRange(2500)
	self:GetParent():SetNightTimeVisionRange(2500)
end

function modifier_gaben_int_fixed:DeclareFunctions()
    local funcs = 
    {
    	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
	}
	return funcs
end

function modifier_gaben_int_fixed:GetModifierMagicalResistanceDirectModification()
    return (self:GetParent():GetIntellect() * 0.1) * -1
end

function modifier_gaben_int_fixed:CheckState()
	return
	{
		[MODIFIER_STATE_FORCED_FLYING_VISION] = true,
	}
end