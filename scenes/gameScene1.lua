-------------------------------------------------------------------------------
--
-- <scene>.lua
--
-------------------------------------------------------------------------------

local sceneName = ...

local composer = require("composer")
local display = require("display")
local physics = require("physics")
local facebookShare = require("libs.facebookShare")
local widget = require( "widget" )
local json = require ("json") -- Require the JSON library for decoding purposes
-- local math = require("math")


-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )
-- Helper libraries
local perspective = require("libs.perspective") -- Code Exchange library to manage camera view
local scoreManager = require("libs.scoreManager")
local soundManager = require("libs.soundManager")
local emittersManager = require("libs.emittersManager")
local pauseDrawer = require("libs.pauseDrawer")
local coinAnimationInfo = require("classes.coinAnimation")
local menuSpritesInfo = require("classes.menuSprites")

-- Delate time: real time 1/frame rate
local dt = 1/60

-- Game Layers
local hero, background, coinParticleGroup, collisionBlastGroup, gameLayer, pauseButton

local effectsBtnOpt, musicBtnOpt

-- Game Objects
local coin
local radius
local circle1 = {}
local circle2 = {}
local vlinear1 = {}
local hlinear1 = {}
local hlinear2 = {}

-- local bottomBar, topBar, leftBar ,rightBar
-- local floor, left_wall, right_wall, ceiling

local camera

-- Time Remaining
local timeRemainingText = 40

-- Audio
local bgMusic, whooshEffect, collisionEffect, btnClickEffect
local musicVol= 0.7
local effectsVol = 0.8

local whooshDirection={x= 0 ,y= 0}
-------------------------------------------------------------------------------

-- -- Create walls
-- local function makeWalls () 
--     --make ceiling
--     ceiling = display.newRect(display.screenOriginX , display.screenOriginY-5, background.contentWidth, 30 )
--     ceiling.myname='ceiling'

--     -- make floor
--     floor = display.newRect(display.screenOriginX , display.screenOriginY + display.contentHeight+5, background.contentWidth, 30 )
--     floor.myname='floor'

--     -- make left wall
--     left_wall = display.newRect( display.screenOriginX-5, display.screenOriginY, 30, 2*background.contentHeight )
--     left_wall.myname='leftWall'

--     -- make right wall
--     right_wall = display.newRect(0.5*background.contentWidth - 0.2*display.contentWidth, display.screenOriginY, 30, 2*background.contentHeight )
--     right_wall.myname='leftWall'
-- end

-- -- Add physics to walls for bounce
-- local function addPhysicsToWalls ()
--     physics.addBody( ceiling, "static", {friction=0.5, bounce=0.8} )
--     physics.addBody( floor, "static", {friction=0.5, bounce=0.8} )
--     physics.addBody( left_wall, "static", {friction=0.5, bounce=0.8} )
--     physics.addBody( right_wall, "static", {friction=0.5, bounce=0.8} )    

-- end

-------------------------------------------------------------------------------

-- Adding physics to player
local function addPhysicsToPlayer ()
-- physics.addBody( hero, "dynamic", {density=1, friction=0.3, bounce=0.95, isSensor = true, radius=hero.contentWidth/2} )
-- physics.addBody( hero, "dynamic", { density=1, friction=0.3, bounce=0.7, radius= 0.4*hero.contentWidth } )
    physics.addBody( hero, "dynamic", { density=1, friction=0.3, bounce=0.7} )
    hero.linearDamping = 3
end

-------------------------------------------------------------------------------

-- NOT USED NOW
-- Alternate for ball bounce on collision with walls
-- local function generateWalls ()
--     bottomBar = display.newLine(0, display.contentHeight, background.contentWidth, display.contentHeight)
--     physics.addBody(bottomBar, "static", {isSensor = true})
--     bottomBar.myname='bottomBar'

--     topBar = display.newLine(0, 0, background.contentWidth, 0)
--     topBar.myname='topar'
--     physics.addBody(topBar, "static", {isSensor = true})

--     leftBar = display.newLine(0, 0, 0, display.contentHeight)
--     leftBar.myname='leftBar'
--     physics.addBody(leftBar, "static", {isSensor = true})

--     rightBar = display.newLine(background.contentWidth, 0, background.contentWidth, display.contentHeight)
--     rightBar.myname='rightBar'
--     physics.addBody(rightBar, "static", {isSensor = true})
-- end

