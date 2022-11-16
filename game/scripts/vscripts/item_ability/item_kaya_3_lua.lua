item_kaya_3_lua = class({})
LinkLuaModifier( "modifier_item_kaya_3_lua", "item_ability/item_kaya_3_lua", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function item_kaya_3_lua:GetIntrinsicModifierName()
  return "modifier_item_kaya_3_lua"
end

modifier_item_kaya_3_lua = class({})

function modifier_item_kaya_3_lua:IsHidden()
	return true
end

function modifier_item_kaya_3_lua:IsPurgable()
	return false
end

function modifier_item_kaya_3_lua:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end


function modifier_item_kaya_3_lua:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE
	}
	return funcs
end


function modifier_item_kaya_3_lua:OnCreated()
	  if IsServer() then    
       if self:IsNull() then 
       	  return
       end
       local hCaster = self:GetParent()
       if (not hCaster) or hCaster:IsNull() then
       	  return
       end	     
	     if hCaster:HasModifier("modifier_item_kaya_3_lua") then
	        local hAbility = hCaster:FindModifierByName("modifier_item_kaya_3_lua"):GetAbility()
	        hCaster.flSP = hAbility:GetSpecialValueFor("spell_amplify")
	     elseif hCaster:HasModifier("modifier_item_kaya_2_lua") then
	        local hAbility = hCaster:FindModifierByName("modifier_item_kaya_2_lua"):GetAbility()
	        hCaster.flSP = hAbility:GetSpecialValueFor("spell_amplify")
	     else
	        hCaster.flSP = nil
	     end
    end
end


function modifier_item_kaya_3_lua:OnDestroy()
	  if IsServer() then    
       if self:IsNull() then 
       	  return
       end
       local hCaster = self:GetParent()
       if (not hCaster) or hCaster:IsNull() then
       	  return
       end	     
	     if hCaster:HasModifier("modifier_item_kaya_3_lua") then
	        local hAbility = hCaster:FindModifierByName("modifier_item_kaya_3_lua"):GetAbility()
	        hCaster.flSP = hAbility:GetSpecialValueFor("spell_amplify")
	     elseif hCaster:HasModifier("modifier_item_kaya_2_lua") then
	        local hAbility = hCaster:FindModifierByName("modifier_item_kaya_2_lua"):GetAbility()
	        hCaster.flSP = hAbility:GetSpecialValueFor("spell_amplify")
	     else
	        hCaster.flSP = nil
	     end
    end
end

function modifier_item_kaya_3_lua:GetModifierMPRegenAmplify_Percentage(params)
	return self:GetAbility():GetSpecialValueFor("mana_regen_multiplier")
end

function modifier_item_kaya_3_lua:GetModifierBonusStats_Intellect(params)
	return self:GetAbility():GetSpecialValueFor("bonus_int")
end

function modifier_item_kaya_3_lua:GetModifierPercentageManacost(params)
	return self:GetAbility():GetSpecialValueFor("manacost_reduction")
end