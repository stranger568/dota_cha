LinkLuaModifier("modifier_item_rapier_custom", "items/rapier", LUA_MODIFIER_MOTION_NONE)

item_rapier_custom = class({})

function item_rapier_custom:Spawn()
    if not IsServer() then return end
    local item = self
    if item and item.itembuydisabled == nil and item.timerscreated == nil then
        item.timerscreated = false
        Timers:CreateTimer(10, function()
            print("Айтем нельзя продать больше")
            if item and not item:IsNull() then
                item.itembuydisabled = false
                item:SetSellable(false)
            end
        end)
    end
end

function item_rapier_custom:OnOwnerDied(params)
    local hOwner = self:GetOwner()
    -- Non-heroes should automatically drop rapier and return so they can't crash script at hOwner:IsReincarnating() check
    if not hOwner:IsRealHero() then
        self:DropItem(self, true, true)
        return
    end
    
    if not hOwner:IsReincarnating() then
        self:DropItem(self, true, true)
    end
end

function item_rapier_custom:DropItem(hItem, sNewItemName, bLaunchLoot)
    local vLocation = GetGroundPosition(self:GetCaster():GetAbsOrigin(), self:GetCaster())
    local sName
    local vRandomVector = RandomVector(100)

    if hItem then
        sName = hItem:GetName()
        self:GetCaster():DropItemAtPositionImmediate(hItem, vLocation)
        --hItem:SetPurchaser(nil)
        --hItem:SetPurchaseTime(0)
        --hItem:SetDroppable(false)
    else
        sName = sNewItemName
        hItem = CreateItem(sNewItemName, nil, nil)
        CreateItemOnPositionSync(vLocation, hItem)
        hItem:SetPurchaser(nil)
        hItem:SetPurchaseTime(0)
        hItem:SetDroppable(false)
    end

    if bLaunchLoot then
        hItem:LaunchLoot(false, 250, 0.5, vLocation + vRandomVector)
    end
end

function item_rapier_custom:GetIntrinsicModifierName() return "modifier_item_rapier_custom" end

modifier_item_rapier_custom = class({})

function modifier_item_rapier_custom:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_item_rapier_custom:IsPurgable() return false end
function modifier_item_rapier_custom:IsHidden() return true end

function modifier_item_rapier_custom:OnCreated(args)
    if not IsServer() then return end
    self.truestrike = false
    self.critProc = false
end

function modifier_item_rapier_custom:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        --MODIFIER_EVENT_ON_ATTACK_RECORD,
        MODIFIER_EVENT_ON_DEATH
    }
end

function modifier_item_rapier_custom:OnAttackRecord(keys)
    if keys.attacker == self:GetParent() then
        if keys.target:IsOther() then
            return nil
        end
        self.chance = self:GetAbility():GetSpecialValueFor("truestrike_chance")
        if self.chance >= RandomInt(1, 100) then
            self.critProc = true
        end
    end
end

function modifier_item_rapier_custom:AttackLandedModifier(params)
    if params.attacker == self:GetParent() then
        if self.critProc then
            self.critProc = false
        end
    end
end

function modifier_item_rapier_custom:GetModifierPreAttack_BonusDamage()
    return self:GetAbility():GetSpecialValueFor("bonus_damage")
end

function modifier_item_rapier_custom:CheckState()
    local state = {}
    
    if self.critProc then
        state = {[MODIFIER_STATE_CANNOT_MISS] = true}
    end

    return state
end