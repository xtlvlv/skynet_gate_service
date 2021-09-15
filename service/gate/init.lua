-- 管理网络连接


local skynet = require "skynet"
local socket = require "skynet.socket"
local websocket = require "http.websocket"

local log = require "util.log"
local CMD = require "CMD"

skynet.start(function ()
    log.info("----------gate service start----------")

    skynet.dispatch("lua", function (session, source, cmd, ...)
        log.info(string.format("gate dispatch session=%s, source=%s, cmd=%s", session, source, cmd))
        local f = CMD[cmd]
        if not f then
            log.warn("gate service no fuction ", cmd)
        end

        if session == 0 then
            f(...)
        else
            skynet.ret(skynet.pack(f(...)))
        end
    end)
end)