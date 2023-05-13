modifier_cha_stranger = class({})

function modifier_cha_stranger:GetTexture()
	return "stranger"
end


function modifier_cha_stranger:IsHidden()
	return false
end

function modifier_cha_stranger:IsDebuff()
	return true
end

function modifier_cha_stranger:IsPurgable()
	return false
end

function modifier_cha_stranger:IsPermanent()
	return true
end