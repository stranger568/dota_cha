modifier_skill_highroller = class({})

function modifier_skill_highroller:IsHidden() return true end
function modifier_skill_highroller:IsPurgable() return false end
function modifier_skill_highroller:IsPurgeException() return false end
function modifier_skill_highroller:RemoveOnDeath() return false end
function modifier_skill_highroller:AllowIllusionDuplicate() return true end