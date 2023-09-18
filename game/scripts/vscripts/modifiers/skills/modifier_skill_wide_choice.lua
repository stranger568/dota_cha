modifier_skill_wide_choice = class({})
function modifier_skill_wide_choice:IsHidden() return true end
function modifier_skill_wide_choice:IsPurgable() return false end
function modifier_skill_wide_choice:IsPurgeException() return false end
function modifier_skill_wide_choice:RemoveOnDeath() return false end
function modifier_skill_wide_choice:AllowIllusionDuplicate() return true end