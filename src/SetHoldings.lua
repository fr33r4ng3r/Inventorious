Inventorious = Inventorious or {}

local Rules = Inventorious.imports.Rules

local EquipmentTypesToNames = {
    [EQUIP_TYPE_CHEST]     = "chest",
    [EQUIP_TYPE_FEET]      = "feet",
    [EQUIP_TYPE_HAND]      = "hands",
    [EQUIP_TYPE_HEAD]      = "head",
    [EQUIP_TYPE_LEGS]      = "legs",
    [EQUIP_TYPE_SHOULDERS] = "shoulders",
    [EQUIP_TYPE_WAIST]     = "waist",
    [EQUIP_TYPE_NECK]      = "neck",
    [EQUIP_TYPE_RING]      = "ring"
}

local EquipmentTypesSetCounts = {
    [EQUIP_TYPE_CHEST]     = 1,
    [EQUIP_TYPE_FEET]      = 1,
    [EQUIP_TYPE_HAND]      = 1,
    [EQUIP_TYPE_HEAD]      = 1,
    [EQUIP_TYPE_LEGS]      = 1,
    [EQUIP_TYPE_SHOULDERS] = 1,
    [EQUIP_TYPE_WAIST]     = 1,
    [EQUIP_TYPE_NECK]      = 1,
    [EQUIP_TYPE_RING]      = 2
}

local ArmorTypeNames = {
    [ARMORTYPE_HEAVY]  = "heavy",
    [ARMORTYPE_LIGHT]  = "light",
    [ARMORTYPE_MEDIUM] = "medium",
    [ARMORTYPE_NONE]   = "none",
}

local WeaponTypeNames = {
    [WEAPONTYPE_AXE]               = "axe",
    [WEAPONTYPE_BOW]               = "bow",
    [WEAPONTYPE_DAGGER]            = "dagger",
    [WEAPONTYPE_FIRE_STAFF]        = "fire staff",
    [WEAPONTYPE_FROST_STAFF]       = "frost staff",
    [WEAPONTYPE_HAMMER]            = "hammer",
    [WEAPONTYPE_HEALING_STAFF]     = "resto staff",
    [WEAPONTYPE_LIGHTNING_STAFF]   = "lightning staff",
    [WEAPONTYPE_NONE]              = "none",
    [WEAPONTYPE_SHIELD]            = "shield",
    [WEAPONTYPE_SWORD]             = "sword",
    [WEAPONTYPE_TWO_HANDED_AXE]    = "two handed axe",
    [WEAPONTYPE_TWO_HANDED_HAMMER] = "two handed hammer",
    [WEAPONTYPE_TWO_HANDED_SWORD]  = "two handed sword",
}

local WeaponTypeSetCounts = {
    [WEAPONTYPE_AXE]               = 2,
    [WEAPONTYPE_BOW]               = 1,
    [WEAPONTYPE_DAGGER]            = 2,
    [WEAPONTYPE_FIRE_STAFF]        = 1,
    [WEAPONTYPE_FROST_STAFF]       = 1,
    [WEAPONTYPE_HAMMER]            = 2,
    [WEAPONTYPE_HEALING_STAFF]     = 1,
    [WEAPONTYPE_LIGHTNING_STAFF]   = 1,
    [WEAPONTYPE_SHIELD]            = 1,
    [WEAPONTYPE_SWORD]             = 2,
    [WEAPONTYPE_TWO_HANDED_AXE]    = 1,
    [WEAPONTYPE_TWO_HANDED_HAMMER] = 1,
    [WEAPONTYPE_TWO_HANDED_SWORD]  = 1,
}

