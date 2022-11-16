--------------------------------------------------------------------------------
modifier_drow_ranger_marksmanship_lua_debuff = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_marksmanship_lua_debuff:IsHidden()
	return true
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsDebuff()
	return true
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsStunDebuff()
	return false
end

function modifier_drow_ranger_marksmanship_lua_debuff:IsPurgable()
	return false
end

function modifier_drow_ranger_marksmanship_lua_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_drow_ranger_marksmanship_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE, -- for base armor only
		-- MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR, -- for all armor
	}

	return funcs
end

function modifier_drow_ranger_marksmanship_lua_debuff:GetModifierPhysicalArmorBase_Percentage()
	-- strip base armor
	return 0
end

-- function modifier_drow_ranger_marksmanship_lua_debuff:GetModifierIgnorePhysicalArmor( params )
-- 	if not IsServer() then return end
-- 	-- strip all armor
-- 	return 1
-- end
