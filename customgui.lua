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
  gray1 = Color3.fromRGB(80,80,80),
  gray2 = Color3.fromRGB(160,160,160),
}

local function mk(class, parent, props)
  local o = Instance.new(class)
  if parent then o.Parent = parent end
  if props then
    for k,v in pairs(props) do
      o[k] = v
    end
  end
  return o
end

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

local gui = mk("ScreenGui",game:GetService("CoreGui"),{
  Name = "co"
})

local frame = mk("Frame",gui,{
  BorderSizePixel = 1,
  BorderColor3 = guiset.bordercolor,
  Size = UDim2.new(0,150,0,121),
  Position = UDim2.new(0,1,.4,0),
  AnchorPoint = Vector2.new(0,.5),
  AnchorPoint = Vector2.new(guiset.side == "left" and 0 or 1,.5),
  Position = guiset.side == "left" and UDim2.new(0,1,.4,0) or UDim2.new(1,-1,.4,0),
  BackgroundColor3 = guiset.bordercolor,
  Active = false
})

local frame2  = mk("Frame",frame,{
  BorderSizePixel = 1,
  BorderColor3 = guiset.bordercolor,
  Size = UDim2.new(1,0,0,90),
  Position = UDim2.new(0,0,1,1),
  AnchorPoint = Vector2.new(0,0),
  BackgroundColor3 = guiset.bordercolor,
  Active = false,
  Visible = false,
})
local scrollmark = mk("ScrollingFrame",frame2,{
  Size = UDim2.new(1,0,1,0),
  Position = UDim2.new(.5,0,.5,0),
  AnchorPoint = Vector2.new(.5,.5),
  BackgroundColor3 = guiset.maincolor,
  CanvasSize = UDim2.new(0,0,.5,0),
  BorderSizePixel = 0,
  ScrollBarThickness = 0,
  ScrollingDirection = "Y",
  AutomaticCanvasSize = "Y",
})
mk("UIPadding",scrollmark,{PaddingTop = UDim.new(0,4),PaddingBottom = UDim.new(0,5)})
mk("UIGridLayout",scrollmark,{
  CellSize = UDim2.new(.5,-4,0,22),
  CellPadding = UDim2.new(0,3,0,3),
  FillDirection = "Horizontal",
  FillDirectionMaxCells = 2,
  HorizontalAlignment = "Center",
  VerticalAlignment = "Top"
})
local closeButton = mk("TextButton",frame,{
  BorderSizePixel = 1,
  BorderColor3 = guiset.bordercolor,
  BackgroundColor3 = guiset.maincolor,
  Size = UDim2.new(0,25,1,0),
  Position = guiset.side == "left" and UDim2.new(1,1,0,0) or UDim2.new(0,-1,0,0),
  AnchorPoint = Vector2.new(guiset.side == "left" and 0 or 1,0),
  Text = ""
})

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

