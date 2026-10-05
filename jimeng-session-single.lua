-- 即梦 Session ID 抓取 - 单文件版 v10
-- Loon 插件 + 脚本合一
-- 安装：直接粘贴到 Loon 脚本编辑器

-- ============================================
-- 配置区
-- ============================================
BARK_KEY = "Av8DkzMpStcsmsW3KfqEMc"

-- ============================================
-- 工具函数
-- ============================================
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

-- ============================================
-- 主逻辑
-- ============================================
local reqHeaders = $request.headers or {}
local reqUrl = $request.url or "unknown"
local reqMethod = $request.method or "GET"

-- 从请求头中提取 Cookie
local cookieParts = {}
for key, value in pairs(reqHeaders) do
    if string.lower(key) == "cookie" then
        table.insert(cookieParts, value)
    end
end
local cookieStr = table.concat(cookieParts, "; ")

-- 调试通知
notify("🔍 脚本执行",
    "URL: " .. reqUrl ..
    "\nMethod: " .. reqMethod ..
    "\nCookie 长度: " .. #cookieStr)

-- 提取 sessionid
local sessionId = nil
for sid in cookieStr:gmatch("sessionid=([^;&]+)") do
    sessionId = sid
    break
end

if not sessionId then
    for sid in cookieStr:gmatch("sid_tt=([^;&]+)") do
        sessionId = sid
        break
    end
end

-- 成功通知
if sessionId and sessionId ~= "" then
    notify("✅ 即梦 Session ID",
        "🔑 " .. sessionId ..
        "\n⏰ " .. os.date("%Y-%m-%d %H:%M:%S") ..
        "\n\n📋 export JIMENG_SESSION_ID=\"" .. sessionId .. "\"")
end