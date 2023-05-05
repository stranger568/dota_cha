modifier_skill_block_shield = class({})

function modifier_skill_block_shield:IsHidden() return true end
function modifier_skill_block_shield:IsPurgable() return false end
function modifier_skill_block_shield:IsPurgeException() return false end
function modifier_skill_block_shield:RemoveOnDeath() return false end
function modifier_skill_block_shield:AllowIllusionDuplicate() return true end

function modifier_skill_block_shield:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end

function modifier_skill_block_shield:GetModifierIncomingDamage_Percentage(params)
    return -25
end

function modifier_skill_block_shield:FlagExist(a,b)--Bitwise Exist
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end