modifier_skill_hookah_master = class({})

function modifier_skill_hookah_master:IsHidden() return true end
function modifier_skill_hookah_master:IsPurgable() return false end
function modifier_skill_hookah_master:IsPurgeException() return false end
function modifier_skill_hookah_master:RemoveOnDeath() return false end
function modifier_skill_hookah_master:AllowIllusionDuplicate() return true end