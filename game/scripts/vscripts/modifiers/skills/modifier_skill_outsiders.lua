modifier_skill_outsiders = class({})

function modifier_skill_outsiders:IsHidden() return true end
function modifier_skill_outsiders:IsPurgable() return false end
function modifier_skill_outsiders:IsPurgeException() return false end
function modifier_skill_outsiders:RemoveOnDeath() return false end
function modifier_skill_outsiders:AllowIllusionDuplicate() return true end