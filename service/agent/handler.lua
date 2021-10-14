local skynet = require "skynet"

local json = require "util.json"
local log = require "util.log"
local player = require "model"
--[[
agent 各协议的处理方法

--]]

local handler = {}

function handler.default(json_info)
    -- log.info(json_info)
    log.info("default handler")
end

-- 退出
function handler.logout(json_info)
    -- TODO: 验证密码是否正确，把验证逻辑提取出来，这里先不验证
    -- 此服务结束，login保存用户信息删除，gate信息在gate断开连接的时候删除
    
    local login = skynet.localname(".login")
    skynet.send(login, "lua", "kick", player.fd)
    
end

function handler.exit()
    log.info(string.format("user exit! fd=%s", player.fd))
    skynet.exit()
end

return handler