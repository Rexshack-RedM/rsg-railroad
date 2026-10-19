# rsg-railroad — Railroad Company Management System

Advanced train management system for RedM (rsg-core). Buy railroad companies, hire drivers, manage trains, run missions, and build a railroad empire.

---

## Features

### 🏢 Company Ownership
- **Buy a Railroad Company** — 4 companies available across the map ($50,000 each, configurable)
- **Rename Your Company** — Custom company names shown on UI
- **Cash Register** — Mission earnings split between driver and company fund
- **Withdraw Funds** — Owner can withdraw from the company cash register
- **Sell Company** — Sell back with refund + remaining cash register balance

### 👥 Employee System
- **Apply as Driver** — Players apply at any company station
- **Approve / Reject** — Owner reviews applications from the management panel
- **Fire Drivers** — Remove underperforming employees
- **Real-time Notifications** — Driver gets notified when approved/rejected/fired
- **Owner gets notified** when a new application is submitted

### 🚆 Train Fleet
- **30+ Preconfigured Trains** — Across 4 companies (Lemoyne Central, Heartlands Express, Cumberland & Western, New Austin Rail Co.)
- **Rank-Gated Access** — Drivers earn XP to unlock better trains (Brakeman → Foreman)
- **Deploy at Any Station** — Forward or reverse direction
- **Trains Start at 50%** fuel, water, and condition

### 🎮 Train Controls
- **Native RDR3 Controls** — L SHIFT accelerate, L CTRL brake/reverse, Left Mouse bell, G whistle
- **Cruise Control** — R for forward cruise, B for reverse. Train maintains speed hands-free
- **Cruise Continues When Leaving Seat** — Set cruise and walk around while the train moves
- **Emergency Brake** — X key for gradual stop
- **Track Switching** — Q key toggles between main and alternate routes
- **Engine Toggle** — via ox_target menu on the train

