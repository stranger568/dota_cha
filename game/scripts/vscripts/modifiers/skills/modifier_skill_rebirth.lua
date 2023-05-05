modifier_skill_rebirth = class({})

function modifier_skill_rebirth:IsHidden() return true end
function modifier_skill_rebirth:IsPurgable() return false end
function modifier_skill_rebirth:IsPurgeException() return false end
function modifier_skill_rebirth:RemoveOnDeath() return false end
function modifier_skill_rebirth:AllowIllusionDuplicate() return true end