modifier_creator_statue = class({})

function modifier_creator_statue:IsHidden() return true end
function modifier_creator_statue:IsPurgable() return false end
function modifier_creator_statue:IsPurgeException() return false end

function modifier_creator_statue:CheckState()
	return 
	{
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
end

function modifier_creator_statue:DeclareFunctions()
    local decFuncs = 
    {
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
    }
    return decFuncs
end

function modifier_creator_statue:GetModifierProvidesFOWVision()
  	return 1
end

function modifier_creator_statue:OnCreated(params)
	if not IsServer() then return end
	if params.id ~= nil then
		self.id = tonumber(params.id)
		self:GetParent().panel_wd = WorldPanels:CreateWorldPanelForAll({ layout = "file://{resources}/layout/custom_game/overlord/top_player.xml", entity = self:GetParent(), entityHeight = 200, data = {id = self.id}})
		self:StartIntervalThink(1)
	end
end

function modifier_creator_statue:OnIntervalThink()
	if not IsServer() then return end
	if self:GetParent().panel_wd ~= nil then
		self:GetParent().panel_wd:SetData({id = self.id})
	end
end