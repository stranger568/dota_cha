modifier_skill_gambler = class({})

function modifier_skill_gambler:IsHidden() return true end
function modifier_skill_gambler:IsPurgable() return false end
function modifier_skill_gambler:IsPurgeException() return false end
function modifier_skill_gambler:RemoveOnDeath() return false end
function modifier_skill_gambler:AllowIllusionDuplicate() return true end