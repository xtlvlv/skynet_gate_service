local skynet = require "skynet"
local log = require "log"

local GATE -- gate 服务地址

local CMD = {}

function CMD.init(gate)
    GATE = gate
end

-- 登录
function CMD.login(fd, msg)

    log.Info("...agent login...")
    skynet.call(GATE, "lua", "forward", fd, skynet.self())
    return "sucess"
end

function CMD.deal_msg(fd, msg)

    log.Info(fd, "...agent deal_msg...", msg)
    return "sucess"
end


skynet.start(function()
    skynet.dispatch("lua", function(session, source, command, ...)
        local f = CMD[command]
        log.Info(session, "...agent dispatch...", source)
        skynet.ret(skynet.pack(f(...)))
    end)
end)
