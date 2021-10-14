

--[[] connections:
    fd = {
        fd = 1,
        addr = xx,
        user_id = 1,
        pwd = 1(md5),
        agent = nil,
    }
--]]

local model = {
    connections = {},
    forwarding = {},     -- user_id -> agent
    client_num = 0,    -- 在线客户端数量
}


return model