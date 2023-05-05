modifier_skill_cashback = class({})

function modifier_skill_cashback:IsHidden() return true end
function modifier_skill_cashback:IsPurgable() return false end
function modifier_skill_cashback:IsPurgeException() return false end
function modifier_skill_cashback:RemoveOnDeath() return false end
function modifier_skill_cashback:AllowIllusionDuplicate() return true end

modifier_skill_cashback_buff = class({})

modifier_skill_cashback_buff.cashback = 
{
	["npc_dota_kobold"] = 6000,
	["npc_dota_gnoll_assassin"] = 7000,
	["npc_dota_elf_wolf"] = 8000,
	["npc_dota_rock_golem"] = 8500,
	["npc_dota_timber_spider"] = 10000,
	["npc_dota_explode_spider"] = 10000,
	["npc_dota_satyr_trickster"] = 11000,
	["npc_dota_ghost"] = 11000,
	["npc_dota_warpine_cone_custom"] = 12000,
	["npc_dota_roshling_big"] = 15000,
	["npc_dota_siltbreaker_red"] = 15000,
	["npc_dota_centaur_khan"] = 15000,
	["npc_dota_dark_troll_warlord"] = 16000,
	["npc_dota_prowler_shaman"] = 16000,
	["npc_dota_big_thunder_lizard"] = 17000,
	["npc_dota_spider_range"] = 20000,
	["npc_dota_granite_golem"] = 17000,
}

function modifier_skill_cashback_buff:IsHidden() return true end
function modifier_skill_cashback_buff:IsPurgable() return false end

function modifier_skill_cashback_buff:OnDeathEvent(params)
	if not IsServer() then return end
	if params.attacker ~= self:GetParent() then return end
	if params.unit == self:GetParent() then return end
	if not params.unit:IsRealHero() then return end

	if params.unit:IsReincarnating() then
		if self.cashback[params.attacker:GetUnitName()] then
			self:GetCaster():ModifyGold(self.cashback[params.attacker:GetUnitName()] / 100 * 50, true, 0)
		end
	else
		if self.cashback[params.attacker:GetUnitName()] then
			self:GetCaster():ModifyGold(self.cashback[params.attacker:GetUnitName()] / 100 * 100, true, 0)
		end
	end
end