if Illusion == nil then Illusion = class({}) end

function Illusion:Init()
    Illusion.abilityException = {}
    Illusion.abilityException["monkey_king_wukongs_command"] = true
    Illusion.juxtaposeException = {}
    Illusion.juxtaposeException["drow_ranger_marksmanship_custom"] = true
    Illusion.juxtaposeException["medusa_split_shot"] = true
    Illusion.juxtaposeException["luna_moon_glaive"] = true
    Illusion.juxtaposeException["abaddon_frostmourne"] = true
end

function Illusion:InitIllusion(hIllusion)
    if not hIllusion or hIllusion:IsNull() then return end
    local hIllustionModifier = hIllusion:FindModifierByName("modifier_illusion")
    if not hIllustionModifier then return end
    local hOriginalHero = hIllustionModifier:GetCaster()
    if not hOriginalHero then return end
    
    for i=0, 24 do
        local hAbility = hIllusion:GetAbilityByIndex(i)
        if hAbility and not string.find(hAbility:GetAbilityName(), "special_bonus") then
            hIllusion:RemoveAbility(hAbility:GetAbilityName())
        end
    end

    for i=0, 24 do
        local hOriginalHeroAbility = hOriginalHero:GetAbilityByIndex(i)
        if hOriginalHeroAbility and hOriginalHeroAbility.GetAbilityName then
            local sOriginalAbilityName = hOriginalHeroAbility:GetAbilityName()
            if not string.find(sOriginalAbilityName, "special_bonus") and not Illusion.abilityException[sOriginalAbilityName] then
                if not (hIllusion:HasModifier("modifier_phantom_lancer_juxtapose_illusion") and Illusion.juxtaposeException[sOriginalAbilityName]) then
                    local hNewAbility=hIllusion:AddAbility(sOriginalAbilityName)
                    local nLevel = hOriginalHeroAbility:GetLevel()  
                    if hNewAbility and not hNewAbility:IsNull() then
                        hNewAbility:SetHidden(hOriginalHeroAbility:IsHidden())
                        hNewAbility:ClearInnateModifiers()
                        if nLevel>0 then
                            hNewAbility:SetLevel(nLevel)
                        end
                    end
                end
            end
    
            if hIllusion:HasModifier("modifier_phantom_lancer_juxtapose_illusion") then
                hIllusion:RemoveModifierByName('modifier_dragon_knight_splash_attack')
            end
            if hIllusion:HasModifier("modifier_abaddon_frostmourne") then
                hIllusion:RemoveModifierByName('modifier_abaddon_frostmourne')
            end
        end
    end

    hIllusion.bTreeTempGrab=false
end