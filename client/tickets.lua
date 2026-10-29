---------------------------------------------------------------
-- MARKER: is this entity a train deployed by THIS script?
-- Trains from other resources (e.g. a separate trams script) must NOT
-- be touched by the ticket thread below.
---------------------------------------------------------------
local function GetRailroadCompany(train)
    if train == 0 then return nil end
    -- Own deployed train: always ours
    if ActiveTrain and train == ActiveTrain and ActiveTrainConfig then
        return ActiveTrainConfig.company
    end
    -- Our ambient / route trains carry a replicated state flag.
    -- Trams from the other script never have it, even if they share
    -- the same model (e.g. appleseed_config), so they return nil.
    local ok, isOurs = pcall(function() return Entity(train).state['rsg-railroad:train'] end)
    if ok and isOurs then
        local pcoords = GetEntityCoords(cache.ped)
        local nearestDist, nearestCompany = math.huge, nil
        for _, station in ipairs(Config.Stations) do
            local dist = #(pcoords - station.coords)
            if dist < nearestDist then
                nearestDist, nearestCompany = dist, station.company
            end
        end
        return nearestCompany
    end
    return nil -- foreign train (e.g. tram) -> ignore
end

---------------------------------------------------------------
-- TRAIN TICKETS (passenger side)
-- When the player boards a train they are NOT driving, the server
-- consumes a ticket (or charges the on-board markup). No ticket and no
-- cash = kicked off. Drivers of their own spawned train are never charged.
---------------------------------------------------------------
local onTrain = false
local ticketed = false -- true once this ride was paid for

local function GetTicketCompany(train)
    return GetRailroadCompany(train)
end

local function KickOffTrain()
    SetTimeout(2000, function()
        local ped = cache.ped
        local coords = GetEntityCoords(ped)
        ClearPedTasksImmediately(ped)
        SetEntityCoords(ped, coords.x + 10.0, coords.y + 10.0, coords.z, false, false, false, false)
        Wait(500)
        PlaceEntityOnGroundProperly(ped)
    end)
end

local function CheckTicket(train)
    local result = lib.callback.await('rsg-railroad:server:useTicket', false, GetTicketCompany(train))

    ticketed = result == 'has_ticket' or result == 'bought_ticket'
    if result == 'has_ticket' then
        lib.notify({ title = locale('ticket_valid_title'), description = locale('ticket_valid_desc'), type = 'success', position = 'top-right', duration = 5000 })
    elseif result == 'bought_ticket' then
        lib.notify({
            title = locale('ticket_purchased_title'),
            description = locale('ticket_purchased_desc', string.format('%.2f', Config.MarkupPrice), string.format('%.2f', Config.TicketPrice)),
            type = 'warning', position = 'top-right', duration = 7000,
        })
    else
        lib.notify({
            title = locale('no_ticket_title'),
            description = locale('no_ticket_desc', string.format('%.2f', Config.MarkupPrice)),
            type = 'error', position = 'top-right', duration = 5000,
        })
        KickOffTrain()
    end
end

CreateThread(function()
    while true do
        local ped = cache.ped
        local inTrain = IsPedInAnyTrain(ped)

        if inTrain and not onTrain then
            onTrain = true
            local train = GetVehiclePedIsIn(ped, false)
            if train ~= 0 and GetTicketCompany(train) == nil then
                -- Foreign train (e.g. tram from another script): ignore entirely
                ticketed = false
            -- Driving your own train (or riding it as its spawner) is free
            elseif not (ActiveTrain and train == ActiveTrain) then
                CheckTicket(train)
            end
        elseif not inTrain and onTrain then
            onTrain = false
            if ticketed then
                ticketed = false
                lib.notify({ title = locale('journey_complete_title'), description = locale('journey_complete_desc'), type = 'success', position = 'top-right', duration = 5000 })
            end
        end

        Wait(1000)
    end
end)