local TraitTypesToNames = {
    [ITEM_TRAIT_TYPE_ARMOR_DIVINES]        = "divines",
    [ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE]   = "impenetrable",
    [ITEM_TRAIT_TYPE_ARMOR_INFUSED]        = "infused",
    [ITEM_TRAIT_TYPE_ARMOR_INTRICATE]      = "intricate",
    [ITEM_TRAIT_TYPE_ARMOR_NIRNHONED]      = "nirnhoned",
    [ITEM_TRAIT_TYPE_ARMOR_ORNATE]         = "ornate",
    [ITEM_TRAIT_TYPE_ARMOR_PROSPEROUS]     = "prosperous",
    [ITEM_TRAIT_TYPE_ARMOR_REINFORCED]     = "reinforced",
    [ITEM_TRAIT_TYPE_ARMOR_STURDY]         = "sturdy",
    [ITEM_TRAIT_TYPE_ARMOR_TRAINING]       = "training",
    [ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED]    = "well fitted",
    [ITEM_TRAIT_TYPE_JEWELRY_ARCANE]       = "arcane",
    [ITEM_TRAIT_TYPE_JEWELRY_HEALTHY]      = "healthy",
    [ITEM_TRAIT_TYPE_JEWELRY_ORNATE]       = "ornate",
    [ITEM_TRAIT_TYPE_JEWELRY_ROBUST]       = "robust",
    [ITEM_TRAIT_TYPE_NONE]                 = "none",
    [ITEM_TRAIT_TYPE_WEAPON_CHARGED]       = "charged",
    [ITEM_TRAIT_TYPE_WEAPON_DECISIVE]      = "decisive",
    [ITEM_TRAIT_TYPE_WEAPON_DEFENDING]     = "defending",
    [ITEM_TRAIT_TYPE_WEAPON_INFUSED]       = "infused",
    [ITEM_TRAIT_TYPE_WEAPON_INTRICATE]     = "intricate",
    [ITEM_TRAIT_TYPE_WEAPON_NIRNHONED]     = "nirnhoned",
    [ITEM_TRAIT_TYPE_WEAPON_ORNATE]        = "ornate",
    [ITEM_TRAIT_TYPE_WEAPON_POWERED]       = "powered",
    [ITEM_TRAIT_TYPE_WEAPON_PRECISE]       = "precise",
    [ITEM_TRAIT_TYPE_WEAPON_SHARPENED]     = "sharpened",
    [ITEM_TRAIT_TYPE_WEAPON_TRAINING]      = "training",
    [ITEM_TRAIT_TYPE_JEWELRY_BLOODTHIRSTY] = "bloodthirsty",
    [ITEM_TRAIT_TYPE_JEWELRY_HARMONY]      = "harmony",
    [ITEM_TRAIT_TYPE_JEWELRY_INFUSED]      = "infused",
    [ITEM_TRAIT_TYPE_JEWELRY_PROTECTIVE]   = "protective",
    [ITEM_TRAIT_TYPE_JEWELRY_SWIFT]        = "swift",
    [ITEM_TRAIT_TYPE_JEWELRY_TRIUNE]       = "triune"
}

local QualityNames = {
    [ITEM_QUALITY_ARCANE]    = "blue",
    [ITEM_QUALITY_ARTIFACT]  = "purple",
    [ITEM_QUALITY_LEGENDARY] = "yellow",
    [ITEM_QUALITY_MAGIC]     = "green",
    [ITEM_QUALITY_NORMAL]    = "white",
    [ITEM_QUALITY_TRASH]     = "trash",
}

local DISPOSITION_SKIP = 0
local DISPOSITION_EVAL = 1
local DISPOSITION_DECON = 2
local DISPOSITION_SELL = 3

local AccountHoldings = {}
local SetHoldings = {}
local SetHoldingItem = {}

