---------------------------------------------------------------------------------
--
-- scene.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local widget = require( "widget" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )
-- local menuHeroAnimationInfo = require("classes.menuHeroAnimation")
local menuSpritesInfo = require("classes.menuSprites")
local soundManager = require("libs.soundManager")
local scoreManager = require("libs.scoreManager")

local hero, playButton, effectsButtonInactive, effectsButtonActive, musicButtonActive, musicButtonInactive 

-- Audio
local menuMusic, btnClick

local musicVol = 0.8
local effectsVol = 0.8

_G.effectsSound = true
_G.musicSound = true

---------------------------------------------------------------------------------

scene.initializeAnimations = function (x, y)

    local sequenceData = {
        {
        name="herohovering",                          -- name of the animation
        width = 66,
        height = 66,
        sheet=scene.menuImageSheet,                           -- the image sheet
        -- start=menuHeroAnimationInfo:getFrameIndex("menu_hero_1"), -- first frame
        frames = { 5,7,8,9,10,11,12,13,14,6},
        -- count=10,                                      -- number of frames
        time=2000,                                    -- speed
        loopCount=0,                                   -- repeat
        loopDirection = "forward"
        }
    }
    -- create sprite, set animation, play
    hero = display.newSprite( scene.menuImageSheet, sequenceData )
    hero:setSequence("playerAnim")


    local scale = display.contentScaleX
    hero:scale(0.8*scale, 0.8*scale)
    hero.x = x
    hero.y = y
    
end


---------------------------------------------------------------------------------

scene.playLoadedSound = function (sound, loops, fadein, vol)
    local availableChannelForMusic = soundManager.getAvailableChannel()
    local soundOptions = {
        channel = availableChannelForMusic,
        loops = loops,
        fadein = fadein
    }
    soundManager.setVolume(vol, availableChannelForMusic)
    return soundManager.playAudio(sound, soundOptions )
end


scene.updateAudioOptions = function()
    if not _G.musicSound then
        musicVol = 0
    else 
        musicVol = 0.7
    end

    if not _G.effectsSound then
        effectsVol = 0
    else 
        effectsVol = 0.7
    end

    soundManager.setVolume(musicVol, scene.menuMusicChannel)
    soundManager.setVolume(effectsVol, scene.btnClickChannel)

end


---------------------------------------------------------------------------------

-- Function to handle button events
local function handlePlayBtnEvent( event )
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClick, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        composer.gotoScene( "scenes.gameScene1", { effect = "fade", time = 300 } )
    end
end

-- Function to handle button events
local function handleEffectsBtnEvent( event )
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClick, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        _G.effectsSound = not _G.effectsSound   -- CHANGE EFFECTS VARIABLE
        if(_G.effectsSound) then
            effectsButtonActive.isVisible = true
            effectsButtonInactive.isVisible = false
        else
            effectsButtonActive.isVisible = false
            effectsButtonInactive.isVisible = true
        end

        scene.updateAudioOptions()
    end
end

-------------------------------------------------------------------------------

-- Function to handle button events
local function handleMusicBtnEvent( event )
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClick, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        _G.musicSound = not _G.musicSound   -- CHANGE MUSIC VARIABLE
        if(_G.musicSound) then
            musicButtonActive.isVisible = true
            musicButtonInactive.isVisible = false           
        else
            musicButtonActive.isVisible = false
            musicButtonInactive.isVisible = true
        end

        scene.updateAudioOptions()
    end
end

-------------------------------------------------------------------------------

