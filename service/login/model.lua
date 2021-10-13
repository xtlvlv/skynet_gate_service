

--[[

login 服务保存所有用户登录状态

player = user_id -> {
    user_id,    -- 用户id
    agent,      -- agent 服务
    status,     -- 状态
}    

--]]

local model = {
    players = {},
}

return model