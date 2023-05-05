modifier_skill_zoo_enjoyer = class({})

function modifier_skill_zoo_enjoyer:IsHidden() return true end
function modifier_skill_zoo_enjoyer:IsPurgable() return false end
function modifier_skill_zoo_enjoyer:IsPurgeException() return false end
function modifier_skill_zoo_enjoyer:RemoveOnDeath() return false end
function modifier_skill_zoo_enjoyer:AllowIllusionDuplicate() return true end