--[[
处理玩家的游戏逻辑
    
--]]

local skynet = require "skynet"
local log = require "util.log"

local CMD = require "CMD"

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = CMD[cmd]
        if not f then
            log.warn("agent service no fuction ", cmd)
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)
