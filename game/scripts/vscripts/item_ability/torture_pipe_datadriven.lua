function ToggleTorturePipe(keys)
    local hCaster = keys.caster
    local hAbility = keys.ability
    if hCaster:HasModifier("modifier_torture_pipe_2_datadriven") then
        local hAbility = hCaster:FindModifierByName("modifier_torture_pipe_2_datadriven"):GetAbility()
        if hCaster:HasModifier("modifier_skill_overbuffed") then
            hCaster.flDotSP = hAbility:GetSpecialValueFor("dot_amplify") + 0.25
        else
            hCaster.flDotSP = hAbility:GetSpecialValueFor("dot_amplify")
        end
    elseif hCaster:HasModifier("modifier_torture_pipe_1_datadriven") then
        local hAbility = hCaster:FindModifierByName("modifier_torture_pipe_1_datadriven"):GetAbility()
        if hCaster:HasModifier("modifier_skill_overbuffed") then
            hCaster.flDotSP = hAbility:GetSpecialValueFor("dot_amplify") + 0.25
        else
            hCaster.flDotSP = hAbility:GetSpecialValueFor("dot_amplify")
        end
    else
        hCaster.flDotSP = nil
    end

    if hCaster.flDotSP ~= nil then
        --print(hCaster:GetUnitName() .. "'flDotSP: " .. hCaster.flDotSP)
    else
        --print(hCaster:GetUnitName() .. "'flDotSP is nil")
    end
end