-------------------------------------------------------------------------------

-- Attaching layers to the camera
local function setUpCamera()
    camera = perspective.createView()
    camera:setBounds( display.screenOriginX+display.contentWidth*0.4, background.contentWidth-display.contentWidth*0.8, display.contentHeight/2, display.contentHeight/2 ) -- used to keep our view from going outside the background

    camera:add(hero, 1) -- Player layer
    camera.damping = 10 -- A bit more fluid tracking

    -- self:setCameraOffset(display.contentWidth*0.3, 0)
    -- camera:setParallax(1,1)

    camera:add( coin, 1 )  -- Particles layer
    camera:add( coinParticleGroup, 2 )  -- Particles layer
    camera:add( collisionBlastGroup, 2 )
    -- camera:add( pauseButton, 2 )

    camera:add( gameLayer, 3 )  -- Game layer
    camera:add( background, 4 ) -- Background layer
end

-------------------------------------------------------------------------------

function scene:initializeAudio ()

    bgMusic = soundManager.loadAudio("bgmusic2.mp3")
    -- bgmusic2 = soundManager.loadAudio("bgmusic2.mp3")
    -- bgmusic3 = soundManager.loadAudio("bgmusic3.mp3")
    whooshEffect = soundManager.loadAudio("whoosh_effect.wav")
    collisionEffect = soundManager.loadAudio("collision_effect.wav")
    btnClickEffect = soundManager.loadAudio("btn_click.wav")

    -- local currentSoundChannel = audio.play( bgMusic, { channel=0, loops=-1, fadein=1500}  )    

end

scene.playLoadedSound = function (sound, loops, fadein, vol)
    local availableChannelForMusic = soundManager.getAvailableChannel()
    local soundOptions = {
        channel = availableChannelForMusic,
        loops = loops,
        fadein = fadein
    }
    soundManager.setVolume(vol, availableChannelForMusic)
    return soundManager.playAudio(sound, soundOptions )
    
    -- soundManager.setVolume(availableChannelForMusic, 0.3)
end

-------------------------------------------------------------------------------

-- Not being used now
local function panelOpened( target )
    -- if ( target.completeState ) then
    --     print("panel is opened")
    -- end
end

-------------------------------------------------------------------------------

local handleCloseBtnEvent = function(event)
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClickEffect, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        physics.start()
        scene.pausePanel:hide()
        -- audio.resume() -- resume all audio
        -- scene.closeDrawerButton.isVisible = false
    end    
end



function removeScreenCap()
    scene.screenCap:removeSelf()
    scene.screenCap = nil
end


-- Image Capture
local function captureWithDelay()

-- To Be used when user clicks photo click
    -- local capture = display.capture( camera, {saveToPhotoLibrary= true})
    -- facebookShare.printName(capture.name)
    -- capture:removeSelf()
    -- capture = nil
    -- local alert = native.showAlert( "Success", "Screen Capture Saved to Library", { "OK" } )

--  To be used AUTOMATICALLY when the game is over

    scene.screenCap.x = display.contentCenterX
    scene.screenCap.y = display.contentCenterY

    -- display.save( screenCap, { filename="WOW.jpg", baseDir=system.TemporaryDirectory}} )
    facebookShare.score = 50
    facebookShare.doFBLogin()

    timer.performWithDelay( 600000, removeScreenCap )
end

-------------------------------------------------------------------------------
function handleFacebookShareEvent()
    captureWithDelay()
end

-------------------------------------------------------------------------------

local handleReloadBtnEvent = function(event)    
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClickEffect, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        hero.x = display.screenOriginX + display.contentWidth*0.3
        physics.start()
        scene.pausePanel:hide()
        composer.gotoScene( "scenes.gameScene1", { effect = "fade", time = 300 } )
        -- audio.resume() -- resume all audio
        -- scene.closeDrawerButton.isVisible = false
    end    
end

-------------------------------------------------------------------------------

