item_extra_creature_explode_spider = class({})


function item_extra_creature_explode_spider:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hPlayer =  hCaster:GetPlayerOwner()
		if hCaster and hCaster:IsRealHero() and not hCaster:IsTempestDouble() and not hCaster:HasModifier("modifier_arc_warden_tempest_double_lua")  then          
	       if hPlayer then
            if hCaster:HasModifier("modifier_skill_zoo_enjoyer") and self:GetCost() >= 10000 then
                if RollPercentage(20) then
                    ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_explode_spider")
                end
            end
            local modifier_cashback_creep_count = hCaster:FindModifierByName("modifier_cashback_creep_count")
if modifier_cashback_creep_count then
    modifier_cashback_creep_count:Upgrade(self:GetCost())
end
	       	   ExtraCreature:AddExtraCreature(hPlayer:GetPlayerID(),"npc_dota_explode_spider")
	       	   self:SpendCharge()
	       end
		end
	end
end

