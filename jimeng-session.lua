-- 即梦 Session ID 抓取 v9 - 根据真实请求修复
-- 匹配 jimeng.jianying.com 的 JSONP 请求

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
    local url = string.format("https://api.day.app/%s/%s/%s?sound=pop&group=jimeng", BARK_KEY, urlencode(title), urlencode(body))
    http.get(url, function() print("[BARK] sent") end)
end

-- 获取请求信息
local reqHeaders = $request.headers or {}
local reqUrl = $request.url or "unknown"
local reqMethod = $request.method or "GET"

-- 从请求头中提取 Cookie（可能有多行）
local cookieParts = {}
for key, value in pairs(reqHeaders) do
    if string.lower(key) == "cookie" then
        table.insert(cookieParts, value)
    end
end
local cookieStr = table.concat(cookieParts, "; ")

-- 调试：发送诊断通知
notify("🔍 脚本执行",
    "URL: " .. reqUrl ..
    "\nMethod: " .. reqMethod ..
    "\nCookie 长度: " .. #cookieStr)

-- 提取 sessionid（支持 sessionid=xxx 格式）
local sessionId = nil
for sid in cookieStr:gmatch("sessionid=([^;&]+)") do
    sessionId = sid
    break
end

-- 也尝试提取 sid_tt（可能是别名）
if not sessionId then
    for sid in cookieStr:gmatch("sid_tt=([^;&]+)") do
        sessionId = sid
        break
    end
end

if sessionId and sessionId ~= "" then
    notify("✅ 即梦 Session ID",
        "🔑 " .. sessionId ..
        "\n⏰ " .. os.date("%Y-%m-%d %H:%M:%S") ..
        "\n\n📋 export JIMENG_SESSION_ID=\"" .. sessionId .. "\"")
end