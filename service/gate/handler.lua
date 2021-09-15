local websocket = require "http.websocket"
local skynet = require "skynet"

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

    local user_id = model.connections[fd].user_id
    
    if user_id then    -- 已经登录
        -- skynet.call() --转发给对应的agent处理
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
    log.info("...close...")
    log.info(" close code：", code, " reason: ", reason)
end

function handler.error(fd)
    log.info("...error...", " fd: ", fd)
end


return handler