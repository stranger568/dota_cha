modifier_skill_merchant = class({})

function modifier_skill_merchant:IsHidden() return true end
function modifier_skill_merchant:IsPurgable() return false end
function modifier_skill_merchant:IsPurgeException() return false end
function modifier_skill_merchant:RemoveOnDeath() return false end
function modifier_skill_merchant:AllowIllusionDuplicate() return true end