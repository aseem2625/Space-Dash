local soundManager = {}


soundManager.getAvailableChannel = function()
    local availableChannel = audio.findFreeChannel()
    return availableChannel	
end

soundManager.playAudio = function(musicOrEffect, opt)
    --set loops = -1 to loop infinitely
    local currentSoundChannel = audio.play( musicOrEffect, { channel=opt.channel, loops=opt.loops, fadein=opt.fadein}  )	
    return currentSoundChannel
end

soundManager.loadAudio = function(soundName)
	local soundPath = "assets/audio/" .. soundName
    -- BG audio stream
    local music = audio.loadStream(soundPath)
    return music
end

soundManager.loadEffect = function(effectName)
	-- local effect = audio.loadSound( audiofileName [, baseDir ] )
	-- return effect
end
soundManager.setVolume = function(vol, channel)
	audio.setVolume( vol, { channel=channel } );
end

soundManager.pauseSound = function(channel)
	audio.pause( channel )
end

return soundManager