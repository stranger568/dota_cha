LinkLuaModifier("modifier_skill_linkens_sphere_cooldown", "modifiers/skills/modifier_skill_linkens_sphere", LUA_MODIFIER_MOTION_NONE)

modifier_skill_linkens_sphere = class({})

function modifier_skill_linkens_sphere:IsHidden() return true end
function modifier_skill_linkens_sphere:IsPurgable() return false end
function modifier_skill_linkens_sphere:IsPurgeException() return false end
function modifier_skill_linkens_sphere:RemoveOnDeath() return false end
function modifier_skill_linkens_sphere:AllowIllusionDuplicate() return true end

function modifier_skill_linkens_sphere:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSORB_SPELL,
	}
	return funcs
end

function modifier_skill_linkens_sphere:GetAbsorbSpell( params )
	if not IsServer() then return end
	if self:GetParent():IsIllusion() then return end
	if self:GetParent():HasModifier("modifier_skill_linkens_sphere_cooldown") then return end
	if params.ability:GetCaster():GetTeamNumber() == self:GetParent():GetTeamNumber() then
    	return nil
    end
    self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_skill_linkens_sphere_cooldown", {duration = 9})
	self:GetParent():EmitSound("DOTA_Item.LinkensSphere.Activate")
	local particle = ParticleManager:CreateParticle("particles/items_fx/immunity_sphere.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:SetParticleControlEnt(particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(particle)
	return 1
end


modifier_skill_linkens_sphere_cooldown = class({})
function modifier_skill_linkens_sphere_cooldown:GetTexture() return "modifier_skill_linkens_sphere" end
function modifier_skill_linkens_sphere_cooldown:IsHidden() return false end
function modifier_skill_linkens_sphere_cooldown:IsDebuff() return true end
function modifier_skill_linkens_sphere_cooldown:IsPurgable() return false end
function modifier_skill_linkens_sphere_cooldown:IsPurgeException() return false end
function modifier_skill_linkens_sphere_cooldown:RemoveOnDeath() return false end
function modifier_skill_linkens_sphere_cooldown:AllowIllusionDuplicate() return true end