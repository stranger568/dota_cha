modifier_skill_spell_lifestealer = class({})

function modifier_skill_spell_lifestealer:IsHidden() return true end
function modifier_skill_spell_lifestealer:IsPurgable() return false end
function modifier_skill_spell_lifestealer:IsPurgeException() return false end
function modifier_skill_spell_lifestealer:RemoveOnDeath() return false end
function modifier_skill_spell_lifestealer:AllowIllusionDuplicate() return true end

function modifier_skill_spell_lifestealer:TakeDamageScriptModifier(params)
    if not IsServer() then return end
    if self:GetParent() ~= params.attacker then return end
    if self:GetParent() == params.unit then return end
    if params.unit:IsBuilding() then return end
    if params.inflictor == nil and not self:GetParent():IsIllusion() and not self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) then 
        local heal = 8 / 100 * params.damage
        self:GetParent():Heal(heal, nil)
    end
    if params.inflictor ~= nil and not self:GetParent():IsIllusion() and not self:FlagExist( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) then 
    	local bonus_percentage = 0
        for _, mod in pairs(self:GetParent():FindAllModifiers()) do
            if mod.GetModifierSpellLifestealRegenAmplify_Percentage and mod:GetModifierSpellLifestealRegenAmplify_Percentage() then
                bonus_percentage = bonus_percentage + mod:GetModifierSpellLifestealRegenAmplify_Percentage()
            end
        end    
        local heal = 18 / 100 * params.damage
        heal = heal * (bonus_percentage / 100 + 1)
        self:GetParent():Heal(heal, params.inflictor)
    end
end

function modifier_skill_spell_lifestealer:FlagExist(a,b)
	local p,c,d=1,0,b
	while a>0 and b>0 do
		local ra,rb=a%2,b%2
		if ra+rb>1 then c=c+p end
		a,b,p=(a-ra)/2,(b-rb)/2,p*2
	end
	return c==d
end