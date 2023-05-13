LinkLuaModifier("modifier_rattletrap_battery_assault_custom", "abilities/rattletrap_battery_assault_custom", LUA_MODIFIER_MOTION_NONE)

rattletrap_battery_assault_custom = class({})

function rattletrap_battery_assault_custom:OnSpellStart()
	if not IsServer() then return end
	self:GetCaster():StartGesture(ACT_DOTA_RATTLETRAP_BATTERYASSAULT)
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_rattletrap_battery_assault_custom", {duration = self:GetSpecialValueFor("duration")})
end

modifier_rattletrap_battery_assault_custom = class({})

function modifier_rattletrap_battery_assault_custom:IsPurgable() return false end
function modifier_rattletrap_battery_assault_custom:IsPurgeException() return false end

function modifier_rattletrap_battery_assault_custom:OnCreated()
	self.radius	= self:GetAbility():GetSpecialValueFor("radius")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	if not IsServer() then return end
	self.damage = self:GetAbility():GetSpecialValueFor("damage")
	self.damage_type = self:GetAbility():GetAbilityDamageType()
	self:GetParent():EmitSound("Hero_Rattletrap.Battery_Assault")
	self:OnIntervalThink()
	self:StartIntervalThink(self.interval)
end

function modifier_rattletrap_battery_assault_custom:OnIntervalThink()
	if not IsServer() then return end
	self:GetParent():EmitSound("Hero_Rattletrap.Battery_Assault_Launch")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_assault.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	ParticleManager:ReleaseParticleIndex(particle)
	local particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
	
	if #enemies >= 1 then
		for _, enemy in pairs(enemies) do
			enemy:EmitSound("Hero_Rattletrap.Battery_Assault_Impact")
			ParticleManager:SetParticleControl(particle2, 1, enemy:GetAbsOrigin())
			local damageTable = 
			{
				victim = enemy,
				damage = self.damage,
				damage_type	= self.damage_type,
				damage_flags = DOTA_DAMAGE_FLAG_NONE,
				attacker = self:GetCaster(),
				ability = self:GetAbility()
			}
			ApplyDamage(damageTable)
			enemy:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 0.1 * (1 - enemy:GetStatusResistance())})
		end
	else
		ParticleManager:SetParticleControl(particle2, 1, self:GetParent():GetAbsOrigin() + RandomVector(RandomInt(0, 128)))
	end
	
	ParticleManager:ReleaseParticleIndex(particle)
	self:StartIntervalThink(self.interval)
end

function modifier_rattletrap_battery_assault_custom:OnDestroy()
	if not IsServer() then return end
	self:GetParent():StopSound("Hero_Rattletrap.Battery_Assault")
end
