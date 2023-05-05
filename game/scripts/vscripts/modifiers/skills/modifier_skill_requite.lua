modifier_skill_requite = class({})

function modifier_skill_requite:IsHidden() return true end
function modifier_skill_requite:IsPurgable() return false end
function modifier_skill_requite:IsPurgeException() return false end
function modifier_skill_requite:RemoveOnDeath() return false end
function modifier_skill_requite:AllowIllusionDuplicate() return true end

function modifier_skill_requite:AttackLandedModifier(params)
    if not IsServer() then return end
    if self:GetParent() == params.attacker then return end
    if self:GetParent() ~= params.target then return end
    if params.target:IsBuilding() then return end
    if self:GetParent():PassivesDisabled() then return end
    local damage = (self:GetParent():GetAverageTrueAttackDamage(nil) / 100 * 15) + (self:GetParent():GetStrength() * 0.5)
    if params.inflictor == nil and not self:GetParent():IsIllusion() and not self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) and not self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS ) then 
    	ApplyDamage({ victim = params.attacker, damage = damage, damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION, attacker = self:GetParent(), ability = nil})
    end
end

function modifier_skill_requite:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end