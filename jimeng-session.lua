-- 即梦 Session ID 抓取 v8 - 诊断版
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
    http.get(url, function()
        print("[BARK] sent")
    end)
end

-- 获取请求信息
local reqHeaders = $request.headers or {}
local reqUrl = $request.url or "unknown"
local reqMethod = $request.method or "GET"
local cookieStr = reqHeaders["Cookie"] or reqHeaders["cookie"] or ""

-- 先发送诊断通知，确认脚本执行
notify("🔍 脚本已执行",
    "URL: " .. reqUrl ..
    "\nMethod: " .. reqMethod ..
    "\nCookie 长度: " .. #cookieStr ..
    "\n\n完整 Cookie:\n" .. (cookieStr ~= "" and cookieStr or "（无）"))

-- 提取 sessionid
local sessionId = nil
for sid in cookieStr:gmatch("sessionid=([^;]+)") do
    sessionId = sid
    break
end

if sessionId and sessionId ~= "" then
    notify("✅ 即梦 Session ID",
        "🔑 " .. sessionId ..
        "\n⏰ " .. os.date("%Y-%m-%d %H:%M:%S") ..
        "\n\n📋 export JIMENG_SESSION_ID=\"" .. sessionId .. "\"")
end