function scene:setUpButtons () 
        playButton = widget.newButton(
            {
                sheet = scene.menuImageSheet,
                defaultFrame = menuSpritesInfo:getFrameIndex("play_button_active"),
                overFrame = menuSpritesInfo:getFrameIndex("play_button_active_pressed"),
                label = "",
                onEvent = handlePlayBtnEvent
            }
        )
        local sheet = menuSpritesInfo:getSheet()
        playButton.widthScale = 140/sheet.frames[19].width
        playButton.heightScale = 45/sheet.frames[19].height

        playButton:scale(playButton.widthScale, playButton.heightScale)
        -- playButton2.scale(140/sheet.frames[menuSpritesInfo:getFrameIndex("play_button_active")].width, 45/sheet.frames[menuSpritesInfo:getFrameIndex("play_button_active")].height)
        playButton.x = display.actualContentWidth - playButton.contentWidth
        playButton.y = display.actualContentHeight - playButton.contentHeight


        -- playButton = widget.newButton(
        --     {
        --         width = 140,
        --         height = 45,
        --         defaultFile = "assets/graphics/play_button_active.png",
        --         overFile = "assets/graphics/play_button_active_pressed.png",
        --         label = "",
        --         onEvent = handlePlayBtnEvent
        --     }
        -- )


        -- playButton.x = display.actualContentWidth - playButton.contentWidth
        -- playButton.y = display.actualContentHeight - playButton.contentHeight

        local effectsBtnOpt = {
                sheet = scene.menuImageSheet,
                label = "",
                onEvent = handleEffectsBtnEvent
            }
        effectsBtnOpt.defaultFrame = menuSpritesInfo:getFrameIndex("effects_btn_active")
        effectsBtnOpt.overFrame = menuSpritesInfo:getFrameIndex("effects_btn_active_pressed")
        effectsButtonActive = widget.newButton(effectsBtnOpt)
        effectsButtonActive.isVisible = true
        effectsButtonActive.widthScale = 50/sheet.frames[1].width
        effectsButtonActive.heightScale = 50/sheet.frames[1].height        
        effectsButtonActive:scale(effectsButtonActive.widthScale, effectsButtonActive.heightScale)
        effectsButtonActive.x = display.screenOriginX + effectsButtonActive.contentWidth
        effectsButtonActive.y = display.actualContentHeight - effectsButtonActive.contentHeight


        effectsBtnOpt.defaultFrame = menuSpritesInfo:getFrameIndex("effects_btn_inactive")
        effectsBtnOpt.overFrame = menuSpritesInfo:getFrameIndex("effects_btn_inactive_pressed")
        effectsButtonInactive = widget.newButton(effectsBtnOpt)
        effectsButtonInactive.isVisible = false
        effectsButtonInactive.widthScale = 50/sheet.frames[1].width
        effectsButtonInactive.heightScale = 50/sheet.frames[1].height        
        effectsButtonInactive:scale(effectsButtonInactive.widthScale, effectsButtonInactive.heightScale)
        effectsButtonInactive.x = display.screenOriginX + effectsButtonInactive.contentWidth
        effectsButtonInactive.y = display.actualContentHeight - effectsButtonInactive.contentHeight


        local musicBtnOpt = {
                sheet = scene.menuImageSheet,
                label = "",
                onEvent = handleMusicBtnEvent
            }
        musicBtnOpt.defaultFrame = menuSpritesInfo:getFrameIndex("music_btn_active")
        musicBtnOpt.overFrame = menuSpritesInfo:getFrameIndex("music_btn_active_pressed")
        musicButtonActive = widget.newButton(musicBtnOpt)
        musicButtonActive.isVisible = true
        musicButtonActive.widthScale = 50/sheet.frames[15].width
        musicButtonActive.heightScale = 50/sheet.frames[15].height        
        musicButtonActive:scale(musicButtonActive.widthScale, musicButtonActive.heightScale)
        musicButtonActive.x = effectsButtonActive.x + 1.5* musicButtonActive.contentWidth
        musicButtonActive.y = display.actualContentHeight - musicButtonActive.contentHeight


        musicBtnOpt.defaultFrame = menuSpritesInfo:getFrameIndex("music_btn_inactive")
        musicBtnOpt.overFrame = menuSpritesInfo:getFrameIndex("music_btn_inactive_pressed")
        musicButtonInactive = widget.newButton(musicBtnOpt)
        musicButtonInactive.isVisible = false
        musicButtonInactive.widthScale = 50/sheet.frames[15].width
        musicButtonInactive.heightScale = 50/sheet.frames[15].height        
        musicButtonInactive:scale(musicButtonInactive.widthScale, musicButtonInactive.heightScale)
        musicButtonInactive.x = effectsButtonActive.x + 1.5* musicButtonInactive.contentWidth
        musicButtonInactive.y = display.actualContentHeight - musicButtonInactive.contentHeight