local scrollTab = mk("ScrollingFrame",frame,{
  BorderSizePixel = 1,
  Size = UDim2.new(1,0,0,22),
  Position = UDim2.new(0,0,0,-23),
  CanvasSize = UDim2.new(0,0,0,0),
  ScrollingDirection = "X",
  AutomaticCanvasSize = "X",
  ScrollBarThickness = 0,
  BackgroundColor3 = guiset.maincolor,BorderColor3 = guiset.bordercolor,
})
mk("TextButton",scrolltab,{
  Padding = UDim.new(0,0),
  SortOrder = "LayoutOrder",
  FillDirection = "Horizontal",
  HorizontalAlignment = "Left",
})
local knownframe = mk("TextButton",nil,{
  Size = UDim2.new(.95,0,0,20),
  AnchorPoint = Vector2.new(.5,0),
  BorderSizePixel = 0,
  BackgroundColor3 = guiset.altcolor,
})
local library = {}
local tabList = {}
function library.createTab(name)
  local scroll = mk("ScrollingFrame",frame,{
    Size = UDim2.new(1,0,1,0),
    CanvasSize = UDim2.new(0,0,.5,0),
    BackgroundColor3 = guiset.maincolor,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    ScrollingDirection = "Y",
    AutomaticCanvasSize = "Y",
    Visible = false
  })
  local tabButton = mk("TextButton",scrollTab,{
    LayoutOrder = #tabList == 1 and 2 or 1,
    Size = UDim2.new(0,45,0,22),
    AnchorPoint = Vector2.new(0,.5),
    BorderSizePixel = 1,
    Text = name,
    BackgroundColor3 = guiset.maincolor,BorderColor3 = guiset.bordercolor,
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  mk("UIListLayout",scroll,{Padding = UDim.new(0,3),HorizontalAlignment = "Center"})
  mk("UIPadding",scroll,{PaddingTop = UDim.new(0,4),PaddingBottom = UDim.new(0,4)})
  table.insert(tabList, scroll)
  if #tabList <= 2 then scroll.Visible = true end
  tabButton.MouseButton1Click:Connect(function()
    for _,scr in ipairs(tabList) do scr.Visible = false end
    scroll.Visible = true
  end)
  return scroll
end

function library.button(t,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local b = mk("TextButton",fb,{
    BackgroundTransparency = 1,
    Size = UDim2.new(.95,0,1,0),
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextXAlignment = "Left",
    ClipsDescendants = true,
    Text = t,
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  if f then b.MouseButton1Click:Connect(f) end
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  return {
    fire = function() if f then f() end end,
    destroy = function() fb:Destroy() end
  }
end

function library.toggle(t,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local b = mk("TextButton",fb,{
    BackgroundTransparency = 1,
    Size = UDim2.new(.95,0,1,0),
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextXAlignment = "Left",
    ClipsDescendants = true,
    Text = t,
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  local cb = mk("Frame",b,{
    Size = UDim2.new(0,8,.8,0),
    BorderSizePixel = 0,
    Position = UDim2.new(1,0,.5,0),
    AnchorPoint = Vector2.new(1,.5),
    BackgroundColor3 = Color3.fromRGB(255,0,0),
  })
  local on = false
  local function set(v)
    if on == v then return end
    on = v
    ts:Create(cb,TweenInfo.new(.2),{BackgroundColor3 = v and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)}):Play()
    if f then f(v) end
  end
  set(false)
  b.MouseButton1Click:Connect(function() set(not on) end)
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  return {
    bool = function() return on end,
    fire = function(_,v)set(v ~= nil and v or not on) end,
    destroy = function() fb:Destroy() end
  }
end

function library.textbox(t,t2,p,f)
  local fb = knownframe:Clone()
  fb.Parent = p
  local l = mk("TextLabel",fb,{
    BackgroundTransparency = 1,
    Position = UDim2.new(0,4,0,0),
    Size = UDim2.new(0,0,1,0),
    TextXAlignment = "Left",
    ClipsDescendants = true,
    Text = t.." :",
    AutomaticSize = "X",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  local b = mk("TextBox",fb,{
    BackgroundTransparency = 1,
    TextXAlignment = "Right",
    PlaceholderText = t2,
    ClipsDescendants = true,
    Text = "",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  local pad = 5
  local function update()
    local w = math.min(l.TextBounds.X + pad, fb.AbsoluteSize.X * .75)
    l.Size = UDim2.new(0,w,1,0)
    b.Position = UDim2.new(0,w + pad,0,0)
    b.Size = UDim2.new(1,-(w + pad*2),1,0)
  end
  task.defer(update)
  l:GetPropertyChangedSignal("TextBounds"):Connect(update)
  fb:GetPropertyChangedSignal("AbsoluteSize"):Connect(update)
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
  local b = mk("TextButton",fb,{
    BackgroundTransparency = 1,
    Size = UDim2.new(.95,0,1,0),
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextXAlignment = "Left",
    Text = t.." :",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
    ClipsDescendants = true,
  })
  local l = mk("TextLabel",fb,{
    BackgroundTransparency = 1,
    Size = UDim2.new(.95,0,.8,0),
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextXAlignment = "Right",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  autobuttoncolor(b,fb,guiset.altcolor,guiset.select)
  local i = 1
  local function a(x)
    i = x
    l.Text = tostring(lst[i])
    if f then f(lst[i],i) end
  end
  a(1)
  b.MouseButton1Click:Connect(function()
    local n = (i + 1 > #lst) and 1 or (i + 1)
    a(n)
  end)
  return {
    bool = function() return lst[i] end,
    index = function() return i end,
    fire = function(v)
      if v == nil then a((i + 1 > #lst) and 1 or (i + 1))
      elseif type(v) == "number" then if lst[v] then a(v) end
      else
        for k,val in ipairs(lst) do
          if val == v then
            a(k)
            break
          end
        end
      end
    end,
    set = function(v)
      for k,val in ipairs(lst) do
        if val == v then
          a(k)
          break
        end
      end
    end,
    destroy = function() fb:Destroy() end
  }
end

local markspot, active = {}, {}
function library.markdown(t,p,f,l,m)
  m = m ~= false
  local a = {}
  local bs = {}
  local id = {}
  local c = 0
  local fb = knownframe:Clone()
  fb.Parent = p
  local lbl = mk("TextLabel",fb,{
    BackgroundTransparency = 1,
    Position = UDim2.new(0,2,0,0),
    Text = t.." :",
    AutomaticSize = "X",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  local btn = mk("TextButton",fb,{
    Position = UDim2.new(1,-4,0,0),
    AnchorPoint = Vector2.new(1,0),
    Size = UDim2.new(1,-4,1,0),
    BackgroundTransparency = 1,
    TextXAlignment = "Right",
    Text = "[ 0 ]",
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  autobuttoncolor(btn,fb,guiset.altcolor,guiset.select)
  task.wait()
  local w = math.min(lbl.TextBounds.X + 5, fb.AbsoluteSize.X * .75)
  lbl.Size = UDim2.new(0,w,1,0)
  markspot[id] = {}
  local function newButton(it)
    local b = mk("TextButton",scrollmark,{
      Size = UDim2.new(1,0,0,20),
      BorderSizePixel = 0,
      Text = tostring(it),
      Visible = false,
      BackgroundColor3 = guiset.altcolor,
      TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
    })
    b._val = it
    markspot[id][#markspot[id]+1] = b
    bs[#bs+1] = b
    local s = false
    b.MouseButton1Click:Connect(function()
      if m then
        s = not s
        if s then a[it],c,b.BackgroundColor3 = true,c+1,guiset.select
        else a[it],c,b.BackgroundColor3 = nil,c-1,guiset.altcolor end
      else
        if a[it] then a[it],c,b.BackgroundColor3 = nil,0,guiset.altcolor
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
  for i = 1, #l do newButton(l[i]) end
  btn.MouseButton1Click:Connect(function()
    if active == id then
      for _,v in ipairs(markspot[id]) do v.Visible = false end
      frame2.Visible = false
      active = nil
    else
      if active and markspot[active] then
        for _,v in ipairs(markspot[active]) do v.Visible = false end
      end
      for _,v in ipairs(markspot[id]) do v.Visible = true end
      frame2.Visible = true
      active = id
    end
  end)
  return {
    get = function() return a end,
    update = function(newList)
      local newMap = {}
      for i = 1, #newList do newMap[newList[i]] = true end
      for i = #bs, 1, -1 do
        local b = bs[i]
        local key = b._val
        if not newMap[key] then
          if a[key] then
            a[key] = nil
            c -= 1
          end
          b:Destroy()
          table.remove(bs, i)
          for j = #markspot[id], 1, -1 do
            if markspot[id][j] == b then
              table.remove(markspot[id], j)
              break
            end
          end
        else newMap[key] = nil
        end
      end
      for i = 1, #newList do
        local it = newList[i]
        if newMap[it] then newButton(it) end
      end
      btn.Text = ("[ %d ]"):format(c)
    end,
    destroy = function()
      for _,b in ipairs(bs) do b:Destroy() end
      markspot[id] = nil
      fb:Destroy()
    end
  }
end

local notifytable = {}
function library.notify(d,t)
  local fb = mk("Frame", gui, {
    Size = UDim2.new(0,120,0,53),
    Position = UDim2.new(1,100,1,-10),
    AnchorPoint = Vector2.new(1,1),
    BorderSizePixel = 1,
    BackgroundTransparency = 1,
    BorderColor3 = guiset.bordercolor,BackgroundColor3 = guiset.maincolor,
  })
  notifytable[#notifytable+1] = fb
  local b = mk("TextButton", fb, {
    BackgroundTransparency = 1,
    TextTransparency = 1,
    Size = UDim2.new(.9,0,.9,0),
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextWrapped = true,
    TextColor3 = guiset.textcolor,TextSize = guiset.size * 1.15,Font = guiset.font,
    Text = "-"..tostring(t[1]).."-\n"..(t[2] and tostring(t[2]) or ""),
  })
  if #notifytable > 5 then
    local old = table.remove(notifytable,1)
    local ob = old:FindFirstChildOfClass("TextButton")
    if ob then ts:Create(ob,guiset.tween,{TextTransparency = 1}):Play() end
    ts:Create(old,guiset.tween,{BackgroundTransparency = 1}):Play()
    ts:Create(old,guiset.tween,{Position = UDim2.new(1,100,0,old.AbsolutePosition.Y)}):Play()
    ts:Create(old,guiset.tween,{AnchorPoint = Vector2.new(.5,0)}):Play()
    task.delay(guiset.tween.Time,function() old:Destroy() end)
  end
  for i,f in ipairs(notifytable) do ts:Create(f,guiset.tween,{Position = UDim2.new(1,-5,1,-10-57*(#notifytable-i))}):Play() end
  ts:Create(fb, guiset.tween, {BackgroundTransparency = .4}):Play()
  ts:Create(b, guiset.tween, {TextTransparency = 0}):Play()
  local function rem()
    local i = table.find(notifytable, fb)
    if not i then return end
    table.remove(notifytable, i)
    ts:Create(fb,guiset.tween,{BackgroundTransparency = 1}):Play()
    ts:Create(b,guiset.tween,{TextTransparency = 1}):Play()
    for k,f in ipairs(notifytable) do ts:Create(f,guiset.tween,{Position = UDim2.new(1,-5,1,-10-57*(#notifytable-k))}):Play() end
    task.wait(guiset.tween.Time)
    fb:Destroy()
  end
  b.MouseButton1Click:Connect(rem)
  task.delay(d, rem)
end

local activeslider = nil
function library.slider(t,p,cb,cfg)
  cfg = type(cfg)=="table" and cfg or {}
  local min,max = cfg.min or 0,cfg.max or 1
  if min == max then max = min + 1 end
  local tscl = cfg.truescale or false
  local cur = math.clamp(cfg.value or min,min,max)

  local fb = knownframe:Clone()
  fb.Size = UDim2.new(.95,0,0,28)
  fb.Parent = p
  local sb = mk("TextButton",fb,{
    Size = UDim2.new(.95,0,0,12),
    Position = UDim2.new(.5,0,.925,0),
    AnchorPoint = Vector2.new(.5,1),
    BorderSizePixel = 0,
    BackgroundColor3 = gray1,
    ClipsDescendants = true,
    Text = "",
    AutoButtonColor = false
  })
  local fl = mk("Frame",sb,{BorderSizePixel = 0,BackgroundColor3 = gray2})
  local l = mk("TextLabel",fb,{
    Size = UDim2.new(1,0,0,14),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
    TextSize = guiset.size,Font = guiset.font,TextColor3 = guiset.textcolor,
  })
  local function scale(v) return (v-min)/(max-min) end
  local function set(v,s)
    if s then v = math.clamp(v,0,1);v = min + (max-min)*v
    else v = math.clamp(v,min,max)
    end
    if not tscl then v = math.round(v) end
    if v == cur then return end
    cur = v
    fl.Size = UDim2.new(scale(v),0,1,0)
    l.Text = t.." : "..rounded(v)
    if cb then cb(v) end
  end
  fl.Size = UDim2.new(scale(cur),0,1,0)
  l.Text = t.." : "..rounded(cur)
  if cb then cb(cur) end
  local inp
  sb.InputBegan:Connect(function(i)
    local ty = i.UserInputType
    if inp then return end
    if activeslider and activeslider ~= sb then return end
    if ty==Enum.UserInputType.MouseButton1 or ty==Enum.UserInputType.Touch then
      inp = i
      activeslider = sb
      p.ScrollingEnabled = false
      set((i.Position.X - sb.AbsolutePosition.X)/sb.AbsoluteSize.X,true)
    end
  end)
  uis.InputEnded:Connect(function(i)
    if inp ~= i then return end
    local ty = i.UserInputType
    if ty==Enum.UserInputType.MouseButton1 or ty==Enum.UserInputType.Touch then
      inp = nil
      activeslider = nil
      p.ScrollingEnabled = true
    end
  end)
  uis.InputChanged:Connect(function(i)
    if inp ~= i then return end
    if activeslider ~= sb then return end
    local ty = i.UserInputType
    if ty ~= Enum.UserInputType.MouseMovement and ty ~= Enum.UserInputType.Touch then return end
    local x = (ty==Enum.UserInputType.MouseMovement and uis:GetMouseLocation().X or i.Position.X)
    set((x - sb.AbsolutePosition.X)/sb.AbsoluteSize.X,true)
  end)
  return {
    value = function() return cur end,
    scale = function() return scale(cur) end,
    fire = function(v,s)
      if v ~= nil then set(v,s)
      elseif cb then cb(cur) end
    end,
    destroy = function()
      if activeslider == sb then
        activeslider = nil
        p.ScrollingEnabled = true
      end
      fb:Destroy()
    end
  }
end

function library.label(t,p)
  local fb = knownframe:Clone()
  fb.Size = UDim2.new(.95,0,0,12)
  fb.Parent = p
  local l = mk("TextLabel", fb, {
    Size = UDim2.new(.95,0,.8,0),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(.5,.5),
    Position = UDim2.new(.5,0,.5,0),
    TextXAlignment = "Center",
    ClipsDescendants = true,
    Active = false,
    TextColor3 = guiset.textcolor,TextSize = guiset.size,Font = guiset.font,
  })

  l:GetPropertyChangedSignal("TextBounds"):Connect(function()
    fb.Size = UDim2.new(.95,0,0,math.min(l.TextBounds.Y + 5, 12))
  end)
  l.Text = t
  return l
end

local awesomesets = library.createTab("Settings")
library.switch("gui side", awesomesets, function(v)
  guiset.side = v
  closeButton.Position = v == "left" and UDim2.new(1,1,0,0) or UDim2.new(0,-1,0,0)
  closeButton.AnchorPoint = Vector2.new(v == "left" and 0 or 1,0)
  frame.AnchorPoint = Vector2.new(v == "left" and 0 or 1,.5)
  frame.Position = v == "left" and UDim2.new(0,open and 1 or frame.AbsoluteSize.X,frame.Position.Y.Scale,0) or UDim2.new(1,open and -1 or frame.AbsoluteSize.X,frame.Position.Y.Scale,0)
end, {"right","left"})
library.button("delete gui",awesomesets,function()
  gui:Destroy()
end)

return library, guiset