### 📋 Train HUD
- **Mini Clipboard UI** — Matches the station menu style, positioned top-left
- **Live Gauges** — Speed, fuel, water, condition with colored bars
- **Status Info** — Engine, cruise, junction, nearest station
- **Mission Tracker** — Shows active mission type and destination
- **Toggle with [ key** — Hide/show the HUD while driving

### 🔧 Train Maintenance (ox_target)
- **Add Coal** (+10% fuel per coal item, with shoveling animation)
- **Fill Water** (+10% per fullbucket item, with pouring animation)
- **Oil & Repair** (+10% condition per oilcan item, with repair animation)
- **Check Condition** — ox_lib context menu showing all stats with visual bars
- **Start/Stop Engine** — Toggle engine from outside the train
- **Send to Yard** — Despawn train, saves state

### 🧳 Train Storage
- **Per-Train Cargo Hold** — Every deployed train has its own inventory, opened from the **Train Storage** option on the train's ox_target menu
- **Capacity Scales With the Engine** — A handcart holds 6 slots, a Winter Special holds 32 (fully configurable per model)
- **Driver Only** — Only the player who deployed the train can open its hold
- **⚠️ Temporary by Design** — Contents are **destroyed** whenever the train leaves the world: parked, despawned, sent to yard, auto-recalled for distance, on death, mission failure, disconnect, or server restart
- **Why** — Train stashes are persistent database rows. Without this, a parked train would be unlimited free storage. The stash ID is regenerated on every deploy, so nothing can carry over
- **Reversing Is Safe** — "Reverse Direction" rebuilds the train entity but keeps your load
- **Loss Protection** — A warning on first open each trip, a confirmation dialog naming how many stacks will be destroyed before any manual put-away, and a proximity warning before the auto-recall distance

### 📦 Missions
- **One-Click Job Requests** — Just click "Start a Delivery Job" or "Start a Maintenance Job", no need to browse or pick a destination
- **Auto-Routed Job Chains** — Each job strings together multiple stops (3 by default); the script always sends you to the closest unvisited stop for the next leg
- **Cargo Delivery** — Transport goods between stations with blip guidance
- **Passenger Transport** — Board NPCs and deliver to destination
- **Rail Maintenance** — Travel to repair locations with progress bar
- **Distance Notifications** — "Approaching destination", "You have arrived"
- **Live Job Progress** — Train HUD shows the current leg (e.g. "Delivery (2/3)") until the whole job is complete
- **Pay Split** — 50/50 between driver and company (configurable), paid out after each completed stop
- **Rank Pay Bonus** — Higher rank = better pay multiplier

### 🏪 Company Supply Store
- **Owner Stocks Supplies** — Add coal, fullbucket, oilcan from personal inventory
- **Drivers Take for Free** — Employees access supplies at any company station
- **Per-Company Isolation** — Company A supplies are separate from Company B
- **Stock Tracking** — Owner sees current quantities

### 📊 Progression System
- **5 Ranks** — Brakeman → Fireman → Engineer → Conductor → Foreman
- **XP from Missions** — Complete deliveries to level up
- **Rank-Up Rewards** — Cash bonuses on promotion
- **Railwayman Milestones** — Personal achievement rewards

### 🔔 All Notifications via ox_lib
- Consistent notification style across all actions

### 🌍 Full Configuration
- Company purchase price, mission pay split, fuel/water/condition rates
- Train speeds, costs, ranks, upgrade tiers
- Station locations, delivery destinations, mission types
- Per-model train storage capacity
- All configurable in a single `shared/config.lua`

---

## Dependencies

- [rsg-core](https://github.com/Rexshack-RedM/rsg-core)
- [rsg-inventory](https://github.com/Rexshack-RedM/rsg-inventory) — required for Train Storage
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [oxmysql](https://github.com/overextended/oxmysql)

---

## Installation

1. **Items** — Add items from `install/shared_items.lua` to your `rsg-core/shared/items.lua`
2. **Item Images** — Add `coal.png`, `fullbucket.png`, `oilcan.png` to your inventory images folder
3. **Resource** — Place `rsg-railroad` in your resources folder
4. **Server Config** — Add to `server.cfg`:
   ```
   ensure rsg-railroad
   ```
   (After rsg-core, ox_lib, ox_target, oxmysql)
5. **Restart** your server

**Database:** No manual step needed. The resource automatically creates/verifies all of its MySQL tables (from `install/rsg_railroad_full.sql`) the first time it starts, and every restart after that — it's safe to run repeatedly since it only creates tables that don't already exist. Watch your server console on first boot for:

```
[rsg-railroad] Database tables verified/created successfully (7 statements).
```

If you'd rather import the SQL file yourself (e.g. you don't want the resource's MySQL user to need `CREATE TABLE` rights), set `Config.AutoInstallDatabase = false` in `shared/config.lua` and run `install/rsg_railroad_full.sql` manually as before.

---

## Configuration

All settings are in `shared/config.lua`:

| Setting | Default | Description |
|---------|---------|-------------|
| CompanyPurchasePrice | $50,000 | Cost to buy a railroad company |
| MissionPaySplit | 50/50 | Driver/company earnings split |
| Fuel.decreaseInterval | 30s | How often fuel depletes |
| Water.decreaseInterval | 45s | How often water depletes |
| Condition.decreaseInterval | 60s | How often condition degrades |
| MaxTrainsPerCompany | 5 | Max trains per company |
| TrainDespawnDist | 250 | Distance before train auto-recalls |
| Missions.delivery.jobLegs | 3 | Number of stops chained together in a Delivery Job |
| Missions.maintenance.jobLegs | 3 | Number of stops chained together in a Maintenance Job |
| TrainStorage.Enabled | true | Master switch for the per-train cargo hold |
| TrainStorage.DefaultSlots | 20 | Slots for any train model not listed in `Models` |
| TrainStorage.DefaultMaxWeight | 150000 | Weight limit for unlisted models |
| TrainStorage.ConfirmOnPutAway | true | Confirm before a manual put-away destroys a loaded hold |
| TrainStorage.WarnOnFirstOpen | true | Warn once per trip that storage is temporary |
| TrainStorage.DistanceWarnPercent | 0.7 | Warn at this fraction of `TrainDespawnDist` while carrying cargo |

### Setting storage capacity per train

Capacity lives in `Config.TrainStorage.Models` in `shared/config.lua`, keyed by **train model**:

```lua
Models = {
    handcart_config        = { slots = 6,  maxweight = 40000  },
    engine_config          = { slots = 20, maxweight = 150000 },
    appleseed_config       = { slots = 24, maxweight = 180000 },
    winter4_config         = { slots = 32, maxweight = 240000 },
    -- ...
},
```

Any model not listed falls back to `DefaultSlots` / `DefaultMaxWeight`.

**Note:** these are keyed by *model*, not by the train's display name. Several company trains share one model — `appleseed_config` backs "Appleseed Freight", "Heartland Hauler", "Cumberland Freight" and "Frontier Hauler" — so changing it affects all of them.

`maxweight` uses the same scale as rsg-inventory (1000 = 1kg), so `150000` is roughly 150kg.

---

## Usage

### As a Company Owner
1. Go to any train station → Hold G → "Buy Company"
2. Purchase the company for $50,000
3. Go to "Company Trains" tab → Select a train → Deploy
4. Manage drivers from "Manage Drivers" tab
5. Stock supplies from "Supplies" tab
6. Withdraw earnings from "My Company" tab

### As a Driver
1. Go to a station owned by a company → Hold G → "Apply as Driver"
2. Wait for owner to approve your application
3. Once approved: access Company Trains, Supplies, and Missions
4. Complete missions to earn money and XP
5. Rank up to unlock better trains

### Using Train Storage
1. Deploy a train from the "Company Trains" tab
2. Walk up to it and use your ox_target key (4m range)
3. Choose **Train Storage**
4. **Empty it before you finish.** Contents are destroyed when the train is stored, recalled, or you disconnect — it is a cargo hold for the trip, not a bank

---

## Languages

This resource uses ox_lib's locale system. Translations are provided for:

| Code | Language |
|------|----------|
| en | English (default) |
| de | German |
| el | Greek |
| es | Spanish |
| fr | French |
| ja | Japanese |
| nl | Dutch |
| pl | Polish |
| pt-br | Portuguese (Brazil) |
| ro | Romanian |

To change the language, set the `ox:locale` convar in your `server.cfg` (read by both ox_lib and this resource's NUI) before this resource starts, e.g.:

```
setr ox:locale de
```

If the selected language's file is missing, or a key hasn't been translated, the resource automatically falls back to `locales/en.json`. To add or edit a language, copy `locales/en.json`, translate the values (never the keys), and save it as `locales/<code>.json`.

---

## Support

RSG Discord
