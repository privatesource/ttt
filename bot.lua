function bencode(data)
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
function bdecode(data)
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

local function kmakerow(texts)
local row = {}
for i=1 , #texts do
row[i] = {text=URL.escape(texts[i])}
end
return row
end
local function kmake(rows)
local kb = {}
kb.keyboard = rows
kb.resize_keyboard = true
kb.selective = true
return kb
end
local function make_menu()
local rw1_texts = {'درباره','قابلیت های این ربات'}
local rows ={kmakerow(rw1_texts)}
return kmake(rows)
end
local function action(msg)
if msg.text == '/start' then
api.sendMessage(msg.chat.id, '`ربات اطلاعات تیم امبرلا کپی`', true, true,msg.message_id, true,make_menu())
db:hset('bot:waiting',msg.from.id,'main')
elseif msg.text == '🚀 منوی اصلی' then
api.sendMessage(msg.chat.id, '🚀 منوی اصلی:', true, true,msg.message_id, true,make_menu())
db:hset('bot:waiting',msg.from.id,'main')
elseif msg.text == 'ریلود' and msg.from.id == bot_sudo then
bot_init(true)
api.sendReply(msg, '`از اول بازگذاری شد`', true)
elseif msg.text == 'کاربران' and msg.from.id == bot_sudo then
api.sendReply(msg, '`کاربران:`'..db:hlen('bot:waiting'), true)
elseif msg.text and msg.text:match('^/mk (.*)$') then
api.sendReply(msg.text:match('^/mk (.*)$'))
elseif msg.text and msg.text:match('^ارسال .*$') and msg.from.id == bot_sudo then
local pm = msg.text:match('^ارسال (.*)$')
local suc = 0
local ids = db:hkeys('bot:waiting')
if ids then
for i=1,#ids do
local ok,desc = api.sendMessage(ids[i], pm)
print('`ارسال شد`', ids[i])
if ok then
suc = suc +1
end
end
api.sendReply(msg, '`پیام به '..#ids..'user, '..suc..' نفر '..(#ids - suc)..' نامشخص`')
else
api.sendReply(msg, 'کاربری پیدا نشد!')
end
elseif msg.text == 'قابلیت های این ربات' then
local help = [[`مارکداون!`
`/mk [Text]`
`CopyRight UmbrellaCopy`]]
api.sendReply(msg, help, true)
elseif msg.text == 'درباره' then
local pms = [[👥 This is a team to create a copy as same as original version of umbrella team bots and then opening source ❤️

👥 این یک تیم هست که یک کپی مشابه ربات هاب اصلی امبرلا میسازد ❤️
اعضای تیم :
@Arian713 
@XDeadKingX 
@shayan123hacker 
@Apple_VPN 
@Apple_VPN 
@Mosydev 
@Pro_Dev 
@aWmiR_Ho3iN 
@Pho3nix 
@ShopBuy 
@XMrdevX 
@Amir_h 
@pro_poker 
@HEXTOR 
@Forbidguy 
😠 <R>ez</a> 😠 
@XxX_Developer_XxX 
‌Abolfazl 
@MutePuker 
@Mehti_051 
@Inpoker]]
local keyboard = {}
    keyboard.inline_keyboard = {
{
{text = "🚀 کانال", url = 'https://telegram.me/umbrellacopy'},
},
{
{text = "⭐️ گیت هاب | استار دادن فراموش نشه!", url = 'https://github.com/umbrellacopy'},
},
{
{text = "👑 ادمین", url = 'https://telegram.me/jan123'}
}
}
api.sendMessage(msg.chat.id, pms, true, true,msg.message_id, true,keyboard)
end
end

return {
action = action,
iaction = iaction
}
