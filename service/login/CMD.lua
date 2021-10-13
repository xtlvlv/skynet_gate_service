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
    if login_info.user_id==nil then
        log.error(string.format(" no user_id msg=%s", msg))
        return
    end
    if login_info.user_id ~= login_info.pwd then
        log.error(string.format(" pwd is incorrect  user_id=%s  pwd=%s ", login_info.user_id, login_info.pwd))
        return
    end

    -- 检查玩家是否在线
    if model.players[fd] then
        log.warn(string.format("The player is online.  user_id=%s", login_info.user_id))
        return
    end

    -- 创建agent
    local agent = skynet.newservice("agent")
    skynet.call(agent, "lua", "init", fd, login_info.user_id)
    skynet.name(".agent"..login_info.user_id, agent)

    -- 更新在线玩家信息
    model.players[fd] = {
        user_id = login_info.user_id,
        status = "online",
    }

    local gate = skynet.localname(".gate")
    skynet.send(gate, "lua", "login_res", fd, login_info.user_id, agent)
end

function CMD.kick(fd)
    -- TODO: send agent exit
    model.players[fd].status = "offline"
    log.info(string.format("kick player  fd=%s  user_id=%s ", fd, model.players[fd].user_id))
end

return CMD