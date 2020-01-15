------------------------------------------------------------------
-- Modules
------------------------------------------------------------------

---@class ECS
ECS = {...}

---@type Config
local Config = ECSLoader:ImportModule("Config")
---@type Stats
local Stats = ECSLoader:ImportModule("Stats")
---@type Profile
local Profile = ECSLoader:ImportModule("Profile")

------------------------------------------------------------------

local _InitAddon, _InitGUI -- forward declaration

-- Configure ADDON_LOADED event frame
local loadingFrame = CreateFrame("Frame", nil, UIParent)
loadingFrame:RegisterEvent("ADDON_LOADED") -- Triggers whenever all non-lod addons has been loaded, this will initialize the addon
loadingFrame:RegisterEvent("PLAYER_LOGIN") -- Triggers whenever the player has logged in and all addons are loaded

loadingFrame:SetScript("OnEvent", function(self, event, arg1, ...)

    if event == "ADDON_LOADED" and arg1 == "ExtendedCharacterStats" then
        _InitAddon()
    end

    if event == "PLAYER_LOGIN" then
        _InitGUI()
    end
end)

ECS.loadingFrame = loadingFrame

_InitAddon = function()
    if ExtendedCharacterStats == nil then
        ExtendedCharacterStats = {}
    elseif ExtendedCharacterStats.v21reset == nil then
        -- Reset the settings for the update to v2.1.0
        ExtendedCharacterStats = {}
        ExtendedCharacterStats.v21reset = true
    end

    if ExtendedCharacterStats.profile == nil then
        ---@class ECSProfile
        ExtendedCharacterStats.profile = Profile:GetProfileData()
    end

    ExtendedCharacterStats.windowSize = {
        height = 425,
        width = 225,
        xOffset = 200,
        yOffset = 30
    }
end

_InitGUI = function ()
    -- Initialize the AddOn GUI once everything has loaded
    Stats:CreateWindow()

    -- Configure Update Event Frame for updating the UI
    local eventFrame = CreateFrame("Frame", nil, UIParent)

    -- Subscribe to events that will trigger an update
    eventFrame:RegisterEvent("UNIT_AURA") -- Triggers whenever the player gains or loses a buff/debuff
    eventFrame:RegisterEvent("PLAYER_LEVEL_UP") -- Triggers whenever the player levels up
    eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")  -- Triggers whenever the player log in, zone in to a new zone or reloads the UI
    eventFrame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED") -- Triggers whenever the player changes gear
    eventFrame:RegisterEvent("UNIT_POWER_UPDATE") -- Triggers whenever the player changes gear
    eventFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM") -- Triggers whenever the player changes gear

    -- Event handler for all the subscribed events
    -- Calls the update functions to update all the relevant stats
    eventFrame:SetScript("OnEvent", function(self, event, ...)
        C_Timer.After(0.5, function ()
            Stats:UpdateInformation()
        end)
    end)

    ECS.eventFrame = eventFrame
end

local function _HandleSlash(msg)
    local cmd = string.lower(msg) or "help"

    if cmd == "toggle" then
        Stats:ToggleWindow()
    elseif cmd == "config" then
        Config:ToggleWindow()
    else
        print("Available Commmands")
        print("/ecs toggle - Toggles the visibility of the stats window")
        print("/ecs config - Opens up the configuration window")
    end
end

-- Slash Command for toggling the display
SLASH_ECS1 = "/ecs"
SlashCmdList["ECS"] = _HandleSlash