local strategems = {
	["Machine Gun"] = {
		name = "Machine Gun",
		type = "Weapon",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Right",
		},
	},
	["Anti-Material Rifle"] = {
		name = "Anti-Material Rifle",
		type = "Weapon",
		sequence = {
			"Down",
			"Left",
			"Right",
			"Up",
			"Down",
		},
	},
	["Stalwart"] = {
		name = "Stalwart",
		type = "Weapon",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Up",
			"Left",
		},
	},
	["Expendable Anti-Tank"] = {
		name = "Expendable Anti-Tank",
		type = "Weapon",
		sequence = {
			"Down",
			"Down",
			"Left",
			"Up",
			"Right",
		},
	},
	["Recoilless Rifle"] = {
		name = "Recoilless Rifle",
		type = "Weapon",
		sequence = {
			"Down",
			"Left",
			"Right",
			"Right",
			"Left",
		},
	},
	["Flamethrower"] = {
		name = "Flamethrower",
		type = "Weapon",
		sequence = {
			"Down",
			"Left",
			"Up",
			"Down",
			"Up",
		},
	},
	["Autocannon"] = {
		name = "Autocannon",
		type = "Weapon",
		sequence = {
			"Down",
			"Right",
			"Left",
			"Down",
			"Down",
			"Up",
			"Up",
			"Right",
		},
	},
	["Railgun"] = {
		name = "Railgun",
		type = "Weapon",
		sequence = {
			"Down",
			"Right",
			"Left",
			"Down",
			"Down",
			"Up",
			"Left",
			"Down",
			"Right",
		},
	},
	["Spear"] = {
		name = "Spear",
		type = "Weapon",
		sequence = {
			"Down",
			"Down",
			"Up",
			"Down",
			"Down",
		},
	},
	["Gatling Barrage"] = {
		name = "Gatling Barrage",
		type = "Orbital",
		sequence = {
			"Right",
			"Down",
			"Left",
			"Up",
			"Up",
		},
	},
	["Airburst Strike"] = {
		name = "Airburst Strike",
		type = "Orbital",
		sequence = {
			"Right",
			"Right",
			"Right",
		},
	},
	["120MM HE Barrage"] = {
		name = "120MM HE Barrage",
		type = "Orbital",
		sequence = {
			"Right",
			"Down",
			"Down",
			"Left",
			"Down",
			"Right",
			"Down",
			"Down",
		},
	},
	["380MM HE Barrage"] = {
		name = "380MM HE Barrage",
		type = "Orbital",
		sequence = {
			"Right",
			"Down",
			"Down",
			"Up",
			"Up",
			"Left",
			"Down",
			"Down",
			"Down",
		},
	},
	["Walking Barrage"] = {
		name = "Walking Barrage",
		type = "Orbital",
		sequence = {
			"Right",
			"Down",
			"Right",
			"Down",
			"Right",
			"Down",
			"Right",
			"Down",
		},
	},
	["Laser Strike"] = {
		name = "Laser Strike",
		type = "Orbital",
		sequence = {
			"Right",
			"Up",
			"Left",
			"Up",
			"Right",
			"Left",
		},
	},
	["Railcannon Strike"] = {
		name = "Railcannon Strike",
		type = "Orbital",
		sequence = {
			"Right",
			"Down",
			"Up",
			"Down",
			"Left",
		},
	},
	["Eagle Strafing Run"] = {
		name = "Eagle Strafing Run",
		type = "Hangar",
		sequence = {
			"Up",
			"Right",
			"Right",
		},
	},
	["Eagle Airstrike"] = {
		name = "Eagle Airstrike",
		type = "Hangar",
		sequence = {
			"Up",
			"Right",
			"Down",
			"Right",
		},
	},
	["Eagle Cluster Bomb"] = {
		name = "Eagle Cluster Bomb",
		type = "Hangar",
		sequence = {
			"Up",
			"Right",
			"Down",
			"Down",
			"Right",
			"Down",
		},
	},
	["Eagle Napalm Airstrike"] = {
		name = "Eagle Napalm Airstrike",
		type = "Hangar",
		sequence = {
			"Up",
			"Right",
			"Down",
			"Up",
		},
	},
	["Jump Pack"] = {
		name = "Jump Pack",
		type = "Hangar",
		sequence = {
			"Down",
			"Up",
			"Up",
			"Down",
			"Up",
		},
	},
	["Eagle Smoke Strike"] = {
		name = "Eagle Smoke Strike",
		type = "Hangar",
		sequence = {
			"Up",
			"Right",
			"Up",
			"Down",
		},
	},
	["Eagle 110MM Rocket Pods"] = {
		name = "Eagle 110MM Rocket Pods",
		type = "Hangar",
		sequence = {
			"Up",
			"Down",
			"Up",
			"Left",
		},
	},
	["Eagle 500KG Bomb"] = {
		name = "Eagle 500KG Bomb",
		type = "Hangar",
		sequence = {
			"Up",
			"Left",
			"Down",
			"Down",
			"Down",
		},
	},
	["Orbital Precision Strikes"] = {
		name = "Orbital Precision Strikes",
		type = "Bridge",
		sequence = {
			"Right",
			"Right",
			"Up",
		},
	},
	["Orbital Gas Strike"] = {
		name = "Orbital Gas Strike",
		type = "Bridge",
		sequence = {
			"Right",
			"Right",
			"Down",
			"Right",
		},
	},
	["Orbital EMS Strike"] = {
		name = "Orbital EMS Strike",
		type = "Bridge",
		sequence = {
			"Right",
			"Right",
			"Left",
			"Down",
		},
	},
	["Orbital Smoke Strike"] = {
		name = "Orbital Smoke Strike",
		type = "Bridge",
		sequence = {
			"Right",
			"Right",
			"Down",
			"Up",
		},
	},
	["HMG Emplacement"] = {
		name = "HMG Emplacement",
		type = "Bridge",
		sequence = {
			"Up",
			"Down",
			"Left",
			"Right",
			"Right",
			"Left",
		},
	},
	["Shield Generator Relay"] = {
		name = "Shield Generator Relay",
		type = "Bridge",
		sequence = {
			"Down",
			"Up",
			"Left",
			"Right",
			"Left",
			"Down",
		},
	},
	["Tesla Tower"] = {
		name = "Tesla Tower",
		type = "Bridge",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Up",
			"Left",
			"Right",
		},
	},
	["Anti-Personnel Minefield"] = {
		name = "Anti-Personnel Minefield",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Right",
		},
	},
	["Supply Pack"] = {
		name = "Supply Pack",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Up",
			"Down",
		},
	},
	["Grenade Launcher"] = {
		name = "Grenade Launcher",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Left",
			"Down",
			"Down",
		},
	},
	["Laser Cannon"] = {
		name = "Laser Cannon",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Left",
		},
	},
	["Incendiary Mines"] = {
		name = "Incendiary Mines",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Left",
			"Down",
		},
	},
	["Guard Dog Rover"] = {
		name = "Guard Dog Rover",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Down",
			"Up",
			"Left",
			"Down",
			"Down",
		},
	},
	["Ballistic Shield Backpack"] = {
		name = "Ballistic Shield Backpack",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Left",
			"Up",
			"Up",
			"Right",
		},
	},
	["Arc Thrower"] = {
		name = "Arc Thrower",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Right",
			"Up",
			"Left",
			"Down",
		},
	},
	["Shield Generator Pack"] = {
		name = "Shield Generator Pack",
		type = "Engineering Bay",
		sequence = {
			"Down",
			"Up",
			"Left",
			"Down",
			"Right",
			"Right",
		},
	},
	["Machine Gun Sentry"] = {
		name = "Machine Gun Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Right",
			"Up",
		},
	},
	["Gatling Sentry"] = {
		name = "Gatling Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Left",
			"Down",
		},
	},
	["Mortar Sentry"] = {
		name = "Mortar Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Right",
			"Down",
		},
	},
	["Guard Dog"] = {
		name = "Guard Dog",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Left",
			"Up",
			"Right",
			"Down",
		},
	},
	["Autocannon Sentry"] = {
		name = "Autocannon Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Up",
			"Left",
			"Up",
		},
	},
	["Rocket Sentry"] = {
		name = "Rocket Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Up",
			"Right",
			"Right",
			"Left",
		},
	},
	["EMS Mortar Sentry"] = {
		name = "EMS Mortar Sentry",
		type = "Robotics",
		sequence = {
			"Down",
			"Down",
			"Up",
			"Up",
			"Left",
		},
	},
	["Reinforce"] = {
		name = "Reinforce",
		type = "Mission Stratagem",
		sequence = {
			"Up",
			"Down",
			"Right",
			"Left",
			"Up",
		},
	},
	["SOS Beacon"] = {
		name = "SOS Beacon",
		type = "Mission Stratagem",
		sequence = {
			"Up",
			"Down",
			"Right",
			"Up",
		},
	},
	["Super Earth Flag"] = {
		name = "Super Earth Flag",
		type = "Mission Stratagem",
		sequence = {
			"Down",
			"Up",
			"Down",
			"Up",
		},
	},
	["Upload Data"] = {
		name = "Upload Data",
		type = "Mission Stratagem",
		sequence = {
			"Left",
			"Right",
			"Up",
			"Up",
			"Up",
		},
	},
	["Hellbomb"] = {
		name = "Hellbomb",
		type = "Mission Stratagem",
		sequence = {
			"Down",
			"Up",
			"Left",
			"Down",
			"Up",
			"Right",
			"Down",
			"Up",
		},
	},
}

