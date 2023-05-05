modifier_skill_true_strike = class({})

function modifier_skill_true_strike:IsHidden() return true end
function modifier_skill_true_strike:IsPurgable() return false end
function modifier_skill_true_strike:IsPurgeException() return false end
function modifier_skill_true_strike:RemoveOnDeath() return false end
function modifier_skill_true_strike:AllowIllusionDuplicate() return true end

function modifier_skill_true_strike:OnCreated()
	if not IsServer() then return end
	self.critProc = false
end

function modifier_skill_true_strike:CheckState()
	local state = {}
	if IsServer() then
		state[MODIFIER_STATE_CANNOT_MISS] = self.critProc
	end
	return state
end

function modifier_skill_true_strike:DeclareFunctions()
	return 
	{
        MODIFIER_EVENT_ON_ATTACK_START
	}
end

function modifier_skill_true_strike:OnAttackStart(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.target:IsWard() then return end
	if RollPercentage( 80 ) then
		self.critProc = true
	else
		self.critProc = false
	end
end