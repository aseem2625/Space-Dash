--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:afd3086c8eb168dddb1313fa3788fb21:e077b2474b3e66d9d3545b089821c25e:8beecc607bdf24f3a24c4bacd69d829c$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- coin_1
            x=1,
            y=1,
            width=137,
            height=137,

        },
        {
            -- coin_2
            x=140,
            y=1,
            width=137,
            height=137,

        },
        {
            -- coin_3
            x=279,
            y=1,
            width=137,
            height=137,

        },
        {
            -- coin_4
            x=418,
            y=1,
            width=137,
            height=137,

        },
        {
            -- coin_5
            x=279,
            y=1,
            width=137,
            height=137,

        },
        {
            -- coin_6
            x=140,
            y=1,
            width=137,
            height=137,

        },
    },
    
    sheetContentWidth = 556,
    sheetContentHeight = 139
}

SheetInfo.frameIndex =
{

    ["coin_1"] = 1,
    ["coin_2"] = 2,
    ["coin_3"] = 3,
    ["coin_4"] = 4,
    ["coin_5"] = 5,
    ["coin_6"] = 6,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