local M = {}

---Returns true if the sub list is a prefix of the list
---@param list any[]
---@param sub any[]
local function list_partial_eq(list, sub)
	if #list < #sub then
		return false
	end
	for i, v in ipairs(sub) do
		if list[i] ~= v then
			return false
		end
	end
	return true
end

---@alias StratHero.Motion "Up"|"Down"|"Left"|"Right"

---@class StratHero.Stratagem
---@field public name string
---@field public type string
---@field public sequence StratHero.Motion[]

---@class StratHero.Filter: StratHero.Stratagem

---@param name string
---@return StratHero.Stratagem
function M.get(name)
	return strategems[name]
end

---@param filter StratHero.Filter
function M.list(filter)
	local iter = vim.iter(strategems)

	if filter then
		if filter.name then
			iter = iter:filter(function(name)
				return string.match(name, filter.name) ~= nil
			end)
		end

		if filter.type then
			iter = iter:filter(function(_, stratagem)
				return string.match(stratagem.type, filter.type) ~= nil
			end)
		end

		if filter.sequence then
			iter = iter:filter(function(_, stratagem)
				return list_partial_eq(stratagem.sequence, filter.sequence)
			end)
		end
	end

	return iter:map(function(_, strat)
		return strat
	end):totable()
end

---@return string[]
function M.categories()
	local seen = {}
	return vim.iter(strategems)
		:map(function(stratagem)
			return stratagem.type
		end)
		:filter(function(type)
			if seen[type] then
				return false
			end
			seen[type] = true
			return true
		end)
		:totable()
end

return M
