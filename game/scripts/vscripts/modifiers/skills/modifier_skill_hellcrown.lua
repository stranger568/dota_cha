modifier_skill_hellcrown = class({})

function modifier_skill_hellcrown:IsHidden() return true end
function modifier_skill_hellcrown:IsPurgable() return false end
function modifier_skill_hellcrown:IsPurgeException() return false end
function modifier_skill_hellcrown:RemoveOnDeath() return false end
function modifier_skill_hellcrown:AllowIllusionDuplicate() return true end