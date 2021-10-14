local websocket = require "http.websocket"
local skynet = require "skynet"
require "skynet.manager"

local log = require "util.log"
local model = require "model"

local handler = {}  -- websocket 操作接口

function handler.connect(fd)
    log.info("connect from...  ", tostring(fd))

    model.connections[fd] = {
        fd = fd,
        addr = websocket.addrinfo(fd),
    }

    -- local addr = websocket.addrinfo(fd)
    -- local c = {
    --     fd = fd,
    --     ip = addr,
    -- }
    -- connections[fd] = c
end

function handler.handshake(fd, header, url)
    local addr = websocket.addrinfo(fd)
    log.info(string.format(" handshake...  fd=%s  url=%s  addr=%s ", fd, url, addr))
end

--[[ 处理消息
if 玩家已登录
    消息转发给agent
else 
    消息转发给登录服务器
--]]
function handler.message(fd, msg)
    local addr = websocket.addrinfo(fd)
    log.info(" recv msg from: ", fd, " addr:", addr, ", msg:", msg)

    local agent = model.connections[fd].agent
    
    if agent then    -- 已经登录
        -- local agent = skynet.localname(".agent"..user_id)
        skynet.send(agent, "lua", "message", msg)
    else
        local login = skynet.localname(".login")
        skynet.send(login, "lua", "login", fd, msg)
    end


    -- local c = connections[fd]
    -- local agent = c and c.agent
    -- if agent then -- 已登录
    --     -- TODO: 转发给agent处理
    --     log.info("redirect client")
    --     skynet.send(agent, "lua", "deal_msg", fd, msg)
    -- else
    --     skynet.send(LOGIN, "lua", "login", fd, msg)
    -- end
end

function handler.ping(fd)
    log.info("...ping from ", tostring(fd))
end

function handler.pong(fd)
    log.info("...pong from ", tostring(fd))
end

function handler.close(fd, code, reason)
    log.info(string.format(" close... fd=%s  code=%s  reason=%s ", fd, code, reason))

    -- 删除连接，不用加锁吗？在下线成功的回调中再删除
    -- model.connections[fd] = nil  

    -- 给agent 发送登出协议
    local login = skynet.localname(".login")
    local user_id = model.connections[fd].user_id
    if login ~= nil then
        skynet.send(login, "lua", "kick", fd)
    else
        log.error(string.format(" no login service fd=%s, user_id=%s ", fd, user_id))
    end
    log.info(string.format(" agent close fd=%s, user_id=%s ", fd, user_id))
    
end

function handler.error(fd)
    log.info("...error...", " fd: ", fd)
end


return handler