modifier_creature_spell_amplify = class({})


function modifier_creature_spell_amplify:GetTexture()
	return "ogre_magi_bloodlust"
end


function modifier_creature_spell_amplify:IsHidden()
	return true
end

function modifier_creature_spell_amplify:IsDebuff()
	return false
end

function modifier_creature_spell_amplify:IsPurgable()
	return false
end

function modifier_creature_spell_amplify:IsPermanent()
    return true
end


function modifier_creature_spell_amplify:OnCreated( kv )
	if IsServer() then
	end
end


function modifier_creature_spell_amplify:DeclareFunctions()
    local funcs = {
    	MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end


function modifier_creature_spell_amplify:GetModifierSpellAmplify_Percentage( params )
    return self:GetStackCount() *9
end
