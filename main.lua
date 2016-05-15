
---------------------------------------------------------------------------------
--
-- main.lua
--
-- AUTHOR of game idea, code and graphics: Aseem Gupta
-- PERMISSIONS to the viewer of code: This game is done for corona venturesity.com hackathon: 'Game Warriors'. All code(except external libraies) and graphics
-- can only be used for educational and personal purposes only. However, if you need to ask something personally then you can email me at aseemgupta2625@gmail.com.gmail.com
-- CREDITS for sounds, fonts and tools and any other external things are gratefully given on this github project page.
-- LICENSE - MIT
---------------------------------------------------------------------------------

-- If game is restricted to be installed on device if downloadaed from Plyastore only
-- local licensing = require( "licensing" )
-- licensing.init( "google" )

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )


-- Hide navigation bar on Android
if platform == 'Android' then
	native.setProperty('androidSystemUiVisibility', 'immersiveSticky')
end


-- require the composer library
local composer = require "composer"
composer.recycleOnSceneChange = true -- Automatically remove scenes from memory


-- Back Button support for Android
-- When it's pressed, check if current scene has a special field gotoPreviousScene
-- If it's a function - call it, if it's a string - go back to the specified scene
if platform == 'Android' then
	Runtime:addEventListener('key', function(event)
		if event.phase == 'down' and event.keyName == 'back' then
			local scene = composer.getScene(composer.getSceneName('current'))
            if scene then
				if type(scene.gotoPreviousScene) == 'function' then
                	scene:gotoPreviousScene()
                	return true
				elseif type(scene.gotoPreviousScene) == 'string' then
					composer.gotoScene(scene.gotoPreviousScene, {time = 500, effect = 'slideRight'})
					return true
				end
            end
		end
	end)
end


-- Handling low memory issues
local function handleLowMemory( event )
  native.showAlert( "Space Dash is Awesome.\nBut Low Memory!",  "Please consider closing other applications.." , { "OK" }  );
end
Runtime:addEventListener( "memoryWarning", handleLowMemory )

-- load scene1
composer.gotoScene( "scenes.menu" )

-- Add any objects that should appear on all scenes below (e.g. tab bar, hud, etc)


