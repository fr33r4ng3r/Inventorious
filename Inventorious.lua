Inventorious = Inventorious or {}
Inventorious.name = "Inventorious"

-- imports

local AccountHoldings = Inventorious.imports.AccountHoldings

-- locals

local initialized = false
local bagList
local holdings

local function checkInventory(character, bagId, isTest)
    local nBagItems = GetBagSize(bagId)
    for slotIdx = 0, nBagItems - 1 do
        local itemId = GetItemId(bagId, slotIdx)
        if itemId > 0 then
            local isWorn = (bagId == BAG_WORN)
            holdings.CheckHoldings(character, bagId, slotIdx, isWorn, isTest)
        end
    end
end

local checkAll = function(isTest)
    local character = GetUnitName("player")
    for idx, bagId in ipairs(bagList) do
        checkInventory(character, bagId, isTest)
    end
end

local initialize = function()

    if IsESOPlusSubscriber() then
        bagList = { BAG_WORN, BAG_BACKPACK, BAG_BANK, BAG_SUBSCRIBER_BANK, BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TWO, BAG_HOUSE_BANK_THREE, BAG_HOUSE_BANK_FOUR, BAG_HOUSE_BANK_FIVE, BAG_HOUSE_BANK_SIX, BAG_HOUSE_BANK_SEVEN, BAG_HOUSE_BANK_EIGHT, BAG_HOUSE_BANK_NINE, BAG_HOUSE_BANK_TEN }
    else
        bagList = { BAG_WORN, BAG_BACKPACK, BAG_BANK, BAG_HOUSE_BANK_ONE, BAG_HOUSE_BANK_TWO, BAG_HOUSE_BANK_THREE, BAG_HOUSE_BANK_FOUR, BAG_HOUSE_BANK_FIVE, BAG_HOUSE_BANK_SIX, BAG_HOUSE_BANK_SEVEN, BAG_HOUSE_BANK_EIGHT, BAG_HOUSE_BANK_NINE, BAG_HOUSE_BANK_TEN }
    end

    holdings = AccountHoldings.create()

    local savedVars = ZO_SavedVars:NewAccountWide("Inventorious_State", 1, nil, {})
    holdings.Load(savedVars)

    SLASH_COMMANDS["/inventorious"] = function(command)
        if (initialized == false) then
            d("Inventorious is still initializing - please wait...")
            return
        end

        if ("save" == command) then
            d("Saving...")
            holdings.Save(savedVars)
        elseif ("load" == command) then
            d("Loading...")
            holdings.Load(savedVars)
        elseif ("clear" == command) then
            d("Clearing...")
            holdings.Clear()
        elseif ("test" == command) then
            d("Testing...")
            checkAll(true)
        elseif ("check" == command) then
            d("Checking...")
            checkAll(false)
            holdings.Save(savedVars)
        end
        d("Done!")
    end

    holdings.Load(savedVars)

    initialized = true

end

EVENT_MANAGER:RegisterForEvent(Inventorious.name, EVENT_ADD_ON_LOADED, function(event, addonName)
    if addonName == Inventorious.name then
        EVENT_MANAGER:UnregisterForEvent(Inventorious.name, EVENT_ADD_ON_LOADED)
        initialize()
    end
end)

-- Globals

Inventorious.GetInitialized = function()
    return initialized
end