function handleGameOverEvent(type)
    scene.pausePanel:show()
    -- audio.pause() -- pause all audio

    --Taking screen shot for game over
    scene.screenCap = display.captureScreen()
    -- Scale the screen capture, now on the screen, to half its size
    scene.screenCap:scale( 0.4, 0.4 )
    display.save( scene.screenCap, { filename="WOW.jpg", baseDir=system.TemporaryDirectory } )

    physics.pause()
    if type ==1 then
        scene.pausePanel.title = display.newText( "GAME OVER!!!", 0, -display.contentHeight*0.3, "assets/fonts/trs-million-rg.ttf" or native.systemFontBold, 22 )
    elseif type ==2 then
        scene.pausePanel.title = display.newText( "oops.. TIME OVER!!", 0, -display.contentHeight*0.3, "assets/fonts/trs-million-rg.ttf" or native.systemFontBold, 22 )
    else
       scene.pausePanel.title = display.newText( "GAME PAUSED!!", 0, -display.contentHeight*0.3, "assets/fonts/trs-million-rg.ttf" or native.systemFontBold, 22 )        
    end
    scene.pausePanel.title:setFillColor( 1, 1, 1 )
    scene.pausePanel:insert(2, scene.pausePanel.title )

    scene.pausePanel:toFront()
end


local handlePauseBtnEvent = function(event)
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClickEffect, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        handleGameOverEvent(3)
    end

    -- pauseMyMusic()
end

-------------------------------------------------------------------------------

-- Function to handle button events
local function handleEffectsBtnEvent( event )
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClickEffect, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        _G.effectsSound = not _G.effectsSound   -- CHANGE EFFECTS VARIABLE
        if(_G.effectsSound) then
            scene.effectsButtonActive.isVisible = true
            scene.effectsButtonInactive.isVisible = false
        else
            scene.effectsButtonActive.isVisible = false
            scene.effectsButtonInactive.isVisible = true
        end

        scene.updateAudioOptions()
    end
end

-------------------------------------------------------------------------------

-- Function to handle button events
local function handleMusicBtnEvent( event )
    if "began" == event.phase then 
        scene.btnClickChannel = scene.playLoadedSound(btnClickEffect, 0, 0, effectsVol)
    elseif "ended" == event.phase then
        _G.musicSound = not _G.musicSound   -- CHANGE MUSIC VARIABLE
        if(_G.musicSound) then
            scene.musicButtonActive.isVisible = true
            scene.musicButtonInactive.isVisible = false           
        else
            scene.musicButtonActive.isVisible = false
            scene.musicButtonInactive.isVisible = true
        end
        scene.updateAudioOptions()
    end
end

-------------------------------------------------------------------------------



function scene:initializeParticles() 

    coinParticleGroup = emittersManager.init("coin2.json", 2, true)
    local emitterOpt = {
        emitterGroup = coinParticleGroup,
        x = coin.x,
        y = coin.y
    }    
    emittersManager.setPosition(emitterOpt)

    collisionBlastGroup = emittersManager.init("collision_blast.json", 2, false)
end


-------------------------------------------------------------------------------

scene.initializeAnimations = function (x, y)
    local myImageSheet = graphics.newImageSheet( "assets/graphics/coinAnimation.png", coinAnimationInfo:getSheet() )
    -- coin = display.newSprite( myImageSheet , {frames={coinAnimationInfo:getFrameIndex("coin_1")}} )

    local sequenceData = {
        {
        name="coinHovering",                          -- name of the animation
        width = 132,
        height = 132,
        sheet=myImageSheet,                           -- the image sheet
        start=coinAnimationInfo:getFrameIndex("coin_1"), -- first frame
        count=6,                                      -- number of frames
        time=8000,                                    -- speed
        loopCount=0,                                   -- repeat
        loopDirection = "forward"
        }
    }
    -- create sprite, set animation, play
    coin = display.newSprite( myImageSheet, sequenceData )
    coin:setSequence("coinHovering")


    local scale = display.contentScaleX
    coin:scale(1.5*scale, 1.5*scale)
    coin.x = x
    coin.y = y
    -- coin.timeScale = 20.0
    coin.timeScale = 10
    coin:play()
end


----------------------------------------
function scene.updateAudioOptions()
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
-----------------------------------------
function scene.initializeAudioOptions ()
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

    -- SET HERE VOLUME FOR ALL CHANNELS
    -- soundManager.setVolume(musicVol, scene.menuMusicChannel)
    -- soundManager.setVolume(effectsVol, scene.btnClickChannel)
end

