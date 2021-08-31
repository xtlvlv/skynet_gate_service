local skynet = require "skynet"
local config = require "config"
local log = require "log"

skynet.start(function ()

    log.Info("server start")
    if not config.get("daemon") then
        -- 如果不是 daemon 模式启动则开启 console 服务
        skynet.newservice("console")
    end

    -- 启动登录服务器
    local LOGIN = skynet.newservice("login")

    -- 启动网关服务器
    local GATE = skynet.newservice("gate")
    local AGENT = skynet.newservice("agent")

    -- local conf = {}
    -- conf.login = login
    -- gate.init(conf)

    skynet.call(GATE, "lua", "init", {
        login = LOGIN,
    })
    skynet.call(AGENT, "lua", "init", GATE)
    skynet.call(LOGIN, "lua", "init", AGENT)

    skynet.call(GATE, "lua", "start")
    
    skynet.exit()
end)