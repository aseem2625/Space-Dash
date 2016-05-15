local json = require( "json" )
local emittersManager = {}

emittersManager.init = function(filename, varianceScale, ifStart) 

    local group  = display.newGroup()
    local scale = display.contentScaleX

    -- Read the exported Particle Designer file (JSON) into a string
    local filePath = system.pathForFile( "assets/particles/" .. filename)
    local f = io.open( filePath, "r" )
    local fileData = f:read( "*a" )
    f:close()

    -- Decode the string
    local emitterParams = json.decode( fileData )

    -- Create the emitter with the decoded parameters
    local emitter = display.newEmitter( emitterParams)

    group:insert(1, emitter)

    group.xScale = scale;
    group.yScale = scale;

    emitter.startParticleSize = emitterParams.startParticleSize*scale;
    emitter.finishParticleSize = emitterParams.finishParticleSize*scale;
    emitter.startParticleSizeVariance = varianceScale*emitterParams.startParticleSizeVariance*scale;
    emitter.startParticleSizeVariance = varianceScale*emitterParams.finishParticleSizeVariance*scale;

    if not ifStart then
        emitter:stop()
    end
    return group
end

emittersManager.setPosition = function (opts)
    local scale = display.contentScaleX
    opts.emitterGroup[1].x = opts.x/scale
    opts.emitterGroup[1].y = opts.y/scale
end


return emittersManager