-------------------------------------------------------------------------------

-- INITIALIZING POSITION OF LEVEL OBSTACLES
function scene:initializeObstaclePos () 

    -- CIRCLE: 1
    radius = circle1.path.contentWidth/2
    circle1.object.x = circle1.path.x + radius
    circle1.object.y = circle1.path.y
    circle1.theta =0

    -- CIRCLE: 2
    circle2.object.x = circle2.path.x
    circle2.object.y = circle2.path.y + radius
    circle2.theta =0

    -- VERTICAL LINEAR: 1
    local vheight = vlinear1.path.contentHeight
    vlinear1.length = vheight
    vlinear1.object.x = vlinear1.path.x
    vlinear1.object.y = vlinear1.path.y + vheight/6
    vlinear1.motionDir = 1

    -- HORIZONTAL LINEAR: 1
    local hlength = hlinear1.path.contentWidth
    hlinear1.length = hlength
    hlinear1.object.x = hlinear1.path.x
    hlinear1.object.y = hlinear1.path.y
    hlinear1.motionDir = 1

    -- HORIZONTAL LINEAR: 1
    hlinear2length = hlength
    hlinear2.object.x = hlinear2.path.x
    hlinear2.object.y = hlinear2.path.y
    hlinear2.motionDir = -1

end

function scene:setUpPauseDrawer()
    scene.pausePanel = pauseDrawer.newPanel{
        location = "top",
        onComplete = panelOpened,
        width = display.contentWidth * 0.8,
        height = display.contentHeight * 0.8,
        speed = 250,
        inEasing = easing.outBack,
        outEasing = easing.outCubic
    }
    scene.pausePanel.background = display.newRect( 0, 0, scene.pausePanel.width, scene.pausePanel.height )
    scene.pausePanel.background:setFillColor( 0, 0.25, 0.5 )
    scene.pausePanel:insert( scene.pausePanel.background )

    scene.pausePanel:hide()

    scene.closeDrawerButton = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/play_btn.png",
            overFile = "assets/graphics/unoptimized_btns/play_btn_pressed.png",
            label = "",
            onEvent = handleCloseBtnEvent
        })

    scene.closeDrawerButton.isVisible = true
    scene.pausePanel:insert( scene.closeDrawerButton)
    scene.closeDrawerButton.x = scene.closeDrawerButton.x - scene.closeDrawerButton.contentWidth/2

    scene.reloadDrawerButton = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/reload_btn.png",
            overFile = "assets/graphics/unoptimized_btns/reload_btn.png",
            label = "",
            onEvent = handleReloadBtnEvent
        })

    scene.reloadDrawerButton.isVisible = true
    scene.pausePanel:insert( scene.reloadDrawerButton)
    scene.reloadDrawerButton.x = scene.closeDrawerButton.x - 1.2*scene.reloadDrawerButton.contentWidth
    scene.reloadDrawerButton.y = scene.closeDrawerButton.y + 1.2*scene.reloadDrawerButton.contentHeight

    scene.facebookShareDrawerButton = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/facebook_share_btn.png",
            overFile = "assets/graphics/unoptimized_btns/facebook_share_btn.png",
            label = "",
            onEvent = handleFacebookShareEvent
    })


    scene.facebookShareDrawerButton.isVisible = true
    scene.pausePanel:insert( scene.facebookShareDrawerButton)
    scene.facebookShareDrawerButton.x = scene.closeDrawerButton.x + 1.2*scene.facebookShareDrawerButton.contentWidth
    scene.facebookShareDrawerButton.y = scene.closeDrawerButton.y + 1.2*scene.reloadDrawerButton.contentHeight



    scene.effectsButtonActive = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/effects_btn_active.png",
            overFile = "assets/graphics/unoptimized_btns/effects_btn_active_pressed.png",
            label = "",
            onEvent = handleEffectsBtnEvent
        })

    scene.pausePanel:insert( scene.effectsButtonActive)
    scene.effectsButtonActive.x = scene.closeDrawerButton.x - 2*scene.effectsButtonActive.contentWidth

    scene.effectsButtonInactive = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/effects_btn_inactive.png",
            overFile = "assets/graphics/unoptimized_btns/effects_btn_inactive_pressed.png",
            label = "",
            onEvent = handleEffectsBtnEvent
        })

    scene.pausePanel:insert( scene.effectsButtonInactive)
    scene.effectsButtonInactive.x = scene.closeDrawerButton.x - 2*scene.effectsButtonInactive.contentWidth


    if _G.effectsSound then
     scene.effectsButtonActive.isVisible = true
     scene.effectsButtonInactive.isVisible = false
    else 
     scene.effectsButtonActive.isVisible = false
     scene.effectsButtonInactive.isVisible = true
    end        




    scene.musicButtonActive = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/music_btn_active.png",
            overFile = "assets/graphics/unoptimized_btns/music_btn_active_pressed.png",
            label = "",
            onEvent = handleMusicBtnEvent
        })

    scene.pausePanel:insert( scene.musicButtonActive)
    scene.musicButtonActive.x = scene.closeDrawerButton.x + 2*scene.musicButtonActive.contentWidth

    scene.musicButtonInactive = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/unoptimized_btns/music_btn_inactive.png",
            overFile = "assets/graphics/unoptimized_btns/music_btn_inactive_pressed.png",
            label = "",
            onEvent = handleMusicBtnEvent
        })

    scene.pausePanel:insert( scene.musicButtonInactive)
    scene.musicButtonInactive.x = scene.closeDrawerButton.x + 2*scene.musicButtonInactive.contentWidth


    if _G.musicSound then
        scene.musicButtonActive.isVisible = true
        scene.musicButtonInactive.isVisible = false
    else
        scene.musicButtonActive.isVisible = false
        scene.musicButtonInactive.isVisible = true
    end

