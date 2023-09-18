modifier_skill_pilferer = class({})

function modifier_skill_pilferer:IsHidden() return true end
function modifier_skill_pilferer:IsPurgable() return false end
function modifier_skill_pilferer:IsPurgeException() return false end
function modifier_skill_pilferer:RemoveOnDeath() return false end
function modifier_skill_pilferer:AllowIllusionDuplicate() return true end