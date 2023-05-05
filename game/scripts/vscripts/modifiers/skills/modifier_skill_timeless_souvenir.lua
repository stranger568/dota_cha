modifier_skill_timeless_souvenir = class({})

function modifier_skill_timeless_souvenir:IsHidden() return true end
function modifier_skill_timeless_souvenir:IsPurgable() return false end
function modifier_skill_timeless_souvenir:IsPurgeException() return false end
function modifier_skill_timeless_souvenir:RemoveOnDeath() return false end
function modifier_skill_timeless_souvenir:AllowIllusionDuplicate() return true end

function modifier_skill_timeless_souvenir:DeclareFunctions()
	return
	{
		MODIFIER_EVENT_ON_MODIFIER_ADDED,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_skill_timeless_souvenir:OnModifierAdded(params)
	if not IsServer() then return end
	if params.unit == self:GetParent() then return end
	if params.added_buff:GetCaster() ~= self:GetParent() then return end
	if not params.added_buff:IsDebuff() then return end
	if params.added_buff:GetDuration() <= 0 then return end
	if params.added_buff:GetName() == "modifier_cyclone" then return end
	if params.added_buff:GetName() == "modifier_eul_cyclone" then return end
	if params.added_buff:GetName() == "modifier_eul_cyclone_thinker" then return end
	if params.added_buff:GetName() == "modifier_eul_wind_waker_thinker" then return end
	if params.added_buff:GetName() == "modifier_wind_waker" then return end
	if self:GetParent():HasModifier("modifier_item_timeless_relic") then return end
	local new_duration = params.added_buff:GetDuration() + (params.added_buff:GetDuration() / 100 * 25)
	params.added_buff:SetDuration(new_duration, true)
end

function modifier_skill_timeless_souvenir:GetModifierSpellAmplify_Percentage()
	if self:GetParent():HasModifier("modifier_item_timeless_relic") then return end
	return 15
end