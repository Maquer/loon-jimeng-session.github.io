-- 即梦 Session ID 抓取 v7

BARK_KEY = "Av8DkzMpStcsmsW3KfqEMc"

local function urlencode(str)
    if not str then return "" end
    str = str:gsub("([^%w ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    str = str:gsub(" ", "%%20")
    return str
end

local function notify(title, body)
    local url = string.format("https://api.day.app/%s/%s/%s", BARK_KEY, urlencode(title), urlencode(body))
    http.get(url, function() print("[BARK] sent") end)
end

local reqHeaders = $request.headers or {}
local reqUrl = $request.url or "unknown"
local cookieStr = reqHeaders["Cookie"] or reqHeaders["cookie"] or ""

local sessionId = nil
for sid in cookieStr:gmatch("sessionid=([^;]+)") do
    sessionId = sid
    break
end

if sessionId and sessionId ~= "" then
    notify("✅ 即梦 Session ID", "🔑 " .. sessionId)
else
    notify("❓ 未找到", "URL: " .. reqUrl .. "\nCookie 长度: " .. #cookieStr)
end
