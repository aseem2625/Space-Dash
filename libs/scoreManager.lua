local scoreManager = {}
scoreManager.score = 0


function scoreManager.init( options )
   local opt = {}
   opt.fontSize = options.fontSize
   opt.font = "arial bold" or native.systemFontBold 
   opt.x = options.x -- or display.contentCenterX
   opt.y = options.y -- or opt.fontSize*0.5
   opt.maxDigits = 6
   opt.leadingZeros = false
   opt.align = options.align
   scoreManager.filename = "scorefile.txt"
 
   local prefix = ""
   if ( opt.leadingZeros ) then 
      prefix = "0"
   end
   scoreManager.format = "%" .. prefix .. opt.maxDigits .. "d"
   
   scoreManager.scoreText = display.newText({
      format = string.format(scoreManager.format, 0),
      text = "0",
      x = opt.x, 
      y = opt.y, 
      font = opt.font, 
      fontSize = opt.fontSize,
      
    })
   -- scoreManager.scoreText:setFillColor( 0.9, 0.9, 0.2, 1 )
   scoreManager.scoreText:setFillColor( 1, 0.2, 0.2, 1 )
   return scoreManager.scoreText
end


function scoreManager.setScore( value )
   scoreManager.score = value
   scoreManager.scoreText.text = string.format( scoreManager.format, scoreManager.score )
end


function scoreManager.getScore()
   return scoreManager.score
end

 
function scoreManager.addInScore( amount )
   scoreManager.score = scoreManager.score + amount
   scoreManager.scoreText.text = string.format( scoreManager.format, scoreManager.score )
end


function scoreManager.save()
   local path = system.pathForFile( scoreManager.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( scoreManager.score )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", scoreManager.filename, "." )
      return false
   end
end


function scoreManager.load()
   local path = system.pathForFile( scoreManager.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      local score = tonumber(contents);
      io.close( file )
      return score
   else
      print( "Error: could not read scores from ", scoreManager.filename, "." )
   end
   return nil
end


return scoreManager