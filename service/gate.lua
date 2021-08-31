-- 管理网络连接


local skynet = require "skynet"
local log = require "log"
local socket = require "skynet.socket"
local websocket = require "http.websocket"

local M = {}   -- 本模块接口，能直接调用
local CMD = {}  -- 本服务接口，提供给call 调用

local handler = {}  -- websocket 操作接口

local connection = {} -- fd -> connection: {fd, client, agent, ip}
local forwarding = {} -- agent -> connection

local client_num = 0    -- 在线客户端数量
local LOGIN

function handler.connect(fd)
    log.Info("...connect from ", tostring(fd))

    client_num = client_num + 1
    local addr = websocket.addrinfo(fd)
    local c = {
        fd = fd,
        ip = addr,
    }
    connection[fd] = c

end

function handler.handshake(fd, header, url)
    local addr = websocket.addrinfo(fd)
    log.Info(" handshake from: ", fd, ", url:", url, ", addr:", addr)
end

function handler.message(fd, msg)
    local addr = websocket.addrinfo(fd)
    log.Info(" recv msg from: ", fd, " addr:", addr, ", msg:", msg)

    local c = connection[fd]
    local agent = c and c.agent
    if agent then -- 已登录
        -- TODO: 转发给agent处理
        log.Info("redirect client")
        skynet.send(agent, "lua", "deal_msg", fd, msg)
    else
        skynet.send(LOGIN, "lua", "login", fd, msg)
    end
end

function handler.ping(fd)
    log.Info("...ping from ", tostring(fd))
end

function handler.pong(fd)
    log.Info("...pong from ", tostring(fd))
end

function handler.close(fd, code, reason)
    log.Info("...close...")
    log.Info(" close code：", code, " reason: ", reason)
end

function handler.error(fd)
    log.Info("...error...", " fd: ", fd)
end

-- 开启监听
function CMD.start()
    
    local fd = socket.listen("0.0.0.0", 19999)
    log.Info("...listing..., fd = ", fd)

    socket.start(fd, function (fd, addr)
        log.Info(string.format("...socket start... fd=%s, addr=%s", fd, addr))
        websocket.accept(fd, handler, "ws", addr)
    end)
end

function CMD.init(source, conf)
    log.Trace("...conf...", conf)
    LOGIN = conf.login
end

local function unforward(c)
    if c.agent then
        forwarding[c.agent] = nil
        c.agent = nil
        c.client = nil
    end
end

function CMD.forward(source, fd, client, address)
    log.Info(string.format("forward, fd=%s, address=%s, client=%s, source=%s.", fd, address, client, source))
    local c = assert(connection[fd])
    unforward(c)
    c.client = client or 0
    c.agent = address or source
    forwarding[c.agent] = c
end

skynet.start(function ()
    
    log.Info("...gate service start...")
    skynet.dispatch("lua", function (session, source, cmd, ...)
        log.Info(string.format("gate dispatch session=%s, source=%s, cmd=%s", session, source, cmd))
        local f = CMD[cmd]
        if not f then
            log.Error("gate service no fuction ", cmd)
        end

        if session == 0 then
            f(source, ...)
        else
            skynet.ret(skynet.pack(f(source, ...)))
        end
    end)
end)



return M