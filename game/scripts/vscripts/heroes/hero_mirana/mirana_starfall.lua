function ScepterStarfall( keys )
	local caster = keys.caster
	local ability = keys.ability

	if not ability then return end

	-- is this an illusion?
	if caster:IsIllusion() then
		-- Remove thinker
		caster:RemoveModifierByName('modifier_mirana_starfall_scepter_thinker')

		return
	end

	-- Check if we actually have scepter
	if caster:HasScepter() and not caster:IsInvisible() then
		ability:OnSpellStart()
	end
end
