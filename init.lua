local entries = journal.require "entries"
local triggers = journal.require "triggers"

--register a new journal page for the pirate story
entries.register_page("pirate_story:log","ship guide","captain's log")

--write first entry when joining
triggers.register_on_join({
	id = "pirate_story:start",
	-- trigger is called once per player
	call_once = true,
	call = function(data)
		entries.add_entry(data.playerName,"pirate_story:log","Oi? I stranded somewhere... "..
			"Where is this? Darn if only I coulda remember where I came from.",true)
	end,
})

--entry when dying (sure... why not?)
triggers.register_on_die({
  id = "pirate_story:died",
  call_once = true,
  call = function(data)
    entries.add_entry(data.playerName,"pirate_story:log","Today I died, arr that got me really scared "..
    "it'd have been me last day. But here I am back from heavens prolonging my buccaneer's living.", true)
  end
})

--entry when chopping a tree
triggers.register_on_dig({
	target = "default:tree",
	id = "pirate_story:foundTree",
	call_once = true,
	call = function(data)
		entries.add_entry(data.playerName,"pirate_story:log","Today I got a log. "..
			"It's nothing but a little piece for the ship that I'll build.",true)
	end,
})

---
--Episode: ship
---

--register a counter for the number of crafted planks
triggers.register_counter("pirate_story:craftedPlanksCount","craft","default:wood",false)

---send message using the counter
--it should usually be used in the is_active function tho
triggers.register_on_craft({
	target = "default:wood",
	id = "pirate_story:craftedPlanks",
  call_once = true,
  call_after = "pirate_story:foundTree",
	is_active = function(player)
		return triggers.get_count("pirate_story:craftedPlanksCount",player) > 5
	end,
	call = function(data)
		local count = triggers.get_count("pirate_story:craftedPlanksCount",data.playerName)
		entries.add_entry(data.playerName,"pirate_story:log","So I crafted ".. count .." planks, "..
			"but I'll need a lota more planks to build me ship.",true)
	end,
})

--entry when crafting a boat
triggers.register_on_craft({
	target = "boats:boat",
	id = "pirate_story:craftedBoat",
	call_once = true,
	call_after = "pirate_story:craftedPlanks",
	call = function(data)
		entries.add_entry(data.playerName,"pirate_story:log","Well I have my ship now ...",true)
		minetest.after(10,entries.add_entry,data.playerName,"pirate_story:log",
			"On second thoughts, I woulda expected me ship to be bigger.\n"..
			"Maybe out there on the open sea are some bigger ships...",true)
	end,
})

---
--Episode: treasure
---

--entry when crafting a chest
triggers.register_on_craft({
	target = "default:chest",
	id = "pirate_story:craftedChest",
	call_once = true,
	call_after = "pirate_story:craftedPlanks",
	call = function(data)
		entries.add_entry(data.playerName,"pirate_story:log","Arr, that's one fine chest...\n"..
			"I oughta fill that one with some sorta treasure.",true)
	end,
})

--entry when digging up some treasure
triggers.register_on_dig({
	target = {"default:stone_with_gold", "default:stone_with_diamond"},
	id = "pirate_story:foundTreasure",
  call_once = true,
  call_after = "pirate_story:craftedChest",
	call = function(data)
		entries.add_entry(data.playerName,"pirate_story:log","Oooh.., that's some shiny treasure!",true)
		minetest.after(10,entries.add_entry,data.playerName,"pirate_story:log",
			"Now I got something to put in me chest.",true)
		minetest.after(15,entries.add_entry,data.playerName,"pirate_story:log",
			"Ah wait,the treasure is already mine!\n"..
			"I won't give away this treasure just to hide it somewhere!",true)
	end,
})
