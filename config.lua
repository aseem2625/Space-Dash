application =
{

	content =
	{
		width = 320,
		height = 480, 
		scale = "letterBox",
		fps = 60,
		xAlign = "center",
        yAlign = "center",		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
		},
		--]]
		-- imageSuffix = {
		-- 	["@1"] = 1.0,
		-- 	["@2"] = 2.0,
		-- 	["@retina"] = 4.0
		-- }

	},
	-- application =
	-- {
	--     license =
	--     {
	--         google =
	--         {
	--             key = "Your key here",
	--             policy = "strict",
	--         },
	--     },
	-- }    

	--[[
	-- Push notifications
	notification =
	{
		iphone =
		{
			types =
			{
				"badge", "sound", "alert", "newsstand"
			}
		}
	},
	--]]    
}
