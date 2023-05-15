modifier_duel_curse = class({})

function modifier_duel_curse:IsHidden() return true end
function modifier_duel_curse:IsDebuff() return false end
function modifier_duel_curse:IsPurgable() return false end
function modifier_duel_curse:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_duel_curse:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
end

function modifier_duel_curse:OnIntervalThink()
    if not IsServer() then return end
    local hp = self:GetParent():GetHealth()
    local max_hp = self:GetParent():GetMaxHealth()
    local new_hp = hp - max_hp * 0.005

    if new_hp < 2 then
        self:GetParent():Kill(nil, self:GetParent())
    else
        self:GetParent():SetHealth(new_hp)
    end

    if self:GetCaster():HasModifier("modifier_duel_curse") then
        self:Destroy()
    end
end

function modifier_duel_curse:DeclareFunctions()
    local funcs = 
    {
    	MODIFIER_PROPERTY_DISABLE_HEALING,
	}
	return funcs
end

function modifier_duel_curse:GetDisableHealing()
    return 1
end

function modifier_duel_curse:OnDestroy()
    if not IsServer() then return end
    self:GetParent():RemoveModifierByName("modifier_duel_curse_cooldown")
end

modifier_duel_curse_cooldown = class({})

function modifier_duel_curse_cooldown:IsHidden() return true end
function modifier_duel_curse_cooldown:IsDebuff() return false end
function modifier_duel_curse_cooldown:IsPurgable() return false end
function modifier_duel_curse_cooldown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_duel_curse_cooldown:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.01)
    local skeleton_king_reincarnation = self:GetParent():FindAbilityByName("skeleton_king_reincarnation")
    if skeleton_king_reincarnation then
        skeleton_king_reincarnation:SetActivated(false)
    end
    local phoenix_supernova = self:GetParent():FindAbilityByName("phoenix_supernova")
    if phoenix_supernova then
        phoenix_supernova:SetActivated(false)
    end
    local weaver_time_lapse = self:GetParent():FindAbilityByName("weaver_time_lapse")
    if weaver_time_lapse then
        weaver_time_lapse:SetActivated(false)
    end
    local oracle_false_promise_custom = self:GetParent():FindAbilityByName("oracle_false_promise_custom")
    if oracle_false_promise_custom then
        oracle_false_promise_custom:SetActivated(false)
    end
    local dazzle_shallow_grave = self:GetParent():FindAbilityByName("dazzle_shallow_grave")
    if dazzle_shallow_grave then
        dazzle_shallow_grave:SetActivated(false)
    end
    local troll_warlord_battle_trance = self:GetParent():FindAbilityByName("troll_warlord_battle_trance")
    if troll_warlord_battle_trance then
        troll_warlord_battle_trance:SetActivated(false)
    end
end

function modifier_duel_curse_cooldown:OnDestroy()
    if not IsServer() then return end
    local skeleton_king_reincarnation = self:GetParent():FindAbilityByName("skeleton_king_reincarnation")
    if skeleton_king_reincarnation then
        skeleton_king_reincarnation:SetActivated(true)
    end
    local phoenix_supernova = self:GetParent():FindAbilityByName("phoenix_supernova")
    if phoenix_supernova then
        phoenix_supernova:SetActivated(true)
    end
    local weaver_time_lapse = self:GetParent():FindAbilityByName("weaver_time_lapse")
    if weaver_time_lapse then
        weaver_time_lapse:SetActivated(true)
    end
    local oracle_false_promise_custom = self:GetParent():FindAbilityByName("oracle_false_promise_custom")
    if oracle_false_promise_custom then
        oracle_false_promise_custom:SetActivated(true)
    end
    local dazzle_shallow_grave = self:GetParent():FindAbilityByName("dazzle_shallow_grave")
    if dazzle_shallow_grave then
        dazzle_shallow_grave:SetActivated(true)
    end
    local troll_warlord_battle_trance = self:GetParent():FindAbilityByName("troll_warlord_battle_trance")
    if troll_warlord_battle_trance then
        troll_warlord_battle_trance:SetActivated(true)
    end
end

function modifier_duel_curse_cooldown:OnIntervalThink()
    if not IsServer() then return end
    local skeleton_king_reincarnation = self:GetParent():FindAbilityByName("skeleton_king_reincarnation")
    if skeleton_king_reincarnation then
        if skeleton_king_reincarnation:IsCooldownReady() then
            skeleton_king_reincarnation:StartCooldown(10)
        end
    end
end