
local json = require "util.json"
local log = require "util.log"
--[[
agent 各协议的处理方法

--]]

local handler = {}

function handler.default(json_info)
    -- log.info(json_info)
    log.info("default handler")
end

return handler