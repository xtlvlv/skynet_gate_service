local skynet = require "skynet"
local log = require "util.log"

local M = {}        -- 模块对外接口
local conf = {}     -- 配置

-- 配置管理

local function set_gateway()
    local gateway = {
        ip = "0.0.0.0",
        port = 19999,
    }
    conf["gateway"] = gateway
    -- table.insert(conf, gateway)
end

function M.get(key)
    if conf[key] ~= nil then
        return conf[key]
    end

    local value = skynet.getenv(key)
    if value == nil then
        return
    end

    -- 对于数字类型和bool类型特殊处理
    local tmp = tonumber(value)
    if tmp ~= nil then
        value = tmp
    end

    if value == "true" then
        value = true
    elseif value == "false" then
        value = false
    end

    conf[key] = value
    return conf[key]
end

set_gateway()   -- gateway 配置

return M