end


function scene:create( event )
    local sceneGroup = self.view
    physics.start( )

    --SPAWNING PLAYER
    hero = self:getObjectByName( "player" )
    hero.myname='hero'
    sceneGroup:insert(hero)
    addPhysicsToPlayer()
    -- facebookShare.printName("Testing facebookShare file")

    -- hero = display.newCircle(100, 40, 10)
    -- hero.x = display.screenOriginX + 20
    -- hero.y = display.screenOriginY/2 

    -- SETTING UP BACKGROUND
    background = self:getObjectByName( "background" )
    background.y = display.contentHeight/2

    -- SETTING UP GAME LAYER GROUP
    gameLayer = self:getObjectByName( "gameLayer" )
    -- coin = self:getObjectByName("coin")

    -- SPAWNING CIRCLE 1
    circle1.object = self:getObjectByName("circular_obs_a")
    circle1.path = self:getObjectByName("circular_path_a")

    -- SPAWNING CIRCLE 2
    circle2.object = self:getObjectByName("circular_obs_b")
    circle2.path = self:getObjectByName("circular_path_b")

    -- SPAWNING VERTICLE LINEAR 1
    vlinear1.object = self:getObjectByName("vertical_line_obs")
    vlinear1.path = self:getObjectByName("vertical_line")

    -- SPAWNING HORIZONTAL LINEAR TOP
    hlinear1.object = self:getObjectByName("horizontal_obs_top")
    hlinear1.path = self:getObjectByName("horizontal_line_top")

    -- SPAWNING HORIZONTAL LINEAR BOTTOM
    hlinear2.object = self:getObjectByName("horizontal_obs_bottom")
    hlinear2.path = self:getObjectByName("horizontal_line_bottom")

    scene.initializeObstaclePos()
    scene.initializeAnimations(circle2.object.x, circle2.object.y-radius)

    -- INITIALIZE ALL PARTICLES IN SCENE
    scene.initializeParticles()

    -- circle1.y = circle1_path.y+ radius

    -- NOT USED NOW
    -- makeWalls()
    -- addPhysicsToWalls()

    -- NOT USED NOW
    -- generateWalls()

    scene.menuImageSheet = graphics.newImageSheet( "assets/graphics/menuSprites.png", menuSpritesInfo:getSheet() )

    pauseButton = widget.newButton({
            width = 50,
            height = 50,
            defaultFile = "assets/graphics/pause_btn.png",
            overFile = "assets/graphics/pause_btn_pressed.png",
            label = "",
            onEvent = handlePauseBtnEvent
        })

    pauseButton.x = display.screenOriginX + pauseButton.contentWidth
    pauseButton.y = display.screenOriginY + pauseButton.contentHeight


    setUpCamera() --Setup Camera

    -- GRAVITY AND DEBUG
    -- physics.setGravity( 0, 7 )
    -- physics.setDrawMode( "hybrid" )

    -- TIME LEFT LABEL
    local options = 
    {
        --parent = textGroup,
        text = "Time Left: ",     
        x = display.screenOriginX+120,
        y = display.screenOriginY+24,
        font = "assets/fonts/halo.ttf" or native.systemFontBold,   
        fontSize = 18,
    }
    local timeLeftLabel = display.newText( options )
    timeLeftLabel:setFillColor( 1, 0.2, 0.2, 1 )


    local optionsTimeLeft = {
       x = timeLeftLabel.x + timeLeftLabel.contentWidth/2 ,
       y = display.screenOriginY + 26,
       fontSize = 24,
       font = "assets/fonts/digital-7.ttf"
    }
    -- SET UP SCORE
    timeRemainingOptions = scoreManager.init(optionsTimeLeft)



    -- Testing ScoreManager Functions
    if scoreManager.load() then 
        print("WHOLLALA" .. scoreManager.load())
    end
    scoreManager.setScore( timeRemainingText )
    -- scoreManager.addInScore(2333)
    print("LATEST Score is" .. scoreManager.getScore())
    scoreManager.save()

    scene.initializeAudio()

    -- INITIALIZING AUDIO OPTIONS
    scene.initializeAudioOptions()

    scene.bgMusicChannel = scene.playLoadedSound(bgMusic, -1, 1500, musicVol)
    -- scene.bgchannel2 = scene.playLoadedSound(bgmusic2, -1, 1500, musicVol)
    -- scene.bgchannel3 = scene.playLoadedSound(bgmusic3, -1, 1500, musicVol)
    
    -- START BG MUSIC
    -- startBGM()

    -- soundManager.playAudio("bgMusic.mp3", 0.8)


    -- local highscore = score.load()

    -- Called when the scene's view does not exist
    -- 
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        -- Called when the scene is off screen and is about to move on screen
        pauseButton:toFront()
        scene.setUpPauseDrawer()

    elseif phase == "did" then
        -- Called when the scene is now on screen
        -- 
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc
    end 
