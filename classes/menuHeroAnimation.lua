--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:cc0c367c6df6e8c34c62ff1ccdea28a0:44529e56ab3d392d07ec978e7bfd51cf:67be7e1cdea5d096cff050cf707a9803$
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
            -- menu_hero_1
            x=1,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_10
            x=311,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_2
            x=311,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_3
            x=621,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_4
            x=931,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_5
            x=1241,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_6
            x=1551,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_7
            x=1241,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_8
            x=931,
            y=1,
            width=308,
            height=308,

        },
        {
            -- menu_hero_9
            x=621,
            y=1,
            width=308,
            height=308,

        },
    },
    
    sheetContentWidth = 1860,
    sheetContentHeight = 310
}

SheetInfo.frameIndex =
{

    ["menu_hero_1"] = 1,
    ["menu_hero_10"] = 2,
    ["menu_hero_2"] = 3,
    ["menu_hero_3"] = 4,
    ["menu_hero_4"] = 5,
    ["menu_hero_5"] = 6,
    ["menu_hero_6"] = 7,
    ["menu_hero_7"] = 8,
    ["menu_hero_8"] = 9,
    ["menu_hero_9"] = 10,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
