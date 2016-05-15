--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:6e9d42e767d5f9bf29e13dded0cf16ac:8c4a7c0abccc5bdb0fd21245ee4477f3:ac9d7618b5ce3c1c2d26ce07aade23ae$
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
            -- effects_btn_active
            x=531,
            y=1410,
            width=529,
            height=503,

        },
        {
            -- effects_btn_inactive
            x=1,
            y=389,
            width=529,
            height=508,

        },
        {
            -- effects_btn_inactive_pressed
            x=1,
            y=899,
            width=528,
            height=509,

        },
        {
            -- high_score_label
            x=802,
            y=242,
            width=857,
            height=83,

        },
        {
            -- menu_hero_1
            x=1062,
            y=838,
            width=308,
            height=308,

        },
        {
            -- menu_hero_10
            x=1062,
            y=1148,
            width=308,
            height=308,

        },
        {
            -- menu_hero_2
            x=1062,
            y=1148,
            width=308,
            height=308,

        },
        {
            -- menu_hero_3
            x=1062,
            y=1458,
            width=308,
            height=308,

        },
        {
            -- menu_hero_4
            x=1372,
            y=838,
            width=308,
            height=308,

        },
        {
            -- menu_hero_5
            x=1372,
            y=1148,
            width=308,
            height=308,

        },
        {
            -- menu_hero_6
            x=1372,
            y=1458,
            width=308,
            height=308,

        },
        {
            -- menu_hero_7
            x=1372,
            y=1148,
            width=308,
            height=308,

        },
        {
            -- menu_hero_8
            x=1372,
            y=838,
            width=308,
            height=308,

        },
        {
            -- menu_hero_9
            x=1062,
            y=1458,
            width=308,
            height=308,

        },
        {
            -- music_btn_active
            x=1,
            y=1410,
            width=528,
            height=507,

        },
        {
            -- music_btn_active_pressed
            x=532,
            y=389,
            width=528,
            height=509,

        },
        {
            -- music_btn_inactive
            x=531,
            y=900,
            width=529,
            height=508,

        },
        {
            -- music_btn_inactive_pressed
            x=1062,
            y=327,
            width=528,
            height=509,

        },
        {
            -- play_button_active
            x=927,
            y=1,
            width=798,
            height=239,

        },
        {
            -- play_button_active_pressed
            x=1,
            y=148,
            width=799,
            height=239,

        },
        {
            -- spacedash
            x=1,
            y=1,
            width=924,
            height=145,

        },
    },
    
    sheetContentWidth = 1726,
    sheetContentHeight = 1918
}

SheetInfo.frameIndex =
{

    ["effects_btn_active"] = 1,
    ["effects_btn_inactive"] = 2,
    ["effects_btn_inactive_pressed"] = 3,
    ["high_score_label"] = 4,
    ["menu_hero_1"] = 5,
    ["menu_hero_10"] = 6,
    ["menu_hero_2"] = 7,
    ["menu_hero_3"] = 8,
    ["menu_hero_4"] = 9,
    ["menu_hero_5"] = 10,
    ["menu_hero_6"] = 11,
    ["menu_hero_7"] = 12,
    ["menu_hero_8"] = 13,
    ["menu_hero_9"] = 14,
    ["music_btn_active"] = 15,
    ["music_btn_active_pressed"] = 16,
    ["music_btn_inactive"] = 17,
    ["music_btn_inactive_pressed"] = 18,
    ["play_button_active"] = 19,
    ["play_button_active_pressed"] = 20,
    ["spacedash"] = 21,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