end

function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        -- Called when the scene is on screen and is about to move off screen
        --
        -- INSERT code here to pause the scene
        -- e.g. stop timers, stop animation, unload sounds, etc.)
    elseif phase == "did" then
        -- Called when the scene is now off screen
    end 
end


function scene:destroy( event )
    local sceneGroup = self.view

    -- Cleaning up listener
    scene:removeEventListener( "accelerometer", heroMovex)
    scene:removeEventListener( "collision", sensorMeCollide )
    scene:removeEventListener("touch", moveMyPlayer)

    -- Removing sounds that areen't used in other scenes
    audio.dispose( bgMusic )
    bgMusic = nil  --prevents the handle from being used again


    -- Called prior to the removal of scene's "view" (sceneGroup)
    -- 
    -- INSERT code here to cleanup the scene
    -- e.g. remove display objects, remove touch listeners, save state, etc
end

-------------------------------------------------------------------------------

-- Video completion listener
local function onVideoComplete ( event )
    print( "video session ended with duratoin:")
end


-- Capture completion listener
local function onComplete( event )
    if event.completed then
        media.playVideo( event.url, media.RemoteSource, true, onVideoComplete )
        print( event.duration )
        print( event.fileSize )
    end
end

local function captureGameVideo()
    if media.hasSource( media.Camera ) then
        media.captureVideo( { listener=onComplete } )
    else
        native.showAlert( "Corona", "This device does not have a camera.", { "OK" } )
    end
end


-- timer.performWithDelay( 2000, captureGameVideo )
-- timer.performWithDelay( 4000, onVideoComplete )

-- TODO on button click or collision
-- timer.performWithDelay( 4000, captureWithDelay )

-------------------------------------------------------------------------------

--Set accelerometer framerate
system.setAccelerometerInterval( 60 )

 -- PLAYER MOVEMENT: ACCELEROMETER
