modifier_skill_eternalist = class({})

function modifier_skill_eternalist:IsHidden() return true end
function modifier_skill_eternalist:IsPurgable() return false end
function modifier_skill_eternalist:IsPurgeException() return false end
function modifier_skill_eternalist:RemoveOnDeath() return false end
function modifier_skill_eternalist:AllowIllusionDuplicate() return true end