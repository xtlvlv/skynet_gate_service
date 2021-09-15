-- 登录管理服务器
-- 暂时管理玩家账号

local skynet = require "skynet"
local log = require "util.log"
local CMD = require "CMD"


skynet.start(function ()
    log.info("-------------login service start--------------")
    skynet.dispatch("lua", function (session, source, cmd, ...)
        log.info(string.format("session=%s, source=%s, cmd=%s", session, source, cmd))
        local f = CMD[cmd]
        if not f then
            log.error("login service no fuction ", cmd)
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)