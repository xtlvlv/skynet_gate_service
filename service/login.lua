-- 登录管理服务器

local skynet = require "skynet"
local log = require "log"


local CMD = {}
local AGENT

function CMD.init(agent)
    AGENT = agent
end

function CMD.login(fd, msg)
    log.Info(fd, "...login...", msg)
    skynet.call(AGENT, "lua", "login", fd, msg)
end


skynet.start(function ()
    log.Info("...login service start...")
    skynet.dispatch("lua", function (session, source, cmd, ...)
        log.Info(string.format("session=%s, source=%s, cmd=%s", session, source, cmd))
        local f = CMD[cmd]
        if not f then
            log.Error("login service no fuction ", cmd)
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)