local function heroMovex( event )
    -- if hero.x <= background.contentWidth and hero.x >=0 and hero.y <= display.contentHeight and hero.y >=0 then
        -- hero.x = hero.x + 10;
        -- Axis are landscaped

        local lastXwhooshDirection = whooshDirection.x
        local lastYwhooshDirection = whooshDirection.y

        if event.xGravity < 0 then 
            whooshDirection.x = 1
        else 
            whooshDirection.x = -1
        end

        if event.yGravity < 0 then 
            whooshDirection.y = 1
        else 
            whooshDirection.y = -1
        end

        if lastXwhooshDirection ~= whooshDirection.x then
            scene.whooshChannel = scene.playLoadedSound(whooshEffect, 0, 0, effectsVol)
        end

        if lastYwhooshDirection ~= whooshDirection.y then
            scene.whooshChannel = scene.playLoadedSound(whooshEffect, 0, 0, effectsVol)
        end


        -- hero:setLinearVelocity( 50*dt*xOffset, 50*dt*yOffset)
        

        hero.x = hero.x + event.yGravity*dt*-1500
        hero.y = hero.y + event.xGravity*dt*-1500
        -- player.x = display.contentCenterX - zdisplay.contentCenterX * (event.yGravity * 3))
        -- hero:setLinearVelocity( 20 * event.xGravity, 20* event.yGravity )
    -- end
end

-------------------------------------------------------------------------------

-- Collision logic

-- Sensor detection
local function sensorMeCollide ( event )
    if( event.phase == "began" ) then
        scene.collisionEffect = scene.playLoadedSound(collisionEffect, 0, 0, effectsVol)


        local emitterOpt = {
            emitterGroup = collisionBlastGroup,
            x = event.object2.x,
            y = event.object2.y
        }    
        collisionBlastGroup[1]:start()
        emittersManager.setPosition(emitterOpt)

        handleGameOverEvent(2)
        return true
    end
end


-- Bounce detection
-- TODO

-------------------------------------------------------------------------------
-- Extra Gimmicks

-- Rotating the player
local sign = -1
local function setCoinContinuousRotation()
    if coin then
        if sign > 0 then
            hero.rotation = hero.rotation + 4
        else 
            hero.rotation = hero.rotation - 4
        end

        coin.rotation = coin.rotation + 2
    end
end

-- Moving players eyes in the directin of motion
-- TODO

-------------------------------------------------------------------------------

-- Touch Listener for accelerometer alternative for simulator testing
function moveMyPlayer( event )
    if event.phase == "began" then
        -- print( "Touch x:" .. event.x)
        -- print( "Touch y:" .. event.y )
        -- print("Player Location" .. hero.x-display.contentWidth*math.floor(hero.x/display.contentWidth))
        -- if hero.x <= background.contentWidth and hero.x >=0 and hero.y <= display.contentHeight and hero.y >=0 then
            -- hero.x = hero.x + 10; 
            -- hero.x = hero.x + (event.x-hero.x)
            -- hero.y = hero.y + (event.y - hero.y)

            -- local xOffset = event.x - (hero.x -display.contentWidth*math.floor(hero.x/display.contentWidth))
            -- local yOffset = event.y-hero.y
            -- print(xOffset)
            -- print(yOffset)

            local whatx, whaty
            -- print("CONTENT WIDTH"..display.contentWidth/display.contentScaleX)
            -- print(display.contentHeight/display.contentScaleY)
            local offsetX =  (hero.x - display.screenOriginX) % (display.contentWidth/display.contentScaleX)
            local offsetY =  (hero.y - display.screenOriginY) % (display.contentHeight/display.contentScaleY)

            if event.x/display.contentScaleX > offsetX then
                whatx = 1
            else
                whatx = -1
            end
            if event.y/display.contentScaleY  > offsetY then
                whaty = 1
            else
                whaty = -1
            end
            local vx =  math.abs(offsetX-event.x)*dt/display.contentScaleX
            if vx > 30 then
                vx = 30
            end
            -- local vy =15*math.abs(offsetY-event.y)*dt*whaty/display.contentScaleY
            -- hero:setLinearVelocity(vx*0.5*whatx, 0 )
            hero:applyLinearImpulse( whatx*vx, 0)
            -- transition.to(hero,{x= hero.x+xOffset, y = hero.y + yOffset})

            if whatx > 0 then
                sign = 1
            else 
                sign = -1
            end
            -- hero:setLinearVelocity( 200 * event.xGravity, 200* event.yGravity )
        -- else 
            -- hero:setLinearVelocity( 0, 0 )
        -- end
    end
    return true