end
---------------------------------------------------------------------------------

local nextSceneButton

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

    -- INITIALIZING SCENE
    scene.menuImageSheet = graphics.newImageSheet( "assets/graphics/menuSprites.png", menuSpritesInfo:getSheet() )
    scene.setUpButtons()
    scene.highestScoreLabel = self:getObjectByName( "highestscore_label" )

    scene.initializeAnimations(display.contentWidth/2, display.contentHeight/3)

    -- Load Audio
    menuMusic = soundManager.loadAudio("menu_music.mp3")
    btnClick = soundManager.loadAudio("btn_click.wav")


    local highestScoreOpt = {
       x = scene.highestScoreLabel.x + scene.highestScoreLabel.contentWidth/2 + 20,
       y = scene.highestScoreLabel.y,
       fontSize = 24,
       font = "assets/fonts/digital-7.ttf"
    }
    -- SET UP SCORE
    scene.highestScore = scoreManager.init(highestScoreOpt)
    scene.highestScore:setFillColor( 0.3, 0.4, 1, 1 )
    scene.highestScore = scoreManager.load()

end

-------------------------------------------------------------------------------

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is still off screen and is about to move on screen
        if scene.highestScore then
            scoreManager.setScore( scene.highestScore )
        else 
            scoreManager.setScore( 0 )  --First Time play: Initializing the game with score 0
            scoreManager.save() -- Saving the score
        end

    elseif phase == "did" then
        hero:play() -- Hero sprite animation
        scene.moveUp()  -- Hero animation
        scene:scaleUp() -- Play button animation
        scene.menuMusicChannel = scene.playLoadedSound(menuMusic, -1, 1500, musicVol)   -- Start BG Music
    end 
end

-------------------------------------------------------------------------------

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        transition.cancel(scene.moveUpTransition)
        transition.cancel(scene.moveDownTransition)
        transition.cancel(scene.scaleUpTransition)
        transition.cancel(scene.scaleDownTransition)
    
        audio.stop( scene.menuMusicChannel )
        audio.stop( scene.btnClickChannel  )

        hero:pause()
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
end

-------------------------------------------------------------------------------

function scene:destroy( event )

    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc

    local sceneGroup = self.view

    -- Removing Audio not being used further
    audio.dispose( menuMusic )
    menuMusic = nil

    audio.dispose( btnClick )
    btnClick = nil

    -- Removing all objects
    display:remove(scene.menuImageSheet)
    hero:removeSelf() 
    playButton:removeSelf()
    effectsButtonInactive:removeSelf()
    effectsButtonActive:removeSelf()
    musicButtonActive:removeSelf()
    musicButtonInactive:removeSelf()
    
    scene.menuImageSheet = nil
    hero = nil 
    playButton = nil 
    effectsButtonInactive = nil 
    effectsButtonActive = nil 
    musicButtonActive = nil 
    musicButtonInactive = nil   

end

-------------------------------------------------------------------------------

function scene:scaleUp()
    local scaleOption = {
        yScale = 1.05*playButton.heightScale,
        xScale=  1.05*playButton.widthScale,
        time = 1000,
        onComplete = scene.scaleDown
    }
    scene.scaleUpTransition = transition.scaleTo( playButton, scaleOption )
end

function scene:scaleDown()
    local scaleOption = {
        yScale = 0.95*playButton.heightScale,
        xScale=  0.95*playButton.widthScale,
        time = 1000,
        onComplete = scene.scaleUp
    }
    scene.scaleDownTransition = transition.scaleTo( playButton, scaleOption )
end

-------------------------------------------------------------------------------

function scene:moveDown()
    local scaleOption = {
        y = 20,
        x=  0,
        time = 1000,
        onComplete = scene.moveUp
    }
    scene.moveUpTransition = transition.moveBy( hero, scaleOption )
end

function scene:moveUp()
    local scaleOption = {
        y = -20,
        x =  0,
        time= 1000,
        onComplete = scene.moveDown
    }
    scene.moveDownTransition = transition.moveBy( hero, scaleOption )
end


---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
