local skynet = require "skynet"

local export = {}

function export.Trace(...)
    skynet.error("[TRACE]", ...)
end

function export.Info(...)
    skynet.error("[INFO]", ...)
end

function export.Warning(...)
    skynet.error("[WARNING]", ...)
end

function export.Error(...)
    skynet.error("[ERROR]", ...)
end

return export