AccountHoldings.create = function()

    local self = {
        holdings = {}
    }

    local save = function(savedVars)
        local temp = {}
        for name, copies in pairs(self.holdings) do
            temp[name] = {}
            for copy, holdings in pairs(copies) do
                temp[name][copy] = holdings.Serialize()
            end
        end
        savedVars.setHoldings = temp
    end

    local load = function(savedVars)
        local temp = {}
        if savedVars.setHoldings ~= nil then
            for name, copies in pairs(savedVars.setHoldings) do
                temp[name] = {}
                for copy, holdings in pairs(copies) do
                    local obj = SetHoldings.create(name, copy)
                    obj.Deserialize(holdings)
                    temp[name][copy] = obj
                end
            end
        end
        self.holdings = temp
    end

    local clear = function()
        self.holdings = {}
    end

    local checkHoldings = function(character, bagId, slotIdx, isWorn, isTest)

        if isTest == nil then
            isTest = true
        end

        local itemLink = GetItemLink(bagId, slotIdx)

        local itemType = GetItemLinkItemType(itemLink)
        if not itemType == ITEMTYPE_ARMOR and not itemType == ITEMTYPE_WEAPON then
            return
        end

        local itemLevel = GetItemLinkRequiredLevel(itemLink)
        if (itemLevel < 50) then
            return
        end

        local championPoints = GetItemLinkRequiredChampionPoints(itemLink)
        if (championPoints < 160) then
            return
        end

        local hasSet, sSetName = GetItemLinkSetInfo(itemLink, false)
        if (sSetName:len() == 0) then
            return
        end

        local setName = zo_strformat(SI_TOOLTIP_ITEM_NAME, sSetName)

        if (setName:len() == 0) then
            d("WARNING! No tooltip name found for " .. sSetName)
            return
        end

        if (self.holdings[setName] == nil) then
            self.holdings[setName] = {}
        end

        local trackIndex, trackName = SetTrack.GetTrackingInfo(bagId, slotIdx)
        if (trackName == nil) then
            return
        end

        local uniqueId = Id64ToString(GetItemUniqueId(bagId, slotIdx))

        local unmarked = false
        if isTest == false then
            if (FCOIS.IsMarkedByItemInstanceId(uniqueId, FCOIS_CON_ICON_DECONSTRUCTION)) then
                FCOIS.MarkItemByItemInstanceId(uniqueId, FCOIS_CON_ICON_DECONSTRUCTION, false, itemLink)
                unmarked = true
            end
        end

        local count = Rules.SetKeepCollecting[setName]
        if (count == nil) then
            if trackName:find("Someday") then
                count = Rules.SET_KEEP_SOMEDAY_DEFAULT
            else
                count = Rules.SET_KEEP_COLLECTING_DEFAULT
            end
        end

        local wornBy
        if (isWorn == true) then
            wornBy = character
        end

        local result
        for i = 1, count do
            local holding = self.holdings[setName][i]
            if (holding == nil) then
                holding = SetHoldings.create(setName, i)
                self.holdings[setName][i] = holding
            end

            result = holding.CheckItem(uniqueId, itemLink, trackName, wornBy)

            if (result == nil) then
                d("WARNING!: Unexpected Nil Result")
                return
            end

            if (result.disposition == DISPOSITION_SKIP) then
                -- d("Keeping: " .. setName .. " " .. result.item.ToString())
                return
            end

            if (result.disposition == DISPOSITION_SELL) then
                --FCOIS_CON_ICON_SELL
                --FCOIS_CON_ICON_DECONSTRUCTION
                --FCOIS_CON_ICON_SELL_AT_GUILDSTORE
                if not (FCOIS.IsMarkedByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_SELL)) then
                    d("Marking item to sell: " .. setName .. " " .. result.item.ToString())
                    if isTest == false then
                        FCOIS.MarkItemByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_SELL, true, result.item.GetLink())
                    end
                end
                return
            elseif (result.disposition == DISPOSITION_DECON) then
                if not (FCOIS.IsMarkedByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION)) then
                    d("Marking item to decon: " .. setName .. " " .. result.item.ToString())
                    if isTest == false then
                        FCOIS.MarkItemByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION, true, result.item.GetLink())
                    end
                end
                return
            elseif (result.disposition == DISPOSITION_EVAL) then
                if not (result.item.GetUniqueId() == uniqueId) then
                    uniqueId = result.item.GetUniqueId()
                    itemLink = result.item.GetLink()
                end
            else
                d("Unexpected result disposition " .. result.disposition)
                return
            end
        end

        if (isWorn == true and result.item.GetUniqueId() == uniqueId) then
            d("HEADS UP!  Check your bags for a better " .. setName .. " " .. result.item.ToString())
            if isTest == false then
                if (FCOIS.IsMarkedByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION)) then
                    FCOIS.MarkItemByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION, false, result.item.GetLink())
                end
            end
            return
        elseif (result.item.GetUniqueId() ~= uniqueId and result.item.GetWornBy() ~= nil and result.item.GetWornBy() ~= character) then
            d("HEADS UP!  Yours is better! " .. setName .. " " .. result.item.ToString())
            return
        end

        if not (FCOIS.IsMarkedByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION)) then
            if (unmarked == false or result.item.GetUniqueId() ~= uniqueId) then
                d("Marking item to decon: " .. setName .. " " .. result.item.ToString())
            end
            if isTest == false then
                FCOIS.MarkItemByItemInstanceId(result.item.GetUniqueId(), FCOIS_CON_ICON_DECONSTRUCTION, true, result.item.GetLink())
            end
        end
    end

    return {
        Save          = save,
        Load          = load,
        Clear         = clear,
        CheckHoldings = checkHoldings
    }

end

