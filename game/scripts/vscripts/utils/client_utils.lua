-- Has Aghanim's Shard
function C_DOTA_BaseNPC:HasShard()
	 return self:HasModifier("modifier_item_aghanims_shard")
end

function C_DOTA_BaseNPC:HasTalent(talent_name)
    if not self or self:IsNull() then return end

    local talent = self:FindAbilityByName(talent_name)
    if talent and talent:GetLevel() > 0 then return true end
end

function C_DOTA_BaseNPC:FindTalentValue(talent_name, key)
    if self:HasTalent(talent_name) then
        local value_name = key or "value"
        return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
    end
    return 0
end

function C_DOTA_BaseNPC:IsDueling()
	return self:HasModifier("modifier_hero_dueling")
end