modifier_skill_benefiter = class({})

function modifier_skill_benefiter:IsHidden() return true end
function modifier_skill_benefiter:IsPurgable() return false end
function modifier_skill_benefiter:IsPurgeException() return false end
function modifier_skill_benefiter:RemoveOnDeath() return false end
function modifier_skill_benefiter:AllowIllusionDuplicate() return true end