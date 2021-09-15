local skynet = require "skynet"
require "skynet.manager"

local log = require "util.log"
local json = require "util.json"
local model = require "model"

local CMD = {}

--[[ 协议
登录协议
{
    "cmd": "login",
    "user_id": 100001,
    "pwd": 100001
}

--]]


--[[
登录逻辑：
账号校验

if 玩家在线
    踢下线

创建agent，注册agent信息

更新在线玩家状态

返回给gate登录成功信息
--]]
function CMD.login(fd, msg)
    -- local msg_json = json.decode(msg)

    local ok, login_info = pcall(json.decode, msg)
    if not ok then
        log.error(string.format(" json decode failed  msg=%s", msg))
        return
    end

    if login_info.cmd ~= "login" then
        log.error(string.format(" not login proto  cmd=%s", login_info.cmd))
        return
    end
    
    -- 玩家账号校验，简化处理，不存在默认添加，暂时保存在内存中 TODO:

    -- 检查玩家是否在线
    if model.players[login_info.user_id] then
        log.warn(string.format("The player is online.  user_id=%s", login_info.user_id))
        return
    end

    -- 创建agent
    local agent = skynet.newservice("agent")
    skynet.name(".agent"..login_info.user_id, agent)

    local gate = skynet.localname(".gate")
    skynet.send(gate, "lua", "login_res", fd, login_info.user_id, agent)
end

return CMD