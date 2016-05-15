-- local facebook = require( "plugin.facebook.v4" )
local facebook = require( "facebook" )

-- Aseem Gupta
--This is my API key is must to post on facebook. Since the game is in development mode, so not sure if you can see posts
-- done by your account, hence only developers can see if posted through their account.
local fbAppID = "180727338992699"

local facebookShare = {}
facebookShare.score = 0

facebookShare.printName = function( name )
	print ("Check if file Works.. Aseem" ..name) -- name should be Gupta... Otherwise it won't work.. LOL.. just kidding
end

facebookShare.onLoginSuccess = function()
    -- Upload 'iheartcorona.jpg' to current user's account
    local attachment = {
        message = "OMG :D 3:) , I just got spiked at the score " .. facebookShare.score .. ". \n Geometric Fun Slide is awesome game..",
        source = { baseDir=system.TemporaryDirectory, filename="WOW.jpg", type="image" }
    }
    
    facebook.request( "me/photos", "POST", attachment )
end

-- facebook listener
facebookShare.fbListener = function(event )
    if event.isError then
        native.showAlert( "ERROR", event.response, { "OK" } )
    else
        if event.type == "session" and event.phase == "login" then
            -- login was a success; call function
            facebookShare.onLoginSuccess()
        
        elseif event.type == "request" then
            -- this block is executed upon successful facebook.request() call
            native.showAlert( "Success", "The photo has been uploaded.", { "OK" } )
            -- Here we can remove that image
        end
    end
end


facebookShare.doFBLogin = function()
	-- photo uploading requires the "publish_stream" permission
	-- if facebook.isActive then
	facebook.login( fbAppID, facebookShare.fbListener, { "publish_actions" } )
	-- end
end


return facebookShare
