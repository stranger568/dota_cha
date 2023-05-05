modifier_skill_smoker = class({})

function modifier_skill_smoker:IsHidden() return true end
function modifier_skill_smoker:IsPurgable() return false end
function modifier_skill_smoker:IsPurgeException() return false end
function modifier_skill_smoker:RemoveOnDeath() return false end
function modifier_skill_smoker:AllowIllusionDuplicate() return true end