SetHoldings.create = function(itemSetName, copy)

    local self = {
        itemSetName = itemSetName,
        copy        = copy,
        items       = {}
    }

    local serialize = function()
        local temp = {}
        for type, item in pairs(self.items) do
            temp[type] = item.Serialize()
        end
        return temp
    end

    local deserialize = function(saved)
        local temp = {}
        for key, item in pairs(saved) do
            local obj = SetHoldingItem.create()
            obj.Deserialize(item)
            temp[key] = obj
        end
        self.items = temp
    end

    local checkItem = function(uniqueId, itemLink, trackName, wornBy)
        local item = SetHoldingItem.create(uniqueId, itemLink, wornBy)
        local keys = item.GetKeys()
        local kept = false
        for i, key in ipairs(keys) do
            local existing = self.items[key]
            if existing ~= nil and existing.GetUniqueId() == uniqueId then
                kept = true
                break
            elseif existing == nil then
                self.items[key] = item
                kept = true
                break
            end
        end
        if not kept == true then
            -- d("Found Duplicate of " .. self.itemSetName .. " ".. item.GetKey() .. " in " .. trackName)
            local newTraitOrder = item.GetTraitOrder(trackName)
            local newWeaponOrder = item.GetWeaponOrder(trackName)
            if newTraitOrder < 0 and newWeaponOrder < 0 then
                return {
                    disposition = DISPOSITION_SKIP,
                    item        = item
                }
            elseif newTraitOrder == 99 or newWeaponOrder == 99 then
                return {
                    disposition = DISPOSITION_DECON,
                    item        = item
                }
            elseif newTraitOrder == 98 or newWeaponOrder == 98 then
                return {
                    disposition = DISPOSITION_SELL,
                    item        = item
                }
            else
                local forEachKey = function(callback)
                    for i, key in ipairs(keys) do
                        local existing = self.items[key]
                        if (existing ~= nil) then
                            local existingTraitOrder = existing.GetTraitOrder(trackName)
                            local existingWeaponOrder = existing.GetWeaponOrder(trackName)
                            local swap = function()
                                d("Replacing " .. existing.ToString() .. " with " .. item.ToString() .. " for " .. self.itemSetName .. " [" .. trackName .. "]")
                                self.items[key] = item
                                item = existing
                                newTraitOrder = existingTraitOrder
                                newWeaponOrder = existingWeaponOrder
                            end
                            callback(existing, existingTraitOrder, existingWeaponOrder, swap)
                        end
                    end
                end
                local compareQuality = function(existing, swap)
                    if item.GetQuality() > existing.GetQuality() then
                        swap()
                    end
                end
                local compareWeapons = function(existing, existingWeaponOrder, swap)
                    if newWeaponOrder > 0 then
                        if (newWeaponOrder < existingWeaponOrder) then
                            swap()
                        elseif (newWeaponOrder == existingWeaponOrder) then
                            compareQuality(existing, swap)
                        end
                    else
                        compareQuality(existing, swap)
                    end
                end
                if (newTraitOrder > 0) then
                    forEachKey(function(existing, existingTraitOrder, existingWeaponOrder, swap)
                        if (newTraitOrder < existingTraitOrder) then
                            swap()
                        elseif newTraitOrder == existingTraitOrder then
                            compareWeapons(existing, existingWeaponOrder, swap)
                        end
                    end)
                elseif (newWeaponOrder > 0) then
                    forEachKey(function(existing, existingTraitOrder, existingWeaponOrder, swap)
                        compareWeapons(existing, existingWeaponOrder, swap)
                    end)
                end
                return {
                    disposition = DISPOSITION_EVAL,
                    item        = item
                }
            end
        else
            return {
                disposition = DISPOSITION_SKIP,
                item        = item
            }
        end
    end

    return {
        CheckItem   = checkItem,
        Serialize   = serialize,
        Deserialize = deserialize
    }

end

