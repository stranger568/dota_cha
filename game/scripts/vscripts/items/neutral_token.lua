item_tier1_token_custom = class({})

function item_tier1_token_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster.neutral_select == true then print("lol") return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelect( caster, id, 1 )
            self:Destroy()
        end
    end
end

item_tier2_token_custom = class({})

function item_tier2_token_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster.neutral_select then return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelect( caster, id, 2 )
            self:Destroy()
        end
    end
end

item_tier3_token_custom = class({})

function item_tier3_token_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster.neutral_select then return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelect( caster, id, 3 )
            self:Destroy()
        end
    end
end

item_tier4_token_custom = class({})

function item_tier4_token_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster.neutral_select then return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelect( caster, id, 4 )
            self:Destroy()
        end
    end
end

item_tier5_token_custom = class({})

function item_tier5_token_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster.neutral_select then return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelect( caster, id, 5 )
            self:Destroy()
        end
    end
end

item_tier5_token_roshan_custom = class({})

function item_tier5_token_roshan_custom:OnSpellStart()
    local caster = self:GetCaster()
	local hPlayer = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if HeroBuilder.HasUseNeutralFiveTier[caster:GetPlayerOwnerID()] == false then return end
    if caster.neutral_select then return end
	if caster and caster:IsRealHero() and not caster:IsTempestDouble() and not caster:HasModifier("modifier_arc_warden_tempest_double_lua") then          
	    if hPlayer then
            caster.neutral_select = true
            HeroBuilder:NeutralItemSelectRoshan( caster, id, 5 )
            self:Destroy()
        end
    end
end