end 



-- CAMERA TRACKING HERO
local function trackHero( event )
    -- if hero.x <= background.contentWidth then
    --     hero.x = hero.x + 10; 
    -- end

    if hero.x > display.contentWidth*0.3 and hero.x < background.contentWidth then
        -- camera.x = hero.x
        camera:setFocus(hero) -- Set the focus to the penguin so it tracks it
        camera:track(hero)
    end
end

local function revoluteCircle(body, direction, speed, confusionFactor)

    if body.theta > 0 and body.theta < 3.14 then
        speed = speed + 0.8*confusionFactor*speed
    else
        speed = speed
    end

    body.theta = body.theta + (speed)*dt
    if(body.theta >=3.14*2) then
        body.theta = body.theta % 3.14*2
    end
    body.object.x = radius* math.cos( direction*body.theta ) + body.path.x
    body.object.y = radius* math.sin( direction*body.theta ) + body.path.y
end

local function vlinearDance(body, speed, confusionFactor)
    local factor = confusionFactor*math.abs(body.object.y-body.path.y)
    speed = speed + factor

    local nextY = body.object.y + body.motionDir*speed*dt
    local limitExceed

    if(body.motionDir == 1) then --GOING DOWN
        limitExceed = nextY + body.object.contentHeight/2 >= body.path.y + body.path.contentHeight/2
    elseif(body.motionDir == -1) then --GOING UP
        limitExceed = nextY - body.object.contentHeight/2 <= body.path.y - body.path.contentHeight/2
    end

    if limitExceed then
        body.motionDir = -1 * body.motionDir
    end
    nextY = body.object.y + body.motionDir*speed*dt
    body.object.y = nextY
end

local function hlinearDance(body, speed, confusionFactor)
    local factor = confusionFactor*math.abs(body.object.x-body.path.x)
    speed = speed + factor

    local nextX = body.object.x + body.motionDir*speed*dt
    local limitExceed

    if(body.motionDir == 1) then --GOING RIGHT
        limitExceed = nextX + body.object.contentWidth/2 >= body.path.x + body.path.contentWidth/2
    elseif(body.motionDir == -1) then --GOING LEFT
        limitExceed = nextX - body.object.contentWidth/2 <= body.path.x - body.path.contentWidth/2
    end

    if limitExceed then
        body.motionDir = -1 * body.motionDir
    end
    nextX = body.object.x + body.motionDir*speed*dt
    body.object.x = nextX
end

resetHeroPosition = function()
    hero.x = display.screenOriginX + display.contentWidth/5
    hero.y = display.screenOriginY + display.contentHeight/2
end

-- GAME LOOP: 60fps
local function gameLoop(event)
    dt = 1/display.fps
    setCoinContinuousRotation()
    trackHero(event)

    revoluteCircle(circle1, 1, 6, 0)
    revoluteCircle(circle2, -1, 5, 3)

    vlinearDance(vlinear1, 400, 5)
    hlinearDance(hlinear1, 300 , 1)
    hlinearDance(hlinear2, 500, 3)

    -- Out of bounds handling
    local xScreenLimit = hero.x > display.screenOriginX+2*background.contentWidth or hero.x < display.screenOriginX - 2*background.contentWidth
    local yScreenLimit = hero.y < display.screenOriginY - 2*display.contentHeight or hero.y > display.screenOriginY + 2*display.contentHeight
    if xScreenLimit or yScreenLimit then 
        resetHeroPosition()
    end
end


timeCounter = function() 
    timeRemainingText = timeRemainingText - 1
    if timeRemainingText <=0 then 
        timer.cancel( timerLeft )
        handleGameOverEvent(1)
    end
    scoreManager.setScore( timeRemainingText )
end

-------------------------------------------------------------------------------

timerLeft = timer.performWithDelay( 1000, timeCounter, -1 )  -- wait 2 seconds

-------------------------------------------------------------------------------

-- LISTENER SETUP
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener( "accelerometer", heroMovex)
Runtime:addEventListener( "collision", sensorMeCollide )
Runtime:addEventListener("touch", moveMyPlayer)
Runtime:addEventListener( 'enterFrame', gameLoop ) -- Game Loop Listener


-------------------------------------------------------------------------------

return scene
