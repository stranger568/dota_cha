modifier_skill_overbuffed = class({})

function modifier_skill_overbuffed:IsHidden() return true end
function modifier_skill_overbuffed:IsPurgable() return false end
function modifier_skill_overbuffed:IsPurgeException() return false end
function modifier_skill_overbuffed:RemoveOnDeath() return false end
function modifier_skill_overbuffed:AllowIllusionDuplicate() return true end