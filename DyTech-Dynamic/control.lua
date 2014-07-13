require "defines"
require "scripts/database"
require "scripts/functions"

game.oninit(function()
	remote.call("DyTech-Core", "addModule", "dynamic")
	fs.OnInit()
end)

game.onsave(function()

end)

game.onload(function()
	fs.OnLoad()
end)

game.onevent(defines.events.ontick, function(event)
	--[[Checking to see which modules are installed. This happens every 5 Minutes!]]--
	if event.tick%18000==0 then
		fs.ModuleCheck()
	end
end)

game.onevent(defines.events.onplayercrafteditem, function(event)
incrementDynamicCounters = function(stack)
   if database.craftitems[stack.name] then
		for counter, ingredients in pairs(database.craftitems[stack.name]) do
			if database.craftitems[counter] then
				incrementDynamicCounters({name=counter, count=ingredients})
			else
			local count=0
			for w in counter:gmatch("([%w%-]+)%.?") do count = count+1 end
			it = counter:gmatch("([%w%-]+)%.?")
			it2 = counter:gmatch("([%w%-]+)%.?")
				if count == 1 then
					glob.crafted[it()]=glob.crafted[it2()]+(stack.count*ingredients)
				elseif count == 2 then
					glob.crafted[it()][it()]=glob.crafted[it2()][it2()]+(stack.count*ingredients)
				else -- this is why it's ugly! more ifs must be added manually.
					game.player.print("Tell Dysoch he needs more dynamic iterator statements for" .. stack.name)
				end
			end
		end
	end
end
incrementDynamicCounters(event.itemstack)
end)

remote.addinterface("DyTech-Dynamic",
{
  CounterPrinterIntermediates = function() 
	fs.CounterPrinterIntermediates()
  end,
  
  ToggleDynamicSystem = function()
	if glob.dynamic==true then
		glob.dynamic = false
	else
		glob.dynamic = true
	end
  end
})