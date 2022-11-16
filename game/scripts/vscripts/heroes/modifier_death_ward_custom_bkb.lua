modifier_death_ward_custom_bkb = class({})

function modifier_death_ward_custom_bkb:IsHidden() return true end
function modifier_death_ward_custom_bkb:IsPurgable() return false end
function modifier_death_ward_custom_bkb:IsPurgeException() return false end
--function modifier_death_ward_custom_bkb:OnCreated()
--	if not IsServer() then return end
--	self:StartIntervalThink(FrameTime())
--end
--function modifier_death_ward_custom_bkb:OnIntervalThink()
--	if not IsServer() then return end
--
--    if self:GetParent():GetAggroTarget() == nil then
--        local nearby_enemy_units = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil,  self:GetParent():Script_GetAttackRange(),  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
--        if nearby_enemy_units[1] then
--        	self:GetParent():SetAggroTarget(nearby_enemy_units[1])
--        	self:GetParent():MoveToTargetToAttack(nearby_enemy_units[1])
--        end
--        return
--    end
--
--    local distance = (self:GetParent():GetAbsOrigin() - self:GetParent():GetAggroTarget()):Length2D()
--
--    if self:GetParent():GetAggroTarget():IsAlive() and distance <= self:GetParent():Script_GetAttackRange() then
--    	self:GetParent():SetAggroTarget(self:GetParent():GetAggroTarget())
--        self:GetParent():MoveToTargetToAttack(self:GetParent():GetAggroTarget())
--    else
--    	self:GetParent():SetAggroTarget(nil)
--        self:GetParent():MoveToTargetToAttack(nil)
--    end
--end