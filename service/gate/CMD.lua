local socket = require "skynet.socket"
local websocket = require "http.websocket"

local config = require "config"
local log = require "util.log"
local handler = require "handler"
local model = require "model"

local CMD = {}  -- 本服务接口，提供给call 调用

-- 开启监听
function CMD.start()
    log.trace("gate.CMD.start")
    local gate_config = config.get("gateway")
    
    log.trace(gate_config.ip, gate_config.port)
    local fd = socket.listen(gate_config.ip, gate_config.port)

    log.info(string.format("listing...  fd=%s  addr=%s  port=%d", fd, gate_config.ip, gate_config.port))

    socket.start(fd, function (fd, addr)
        log.info(string.format("socket start...  fd=%s  addr=%s", fd, addr))
        websocket.accept(fd, handler, "ws", addr)
    end)
end

function CMD.login_res(fd, user_id, agent)
    if not model.connections[fd] then
        log.error(string.format(" connection is not exist  fd=%s  user_id=%s", fd, user_id))
        return
    end

    model.connections[fd].user_id = user_id
    model.connections[fd].agent = agent

    -- TODO: 返回给客户端登录成功
    log.info(string.format(" login successfully  fd=%s  user_id=%s", fd, user_id))
end 

function CMD.logout_res(fd)
    if not model.connections[fd] then
        log.error(string.format(" connection is not exist  fd=%s  user_id=%s", fd))
        return
    end

    model.connections[fd] = nil

    -- TODO: 返回给客户端退出成功
    log.info(string.format(" logout successfully  fd=%s ", fd))
end 

return CMD