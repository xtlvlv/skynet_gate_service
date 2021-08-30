local skynet = require "skynet"

local export = {}        -- 模块对外接口
local conf = {}     -- 配置

-- 配置管理

function export.get(key)
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

return export
