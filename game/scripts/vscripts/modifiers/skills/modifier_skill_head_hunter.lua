modifier_skill_head_hunter = class({})

function modifier_skill_head_hunter:IsHidden() return true end
function modifier_skill_head_hunter:IsPurgable() return false end
function modifier_skill_head_hunter:IsPurgeException() return false end
function modifier_skill_head_hunter:RemoveOnDeath() return false end
function modifier_skill_head_hunter:AllowIllusionDuplicate() return true end