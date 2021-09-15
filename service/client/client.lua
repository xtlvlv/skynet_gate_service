local skynet = require "skynet"
local websocket = require "http.websocket"
local log = require "log"
local socket = require "skynet.socket"

local g_ws_id

local function wsMainLoop()
    
    local l_url = "ws://127.0.0.1:19999"
    g_ws_id = websocket.connect(l_url)
    log.Info("websocket connect. ws_id: ", g_ws_id)
    while true do
        local l_res, _ = websocket.read(g_ws_id)
        if not l_res then
            log.Info("disconnect...")
            break;
        end

        websocket.ping(g_ws_id)
    end
end

local function consoleMainLoop()
    local l_stdin = socket.stdin()
    while true do
		local l_cmdline = socket.readline(l_stdin, "\n")
		if l_cmdline ~= "" then
            websocket.write(g_ws_id, l_cmdline)
        end
	end
end

skynet.start(function ()
    
    skynet.fork(wsMainLoop)
    skynet.fork(consoleMainLoop)

end)