-- customui




local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

guiset = {
  side = "right",font = Enum.Font.Highway,size = 12,
  downinfo = TweenInfo.new(.1,Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
  upinfo = TweenInfo.new(.3,Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
  tween = TweenInfo.new(.35,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
  bordercolor = Color3.fromRGB(190,190,190),
  maincolor = Color3.fromRGB(130,130,130),
  altcolor = Color3.fromRGB(110,110,110),
  textcolor = Color3.fromRGB(230,230,230),
  select = Color3.fromRGB(170,170,170),
}

local function rounded(n, dec)
  dec = dec or 2
  local mult = 10 ^ dec
  local s = tostring(math.floor(n * mult + .5) / mult)
  s = s:gsub("(%..-)0+$", "%1")
  s = s:gsub("%.$", "")
  return s
end

local function autobuttoncolor(btn, frame, base, down)
  btn.MouseButton1Down:Connect(function() ts:Create(frame, guiset.downinfo, {BackgroundColor3 = down}):Play() end)
  btn.InputEnded:Connect(function() ts:Create(frame, guiset.upinfo, {BackgroundColor3 = base}):Play() end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "co"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.BorderSizePixel = 1
frame.BorderColor3 = guiset.bordercolor
frame.Size = UDim2.new(0,150,0,121)
frame.Position = UDim2.new(0,1,.4,0)
frame.AnchorPoint = Vector2.new(0,.5)
frame.AnchorPoint = Vector2.new(guiset.side == "left" and 0 or 1,.5)
frame.Position = guiset.side == "left" and UDim2.new(0,1,.4,0) or UDim2.new(1,-1,.4,0)
frame.BackgroundColor3 = guiset.bordercolor
frame.Active = false
frame.Parent = gui

local frame2  = Instance.new("Frame")
frame2.BorderSizePixel = 1
frame2.BorderColor3 = guiset.bordercolor
frame2.Size = UDim2.new(1,0,0,90)
frame2.Position = UDim2.new(0,0,1,1)
frame2.AnchorPoint = Vector2.new(0,0)
frame2.BackgroundColor3 = guiset.bordercolor
frame2.Active = false
frame2.Visible = false
frame2.Parent = frame
local scrollmark = Instance.new("ScrollingFrame",frame2)
scrollmark.Size = UDim2.new(1,0,1,0)
scrollmark.Position = UDim2.new(.5,0,.5,0)
scrollmark.AnchorPoint = Vector2.new(.5,.5)
scrollmark.BackgroundColor3 = guiset.maincolor
scrollmark.CanvasSize = UDim2.new(0,0,.5,0)
scrollmark.BorderSizePixel = 0
scrollmark.ScrollBarThickness = 0
scrollmark.ScrollingDirection = "Y"
scrollmark.AutomaticCanvasSize = "Y"
local pad = Instance.new("UIPadding",scrollmark)
pad.PaddingTop = UDim.new(0,2)
pad.PaddingBottom = UDim.new(0,2)

local grid = Instance.new("UIGridLayout")
grid.Parent = scrollmark
grid.CellSize = UDim2.new(.5, -8, 0, 22)
grid.CellPadding = UDim2.new(0, 2, 0, 2)
grid.FillDirection = "Horizontal"
grid.FillDirectionMaxCells = 2
grid.HorizontalAlignment = "Center"
grid.VerticalAlignment = "Top"

local closeButton = Instance.new("TextButton")
closeButton.BorderSizePixel = 1
closeButton.BorderColor3 = guiset.bordercolor
closeButton.BackgroundColor3 = guiset.maincolor
closeButton.Size = UDim2.new(0,25,1,-1.5)
closeButton.Position = guiset.side == "left" and UDim2.new(1,1,0,1) or UDim2.new(0,-1,0,1)
closeButton.AnchorPoint = Vector2.new(guiset.side == "left" and 0 or 1,0)
closeButton.Text = ""
closeButton.Parent = frame

local open = true
closeButton.MouseButton1Click:Connect(function()
  open = not open
  ts:Create(frame, TweenInfo.new(.25,Enum.EasingStyle.Sine,Enum.EasingDirection.Out),{
    AnchorPoint = Vector2.new(guiset.side == "left" and 0 or 1,.5),
    Position = guiset.side == "left"
      and (UDim2.new(0,open and 1 or -frame.AbsoluteSize.X,frame.Position.Y.Scale,0)) or (UDim2.new(1,open and -1 or frame.AbsoluteSize.X,frame.Position.Y.Scale,0))
  }):Play()
end)

local dragging = false
local dragStartY = nil
local frameStartY = nil
local inputdrag = nil
local taskdrag = nil

closeButton.InputBegan:Connect(function(i)
  if inputdrag == nil and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
    inputdrag = i
    dragStartY = i.Position.Y
    frameStartY = frame.Position.Y.Scale
  end
end)

closeButton.MouseButton1Down:Connect(function()
  taskdrag = task.delay(.2, function()
    if inputdrag then
      dragging = true
    end
  end)
end)

uis.InputEnded:Connect(function(i)
  if inputdrag == i and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
    inputdrag = nil
    dragging = false
    if taskdrag then
      task.cancel(taskdrag)
      taskdrag = nil
    end
  end
end)

uis.InputChanged:Connect(function(i)
  if inputdrag == i and dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
    local newY = math.clamp(frameStartY + ((i.Position.Y - dragStartY) / gui.AbsoluteSize.Y),0,1 - (frame.AbsoluteSize.Y / gui.AbsoluteSize.Y))
    frame.Position = UDim2.new(frame.Position.X.Scale,frame.Position.X.Offset,newY,0)
  end
end)

local scrollTab = Instance.new("ScrollingFrame")
scrollTab.BorderSizePixel = 1
scrollTab.BorderColor3 = guiset.bordercolor
scrollTab.Size = UDim2.new(1,0,0,22)
scrollTab.Position = UDim2.new(0,0,0,-22)
scrollTab.CanvasSize = UDim2.new(0,0,0,0)
scrollTab.BackgroundColor3 = guiset.maincolor
scrollTab.ScrollingDirection = "X"
scrollTab.AutomaticCanvasSize = "X"
scrollTab.ScrollBarThickness = 0
scrollTab.Parent = frame
local tablist = Instance.new("UIListLayout",scrollTab)
tablist.Padding = UDim.new(0,0)
tablist.SortOrder = "LayoutOrder"
tablist.FillDirection = "Horizontal"
tablist.HorizontalAlignment = "Left"

local knownframe = Instance.new("Frame")
knownframe.Size = UDim2.new(.95,0,0,20)
knownframe.AnchorPoint = Vector2.new(.5,0)
knownframe.BorderSizePixel = 0
knownframe.BackgroundColor3 = guiset.altcolor

local library={}
local tabList = {}
function library.createTab(name)
  local scroll = Instance.new("ScrollingFrame",frame)
  local tabButton = Instance.new("TextButton",scrollTab)
  local list = Instance.new("UIListLayout",scroll)
  local pad = Instance.new("UIPadding",scroll)
  table.insert(tabList, scroll)
  scroll.Visible = #tabList <= 2
  scroll.Size = UDim2.new(1,0,1,-1)
  scroll.Position = UDim2.new(0,0,1,0)
  scroll.AnchorPoint = Vector2.new(0,1)
  scroll.BackgroundColor3 = guiset.maincolor
  scroll.BorderSizePixel = 0
  scroll.ScrollBarThickness = 0
  scroll.ScrollingDirection = "Y"
  scroll.AutomaticCanvasSize = "Y"
  tabButton.LayoutOrder = #tabList == 1 and 2 or 1
  tabButton.Size = UDim2.new(0,45,0,22)
  tabButton.AnchorPoint = Vector2.new(0,.5)
  tabButton.BackgroundColor3 = guiset.maincolor
  tabButton.BorderSizePixel = 1
  tabButton.BorderColor3 = guiset.bordercolor
  tabButton.Text = name
  tabButton.TextSize = guiset.size
  tabButton.Font = guiset.font
  tabButton.TextColor3 = guiset.textcolor
  pad.PaddingTop = UDim.new(0,2)
  pad.PaddingBottom = UDim.new(0,2)
  list.Padding = UDim.new(0,3)
  list.HorizontalAlignment = "Center"
  tabButton.MouseButton1Click:Connect(function()
    for _,scr in ipairs(tabList) do scr.Visible = false end
    scroll.Visible = true
  end)
  return scroll
end

function library.button(t,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local b = Instance.new("TextButton",fb)
  b.BackgroundTransparency = 1
  b.Size = UDim2.new(.95,0,1,0)
  b.AnchorPoint = Vector2.new(.5,.5)
  b.Position = UDim2.new(.5,0,.5,0)
  b.TextXAlignment = "Left"
  b.ClipsDescendants = true
  b.Text = t
  b.TextSize = guiset.size
  b.Font = guiset.font
  b.TextColor3 = guiset.textcolor
  b.MouseButton1Click:Connect(f)
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  return {
    fire = function() if f then f() end end,
    destroy = function() fb:Destroy() end
  }
end

function library.toggle(t,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local b = Instance.new("TextButton",fb)
  local cb = Instance.new("Frame",b)
  b.BackgroundTransparency = 1
  b.Size = UDim2.new(.95,0,1,0)
  b.AnchorPoint = Vector2.new(.5,.5)
  b.Position = UDim2.new(.5,0,.5,0)
  b.ClipsDescendants = true
  b.TextXAlignment = "Left"
  b.Text = t
  b.TextSize = guiset.size
  b.Font = guiset.font
  b.TextColor3 = guiset.textcolor
  cb.Size = UDim2.new(0,8,.8,0)
  cb.BorderSizePixel = 0
  cb.Position = UDim2.new(1,0,.5,0)
  cb.AnchorPoint = Vector2.new(1,.5)
  cb.BackgroundColor3 = Color3.fromRGB(255,0,0)
  local on = false
  local function a(v)
    on = v
    ts:Create(cb,TweenInfo.new(.2),{BackgroundColor3 = v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)}):Play()
    if f then f(v) end
  end
  a(false)
  b.MouseButton1Click:Connect(function() a(not on) end)
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  return {
    bool = function() return on end,
    fire = function(_,v) a(v == nil and not on or not not v) end,
    destroy = function() fb:Destroy() end
  }
end

function library.textbox(t,t2,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local l = Instance.new("TextLabel",fb)
  local b = Instance.new("TextBox",fb)
  l.BackgroundTransparency = 1
  l.Position = UDim2.new(0,4,0,0)
  l.Size = UDim2.new(0,0,1,0)
  l.TextXAlignment = "Left"
  l.TextColor3 = guiset.textcolor
  l.ClipsDescendants = true
  l.Text = t.." :"
  l.TextSize = guiset.size
  l.Font = guiset.font
  l.AutomaticSize = "X"
  b.BackgroundTransparency = 1
  b.TextXAlignment = "Right"
  b.PlaceholderText = t2
  b.ClipsDescendants = true
  b.Text = ""
  b.TextSize = guiset.size
  b.Font = guiset.font
  b.TextColor3 = guiset.textcolor
  task.wait()
  local pad = 5
  local w = math.min(l.TextBounds.X + pad, fb.AbsoluteSize.X * .75)
  l.Size = UDim2.new(0,w,1,0)
  b.Position = UDim2.new(0,w + pad,0,0)
  b.Size = UDim2.new(1,-(w + pad*2),1,0)
  b.FocusLost:Connect(function() if f then f(b.Text) end end)
  return {
    set = function(v) b.Text = tostring(v) end,
    fire = function() if f then f(b.Text) end end,
    get = function() return b.Text end,
    destroy = function() fb:Destroy() end
  }
end

function library.switch(t,p,f,lst)
  local fb = knownframe:Clone()
  fb.Parent = p
  local b = Instance.new("TextButton",fb)
  local l = Instance.new("TextLabel",fb)
  b.BackgroundTransparency = 1
  b.Size = UDim2.new(.95,0,1,0)
  b.AnchorPoint = Vector2.new(.5,.5)
  b.Position = UDim2.new(.5,0,.5,0)
  b.TextXAlignment = "Left"
  b.Text = t.." :"
  b.TextSize = guiset.size
  b.Font = guiset.font
  b.TextColor3 = guiset.textcolor
  b.ClipsDescendants = true
  l.BackgroundTransparency = 1
  l.Size = UDim2.new(.95,0,.8,0)
  l.AnchorPoint = Vector2.new(.5,.5)
  l.Position = UDim2.new(.5,0,.5,0)
  l.TextXAlignment = "Right"
  l.TextSize = guiset.size
  l.Font = guiset.font
  l.TextColor3 = guiset.textcolor
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  local i = 1
  local function a(x)
    i = x
    l.Text = tostring(lst[i])
    if f then f(lst[i],i) end
  end
  a(1)
  b.MouseButton1Click:Connect(function()
    local n = i+1 > #lst and 1 or i+1
    a(n)
  end)
  return {
    bool = function() return lst[i] end,
    index = function() return i end,
    fire = function(v)
      if v==nil then
        a(i+1 > #lst and 1 or i+1)
      elseif type(v)=="number" then
        if lst[v] then a(v) end
      else
        for k,val in ipairs(lst) do
          if val==v then a(k) break end
        end
      end
    end,
    set = function(v)
      for k,val in ipairs(lst) do
        if val==v then a(k) break end
      end
    end,
    destroy = function() fb:Destroy() end
  }
end

local markspot,active = {},{}
function library.markdown(t,p,f,l,m)
  m = m~=false

  local a,id,bs = {},{},{}
  local fb = knownframe:Clone()
  fb.Parent = p
  local lbl = Instance.new("TextLabel",fb)
  local btn = Instance.new("TextButton",fb)

  lbl.BackgroundTransparency = 1
  lbl.Position = UDim2.new(0,2,0,0)
  lbl.Text = t.." :"
  lbl.TextSize = guiset.size
  lbl.Font = guiset.font
  lbl.TextColor3 = guiset.textcolor
  lbl.AutomaticSize = "X"
  btn.Position = UDim2.new(1,-4,0,0)
  btn.AnchorPoint = Vector2.new(1,0)
  btn.Size = UDim2.new(1,-4,1,0)
  btn.BackgroundTransparency = 1
  btn.TextXAlignment = "Right"
  btn.Text = "[ 0 ]"
  btn.TextSize = guiset.size
  btn.Font = guiset.font
  btn.TextColor3 = guiset.textcolor
  autobuttoncolor(btn,fb,guiset.altcolor,guiset.select)
  task.wait()
  local pad = 5
  local w = math.min(lbl.TextBounds.X+pad,fb.AbsoluteSize.X*.75)
  lbl.Size = UDim2.new(0,w,1,0)
  markspot[id] = {}
  local c = 0
  for i=1,#l do
    local it = l[i]
    local b = Instance.new("TextButton",scrollmark)
    b.Size = UDim2.new(1,0,0,20)
    b.BackgroundColor3 = guiset.altcolor
    b.BorderSizePixel = 0
    b.Text = tostring(it)
    b.TextSize = guiset.size
    b.Font = guiset.font
    b.TextColor3 = guiset.textcolor
    b.Visible = false

    markspot[id][#markspot[id]+1] = b
    bs[#bs+1] = b
    local s = false
    b.MouseButton1Click:Connect(function()
      if m then
        s = not s
        if s then a[it],c,b.BackgroundColor3 = true,c+1,guiset.select
        else a[it],c,b.BackgroundColor3 = nil,c-1,guiset.altcolor end
      else
        if a[it] then
          a[it],c,b.BackgroundColor3 = nil,0,guiset.altcolor
        else
          for _,o in ipairs(bs) do o.BackgroundColor3 = guiset.altcolor end
          table.clear(a)
          a[it],c,b.BackgroundColor3 = true,1,guiset.select
        end
      end
      btn.Text = ("[ %d ]"):format(c)
      if f then f(a) end
    end)
  end
  btn.MouseButton1Click:Connect(function()
    if active==id then
      for _,v in ipairs(markspot[id]) do v.Visible=false end
      frame2.Visible=false
      active=nil
    else
      if active and markspot[active] then
        for _,v in ipairs(markspot[active]) do v.Visible=false end
      end
      for _,v in ipairs(markspot[id]) do v.Visible=true end
      frame2.Visible=true
      active=id
    end
  end)
  return {
    get = function() return a end,
    destroy = function() fb:Destroy() end
  }
end

local notifytable = {}
function library.notify(d,t)
  local fb = Instance.new("Frame")
  notifytable[#notifytable+1] = fb
  fb.Size = UDim2.new(0,120,0,53)
  fb.Position = UDim2.new(1,100,1,-10)
  fb.AnchorPoint = Vector2.new(1,1)
  fb.BorderSizePixel = 1
  fb.BorderColor3 = guiset.bordercolor
  fb.BackgroundColor3 = guiset.maincolor
  fb.BackgroundTransparency = 1
  fb.Parent = gui
  local b = Instance.new("TextButton",fb)
  b.BackgroundTransparency = 1
  b.TextTransparency = 1
  b.Size = UDim2.new(.9,0,.9,0)
  b.AnchorPoint = Vector2.new(.5,.5)
  b.Position = UDim2.new(.5,0,.5,0)
  b.TextColor3 = guiset.textcolor
  b.TextWrapped = true
  b.TextSize = guiset.size*1.15
  b.Font = guiset.font
  b.Text = "-"..tostring(t[1]).."-\n"..(t[2] and tostring(t[2]) or "")
  if #notifytable > 5 then
    local old = table.remove(notifytable,1)
    local ob = old:FindFirstChildOfClass("TextButton")
    if ob then 
    ts:Create(ob,guiset.tween,{TextTransparency=1}):Play()
    end
    ts:Create(old,guiset.tween,{BackgroundTransparency=1}):Play()
    ts:Create(old,guiset.tween,{Position=UDim2.new(1,100,0,old.AbsolutePosition.Y)}):Play()
    ts:Create(old,guiset.tween,{AnchorPoint=Vector2.new(.5,0)}):Play()
    task.delay(guiset.tween.Time,function() old:Destroy() end)
  end
  for i,f in ipairs(notifytable) do
    ts:Create(f,guiset.tween,{Position = UDim2.new(1,-5,1,-10-57*(#notifytable-i))}):Play()
  end
  ts:Create(fb,guiset.tween,{BackgroundTransparency=.4}):Play()
  ts:Create(b,guiset.tween,{TextTransparency=0}):Play()
  local function rem()
    local i = table.find(notifytable,fb)
    if not i then return end
    table.remove(notifytable,i)
    ts:Create(fb,guiset.tween,{BackgroundTransparency=1}):Play()
    ts:Create(b,guiset.tween,{TextTransparency=1}):Play()
    for k,f in ipairs(notifytable) do
      ts:Create(f,guiset.tween,{Position = UDim2.new(1,-5,1,-10-57*(#notifytable-k))}):Play()
    end
    task.wait(guiset.tween.Time)
    fb:Destroy()
  end
  b.MouseButton1Click:Connect(rem)
  task.delay(d,rem)
end

local activeslider = nil
function library.slider(t,p,cb,cfg)
  cfg = type(cfg)=="table" and cfg or {}
  local min,max = cfg.min or 0,cfg.max or 1
  local tscl = cfg.truescale or false
  local cur = math.clamp(cfg.value or min,min,max)
  local fb = knownframe:Clone()
  fb.Size = UDim2.new(.95,0,0,28)
  fb.Parent = p
  local sb = Instance.new("TextButton",fb)
  local fl = Instance.new("Frame",sb)
  local l = Instance.new("TextLabel",fb)
  sb.Size = UDim2.new(.95,0,0,12)
  sb.Position = UDim2.new(.5,0,.925,0)
  sb.AnchorPoint = Vector2.new(.5,1)
  sb.BorderSizePixel = 0
  sb.BackgroundColor3 = Color3.fromRGB(80,80,80)
  sb.ClipsDescendants = true
  sb.Text = ""
  sb.AutoButtonColor = false
  fl.Size = UDim2.new((cur-min)/(max-min),0,1,0)
  fl.BorderSizePixel = 0
  fl.BackgroundColor3 = Color3.fromRGB(160,160,160)
  l.Size = UDim2.new(1,0,0,14)
  l.BackgroundTransparency = 1
  l.TextColor3 = guiset.textcolor
  l.ClipsDescendants = true
  l.TextSize = guiset.size
  l.Font = guiset.font
  local function set(v,s)
    if s then
      v = math.clamp(v,0,1);v = min+(max-min)*v
    else
      v = math.clamp(v,min,max)
    end
    if not tscl then v = math.round(v) end
    cur = v
    fl.Size = UDim2.new((v-min)/(max-min),0,1,0)
    l.Text = t.." : "..rounded(v)
    if cb then cb(v) end
  end
  l.Text = t.." : "..rounded(cur)
  if cb then cb(cur) end
  local drag,inp
  sb.InputBegan:Connect(function(i)
    local ty = i.UserInputType
    if not inp and (activeslider == nil or activeslider == sb) and (ty==Enum.UserInputType.MouseButton1 or ty==Enum.UserInputType.Touch) then
      inp,drag,activeslider = i,true,sb
      p.ScrollingEnabled = false
      set((i.Position.X - sb.AbsolutePosition.X)/sb.AbsoluteSize.X,true)
    end
  end)
  uis.InputEnded:Connect(function(i)
    local ty = i.UserInputType
    if inp==i and (ty==Enum.UserInputType.MouseButton1 or ty==Enum.UserInputType.Touch) then
      inp,drag,activeslider = nil,false, nil
      p.ScrollingEnabled = true
    end
  end)
  uis.InputChanged:Connect(function(i)
    if inp==i and drag and activeslider == sb then
      local x = i.UserInputType==Enum.UserInputType.MouseMovement and uis:GetMouseLocation().X or i.Position.X
      set((x - sb.AbsolutePosition.X)/sb.AbsoluteSize.X,true)
    end
  end)
  return {
    value = function() return cur end,
    scale = function() return (cur-min)/(max-min) end,
    fire = function(v,s)
      if v~=nil then set(v,s)
      elseif cb then cb(cur) end
    end,
    destroy = function() fb:Destroy() end
  }
end

function library.label(t,p)
  local fb = knownframe:Clone()
  fb.Size = UDim2.new(.95,0,0,10)
  fb.Parent = p
  local l = Instance.new("TextLabel",fb)
  l.BackgroundTransparency = 1
  l.Size = UDim2.new(.95,0,.8,0)
  l.AnchorPoint = Vector2.new(.5,.5)
  l.Position = UDim2.new(.5,0,.5,0)
  l.TextXAlignment = "Center"
  l.ClipsDescendants = true
  l.TextColor3 = guiset.textcolor
  l.Active = false
  l.Text = "- "..t.." -"
  l.TextSize = guiset.size
  l.Font = guiset.font
  return l
end

local awesomesets = library.createTab("Settings")
library.switch("gui side", awesomesets, function(v)
  guiset.side = v
  closeButton.Position = v == "left" and UDim2.new(1,1,0,1) or UDim2.new(0,-1,0,1)
  closeButton.AnchorPoint = Vector2.new(v == "left" and 0 or 1,0)
  frame.AnchorPoint = Vector2.new(v == "left" and 0 or 1,.5)
  frame.Position = v == "left" and UDim2.new(0,open and 1 or frame.AbsoluteSize.X,frame.Position.Y.Scale,0) or UDim2.new(1,open and -1 or frame.AbsoluteSize.X,frame.Position.Y.Scale,0)
end, {"right","left"})
library.button("delete gui",awesomesets,function()
  gui:Destroy()
end)

return library, guiset
