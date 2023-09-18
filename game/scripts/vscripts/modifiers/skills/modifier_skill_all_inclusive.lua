LinkLuaModifier("modifier_aegis", "heroes/modifier_aegis", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_dark_moon_shard", "item_ability/modifier/modifier_item_dark_moon_shard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_item_gem_shard", "items/item_gem_shard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_item_essence_of_speed", "items/item_essence_of_speed", LUA_MODIFIER_MOTION_NONE)

modifier_skill_all_inclusive = class({})
function modifier_skill_all_inclusive:IsHidden() return true end
function modifier_skill_all_inclusive:IsPurgable() return false end
function modifier_skill_all_inclusive:IsPurgeException() return false end
function modifier_skill_all_inclusive:RemoveOnDeath() return false end
function modifier_skill_all_inclusive:AllowIllusionDuplicate() return true end
function modifier_skill_all_inclusive:OnCreated()
    if not IsServer() then return end

    if self:GetParent():HasModifier("modifier_aegis") then
        local hModifierAegis = self:GetParent():FindModifierByName("modifier_aegis")
        local nCurrentStack = hModifierAegis:GetStackCount()
        hModifierAegis:SetStackCount(nCurrentStack+1)
        CustomNetTables:SetTableValue("aegis_count", tostring(self:GetParent():GetPlayerOwnerID()), {count = nCurrentStack+1})
    else
        local hModifierAegis = self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_aegis", {})
        hModifierAegis:SetStackCount(1)
        CustomNetTables:SetTableValue("aegis_count", tostring(self:GetParent():GetPlayerOwnerID()), {count = 1})
    end

    if not self:GetParent():HasModifier("modifier_item_moon_shard_consumed") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_moon_shard_consumed", {})
    else
        self:GetParent():ModifyGold(1400, true, 0)
    end

    if not self:GetParent():HasModifier("modifier_item_ultimate_scepter_consumed") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_ultimate_scepter_consumed", {})
    else
        self:GetParent():ModifyGold(5800, true, 0)
    end

    if not self:GetParent():HasModifier("modifier_item_aghanims_shard") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_aghanims_shard", {})
    else
        self:GetParent():ModifyGold(4000, true, 0)
    end

    if not self:GetParent():HasModifier("modifier_item_dark_moon_shard") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_dark_moon_shard", {})
    else
        self:GetParent():ModifyGold(8000, true, 0)
    end

    if not self:GetParent():HasModifier("modifier_item_gem_shard") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_gem_shard", {})
    else
        self:GetParent():ModifyGold(5000, true, 0)
    end

    if not self:GetParent():HasModifier("modifier_item_essence_of_speed") then
        self:GetParent():AddNewModifier(self:GetParent(), nil, "modifier_item_essence_of_speed", {})
    else
        self:GetParent():ModifyGold(3500, true, 0)
    end
end