SetHoldingItem.create = function(uniqueId, itemLink, wornBy)

    local self = {}

    local computeKey = function(itemLink)
        local itemType = GetItemLinkItemType(itemLink)
        local equipType = GetItemLinkEquipType(itemLink)
        local weaponType
        local armorType
        local key
        if itemType == ITEMTYPE_ARMOR then
            armorType = GetItemLinkArmorType(itemLink)
            if (armorType == ARMORTYPE_NONE) then
                -- jewelry
                key = EquipmentTypesToNames[equipType]
            else
                key = ArmorTypeNames[armorType] .. " " .. EquipmentTypesToNames[equipType]
            end
        elseif itemType == ITEMTYPE_WEAPON then
            weaponType = GetItemLinkWeaponType(itemLink)
            key = WeaponTypeNames[weaponType]
        else
            key = "UNKNOWN"
        end
        return key, equipType, itemType, weaponType, armorType
    end

    local init = function(uniqueId, itemLink, wornBy)
        if (itemLink ~= nil) then
            local traitType = GetItemLinkTraitInfo(itemLink)
            local key, equipType, itemType, weaponType, armorType = computeKey(itemLink)
            local quality = GetItemLinkQuality(itemLink)
            self = {
                uniqueId   = uniqueId,
                itemLink   = itemLink,
                itemType   = itemType,
                itemKey    = key,
                traitType  = traitType,
                equipType  = equipType,
                itemType   = itemType,
                weaponType = weaponType,
                armorType  = armorType,
                quality    = quality,
                wornBy     = wornBy
            }
        else
            self = {
                uniqueId = uniqueId,
            }
        end
    end

    init(uniqueId, itemLink, wornBy)

    local getKeys = function()
        local count
        if self.itemType == ITEMTYPE_ARMOR then
            count = EquipmentTypesSetCounts[self.equipType]
        elseif self.itemType == ITEMTYPE_WEAPON then
            count = WeaponTypeSetCounts[self.weaponType]
        else
            count = 0
        end
        local result = {}
        for i = 1, count do
            result[i] = self.itemKey .. " (" .. i .. ")"
        end
        return result
    end

    local getKey = function()
        return self.itemKey
    end

    local getTrait = function()
        return self.traitType
    end

    local getEquipmentType = function()
        return self.equipType
    end

    local getQuality = function()
        return self.quality
    end

    local toString = function(forSerialization)
        if forSerialization == nil then
            horseTrainingDone = false
        end
        local result = QualityNames[self.quality] .. " " .. TraitTypesToNames[self.traitType] .. " " .. self.itemKey
        if (forSerialization == false and self.wornBy ~= nil) then
            result = result .. " (Worn by: " .. self.wornBy .. ")"
        end
        return result
    end

    local serialize = function()
        return {
            description = toString(true),
            uniqueId    = self.uniqueId,
            itemLink    = self.itemLink,
            wornBy      = self.wornBy
        }
    end

    local deserialize = function(saved)
        init(saved.uniqueId, saved.itemLink, saved.wornBy)
    end

    local getUniqueId = function()
        return self.uniqueId
    end

    local getLink = function()
        return self.itemLink
    end

    local getWornBy = function()
        return self.wornBy
    end

    local getTraitOrder = function(trackName)
        local traitOrders = Rules.TraitOrders[trackName]
        if (traitOrders == nil) then
            return -1
        end
        -- d("Trait Order Found for " .. trackName)
        local specificTraitOrders = traitOrders[self.traitType]
        if (specificTraitOrders == nil) then
            return -1
        end
        -- d("Trait Found " .. (TraitTypesToNames[self.traitType]))
        local traitOrder = specificTraitOrders[self.equipType]
        if traitOrder == nil then
            traitOrder = specificTraitOrders[Rules.EQUIP_TYPE_OTHER]
        end
        return traitOrder
    end

    local getWeaponOrder = function(trackName)
        if (self.weaponType == nil) then
            return 0
        end
        local weaponOrders = Rules.WeaponOrders[trackName]
        if (weaponOrders == nil) then
            return -1
        end
        return weaponOrders[self.weaponType]
    end

    return {
        GetUniqueId      = getUniqueId,
        Serialize        = serialize,
        Deserialize      = deserialize,
        GetLink          = getLink,
        GetKeys          = getKeys,
        GetKey           = getKey,
        GetTrait         = getTrait,
        GetEquipmentType = getEquipmentType,
        GetWornBy        = getWornBy,
        GetTraitOrder    = getTraitOrder,
        GetWeaponOrder   = getWeaponOrder,
        GetQuality       = getQuality,
        ToString         = toString
    }

end

-- IsItemLinkForcedNotDeconstructable

Inventorious.imports = Inventorious.imports or {}
Inventorious.imports.AccountHoldings = AccountHoldings
Inventorious.imports.SetHoldings = SetHoldings
Inventorious.imports.SetHoldingItem = SetHoldingItem