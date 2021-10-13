local skynet = require "skynet"

local log = require "util.log"
local json = require "util.json"
local handler = require "handler"

local CMD = {}

local player = {}

function CMD.init(fd, user_id)
    player.fd = fd
    player.user_id = user_id
end

function CMD.message(msg)
    local ok, json_info = pcall(json.decode, msg)
    if not ok then
        log.error(string.format(" json decode failed in agent  msg=%s", msg))
        return
    end
    log.info(string.format(" user %s recv msg: %s ", player.user_id, msg))
    
    if json_info.cmd == nil then
        log.error(string.format(" json decode failed in agent  msg=%s", msg))
        return
    end

    local f = handler[json_info.cmd]
    if f == nil then
        log.error(string.format(" no the cmd  msg=%s, cmd=%s", msg, json_info.cmd))
        f = handler["default"]
    end
    
    skynet.ret(skynet.pack(f(json_info)))

end

return CMD