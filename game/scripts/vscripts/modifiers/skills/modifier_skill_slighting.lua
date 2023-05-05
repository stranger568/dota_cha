modifier_skill_slighting = class({})

function modifier_skill_slighting:IsHidden() return true end
function modifier_skill_slighting:IsPurgable() return false end
function modifier_skill_slighting:IsPurgeException() return false end
function modifier_skill_slighting:RemoveOnDeath() return false end
function modifier_skill_slighting:AllowIllusionDuplicate() return true end

function modifier_skill_slighting:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_skill_slighting:GetModifierTotal_ConstantBlock(kv)
    if not IsServer() then return end
    if self:FlagExist( kv.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) then return end
    return 120
end

function modifier_skill_slighting:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end

