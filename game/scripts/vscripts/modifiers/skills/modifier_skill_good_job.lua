modifier_skill_good_job = class({})

function modifier_skill_good_job:IsHidden() return true end
function modifier_skill_good_job:IsPurgable() return false end
function modifier_skill_good_job:IsPurgeException() return false end
function modifier_skill_good_job:RemoveOnDeath() return false end
function modifier_skill_good_job:AllowIllusionDuplicate() return true end