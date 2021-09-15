local skynet = require "skynet"
require "skynet.manager"

local config = require "config"
local log = require "util.log"

local function server_start()
    log.info("server start")
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
end

local redis = require "skynet.db.redis"

local function redis_test()
    local redis_config = { host = "127.0.0.1", port = 6379, db = 0, auth = 'root'}
    local db = redis.connect(redis_config)

    db:set("key1", "value1")
    log.info(db:get("key1"))
end

local function start()
    
    dofile("lualib/config.lua")   -- 加载配置配置

    -- 网关服务
    local gate = skynet.newservice("gate")
    skynet.name(".gate", gate)

    -- 登录服务
    local login = skynet.newservice("login")
    skynet.name(".login", login)


    skynet.call(gate, "lua", "start")
end

skynet.start(function ()

    
    -- redis_test()
    log.info("------------start--------------")
    start()
    skynet.exit()
end)