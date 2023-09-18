modifier_skill_rake = class({})

function modifier_skill_rake:IsHidden() return true end
function modifier_skill_rake:IsPurgable() return false end
function modifier_skill_rake:IsPurgeException() return false end
function modifier_skill_rake:RemoveOnDeath() return false end
function modifier_skill_rake:AllowIllusionDuplicate() return true end