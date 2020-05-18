---@class DataUtils
local DataUtils = ECSLoader:CreateModule("DataUtils")

--- Rounds every number down to the given decimal places
function DataUtils:Round(num, decimalPlaces)
    if not num then
        return 0
    end
    local mult = 10^(decimalPlaces)
    return math.floor(num * mult + 0.5) / mult
end

function DataUtils:IsShapeshifted()
    for i = 0, 40 do
        local _, _, _, _, _, _, _, _, _, spellId, _ = UnitAura("player", i, "HELPFUL", "PLAYER")
        if spellId == 5487 or spellId == 9634 or spellId == 768 then
            return true
        end
    end
    return false
end

function DataUtils:GetMissChanceByDifference(weaponSkill, defenseValue)
    if (defenseValue - weaponSkill) <= 10 then
        return 5 + (defenseValue - weaponSkill) * 0.1
    else
        return 7 + (defenseValue - weaponSkill - 10) * 0.4
    end
end