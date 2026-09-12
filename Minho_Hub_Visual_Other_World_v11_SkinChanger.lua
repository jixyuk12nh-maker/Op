local HOME_DIR = "Minho Hub/"
local CONFIG_DIR = HOME_DIR .. "Config/"
local function ensureFolder(path)
    if makefolder then
        if isfolder then
            if not isfolder(path) then pcall(makefolder, path) end
        else
            pcall(makefolder, path)
        end
    end
end
ensureFolder(HOME_DIR)
ensureFolder(CONFIG_DIR)

-- Source
do
    repeat task.wait() until game:IsLoaded()

    local function safeRef(ref)
    	return cloneref and cloneref(ref) or ref
    end

    local setidentity = setthreadcontext or setthreadidentity or set_thread_identity or set_thread_context or setidentity

    local RunService= safeRef(game:GetService("RunService"))
    local UserInputService= safeRef(game:GetService("UserInputService"))
    local CoreGui= safeRef(game:GetService("CoreGui"))
    local HttpService= safeRef(game:GetService("HttpService"))

    LPH_NO_VIRTUALIZE = function(f) return f end
    LPH_NO_UPVALUES = function(f) return f end

    local Trove = LPH_NO_VIRTUALIZE(function()

    local FN_MARKER = newproxy()
    local THREAD_MARKER = newproxy()
    local GENERIC_OBJECT_CLEANUP_METHODS = table.freeze({ "Destroy", "Disconnect", "destroy", "disconnect" })

    local function GetObjectCleanupFunction(object, cleanupMethod)
    	local t = typeof(object)

    	if t == "function" then
    		return FN_MARKER
    	elseif t == "thread" then
    		return THREAD_MARKER
    	end

    	if cleanupMethod then
    		return cleanupMethod
    	end

    	if t == "Instance" then
    		return "Destroy"
    	elseif t == "RBXScriptConnection" then
    		return "Disconnect"
    	elseif t == "table" then
    		for _, genericCleanupMethod in GENERIC_OBJECT_CLEANUP_METHODS do
    			if typeof(object[genericCleanupMethod]) == "function" then
    				return genericCleanupMethod
    			end
    		end
    	end

    	error(("failed to get cleanup function for object %s: %s"):format(t, object), 3)
    end

    local function AssertPromiseLike(object)
    	if
    		typeof(object) ~= "table"
    		or typeof(object.getStatus) ~= "function"
    		or typeof(object.finally) ~= "function"
    		or typeof(object.cancel) ~= "function"
    	then
    		error("did not receive a promise as an argument", 3)
    	end
    end
    local Trove = {}
    Trove.__index = Trove
    function Trove.new()
    local self = setmetatable({}, Trove)

    	self._objects = {}
    	self._cleaning = false

    	return (self )
    end






    function Trove.Add(self, object, cleanupMethod)
    if self._cleaning then
    		error("cannot call trove:Add() while cleaning", 2)
    	end

    	local cleanup = GetObjectCleanupFunction(object, cleanupMethod)
    	table.insert(self._objects, { object, cleanup })

    	return object
    end
    function Trove.Clone(self, instance)
    if self._cleaning then
    		error("cannot call trove:Clone() while cleaning", 2)
    	end

    	return self:Add(instance:Clone())
    end



    function Trove.Construct(self, class, ...)
    	if self._cleaning then
    		error("Cannot call trove:Construct() while cleaning", 2)
    	end

    	local object = nil
    	local t = type(class)
    	if t == "table" then
    		object = (class ).new(...)
    	elseif t == "function" then
    		object = (class )(...)
    	end

    	return self:Add(object)
    end
    function Trove.Connect(self, signal, fn)
    	if self._cleaning then
    		error("Cannot call trove:Connect() while cleaning", 2)
    	end

    	return self:Add(signal:Connect(fn))
    end

    function Trove.BindToRenderStep(self, name, priority, fn)
    	if self._cleaning then
    		error("cannot call trove:BindToRenderStep() while cleaning", 2)
    	end

    	RunService:BindToRenderStep(name, priority, fn)

    	self:Add(function()
    		RunService:UnbindFromRenderStep(name)
    	end)
    end


    function Trove.AddPromise(self, promise)
    	if self._cleaning then
    		error("cannot call trove:AddPromise() while cleaning", 2)
    	end
    	AssertPromiseLike(promise)

    	if promise:getStatus() == "Started" then
    		promise:finally(function()
    			if self._cleaning then
    				return
    			end
    			self:_findAndRemoveFromObjects(promise, false)
    		end)

    		self:Add(promise, "cancel")
    	end

    	return promise
    end

    function Trove.Remove(self, object)
    if self._cleaning then
    		error("cannot call trove:Remove() while cleaning", 2)
    	end

    	return self:_findAndRemoveFromObjects(object, true)
    end

    function Trove.Extend(self)
    	if self._cleaning then
    		error("cannot call trove:Extend() while cleaning", 2)
    	end

    	return self:Construct(Trove)
    end

    function Trove.Clean(self)
    	if self._cleaning then
    		return
    	end

    	self._cleaning = true

    	for _, obj in self._objects do
    		self:_cleanupObject(obj[1], obj[2])
    	end

    	table.clear(self._objects)
    	self._cleaning = false
    end

    function Trove._findAndRemoveFromObjects(self, object, cleanup)
    local objects = self._objects

    	for i, obj in ipairs(objects) do
    		if obj[1] == object then
    			local n = #objects
    			objects[i] = objects[n]
    			objects[n] = nil

    			if cleanup then
    				self:_cleanupObject(obj[1], obj[2])
    			end

    			return true
    		end
    	end

    	return false
    end

    function Trove._cleanupObject(self, object, cleanupMethod)
    	if cleanupMethod == FN_MARKER then
    		object()
    	elseif cleanupMethod == THREAD_MARKER then
    		pcall(task.cancel, object)
    	else
    		object[cleanupMethod](object)
    	end
    end

    function Trove.AttachToInstance(self, instance)
    	if self._cleaning then
    		error("cannot call trove:AttachToInstance() while cleaning", 2)
    	elseif not instance:IsDescendantOf(game) then
    		error("instance is not a descendant of the game hierarchy", 2)
    	end

    	return self:Connect(instance.Destroying, function()
    		self:Destroy()
    	end)
    end

    function Trove.Destroy(self)
    	self:Clean()
    end

    return {
    	new = Trove.new,
    }
    end)()


    local Signal = LPH_NO_VIRTUALIZE(function()



    local freeRunnerThread = nil
    local function acquireRunnerThreadAndCallEventHandler(fn, ...)
    	local acquiredRunnerThread = freeRunnerThread
    	freeRunnerThread = nil
    	fn(...)

    	freeRunnerThread = acquiredRunnerThread
    end

    local function runEventHandlerInFreeThread(...)
    	acquireRunnerThreadAndCallEventHandler(...)
    	while true do
    		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
    	end
    end


    local Connection = {}
    Connection.__index = Connection

    function Connection:Disconnect()
    	if not self.Connected then
    		return
    	end
    	self.Connected = false


    	if self._signal._handlerListHead == self then
    		self._signal._handlerListHead = self._next
    	else
    		local prev = self._signal._handlerListHead
    		while prev and prev._next ~= self do
    			prev = prev._next
    		end
    		if prev then
    			prev._next = self._next
    		end
    	end
    end

    Connection.Destroy = Connection.Disconnect


    setmetatable(Connection, {
    	__index = function(_tb, key)
    		error(("Attempt to get Connection::%s (not a valid member)"):format(tostring(key)), 2)
    	end,
    	__newindex = function(_tb, key, _value)
    		error(("Attempt to set Connection::%s (not a valid member)"):format(tostring(key)), 2)
    	end,
    })



    local Signal = {}
    Signal.__index = Signal
    function Signal.new()
    local self = setmetatable({
    		_handlerListHead = false,
    		_proxyHandler = nil,
    		_yieldedThreads = nil,
    	}, Signal)

    	return self
    end


    function Signal.Wrap(rbxScriptSignal)
    assert(
    		typeof(rbxScriptSignal) == "RBXScriptSignal",
    		"Argument #1 to Signal.Wrap must be a RBXScriptSignal; got " .. typeof(rbxScriptSignal)
    	)

    	local signal = Signal.new()
    	signal._proxyHandler = rbxScriptSignal:Connect(function(...)
    		signal:Fire(...)
    	end)

    	return signal
    end

    function Signal.Is(obj)
    return type(obj) == "table" and getmetatable(obj) == Signal
    end


    function Signal:Connect(fn)
    	local connection = setmetatable({
    		Connected = true,
    		_signal = self,
    		_fn = fn,
    		_next = false,
    	}, Connection)

    	if self._handlerListHead then
    		connection._next = self._handlerListHead
    		self._handlerListHead = connection
    	else
    		self._handlerListHead = connection
    	end

    	return connection
    end
    function Signal:ConnectOnce(fn)
    	return self:Once(fn)
    end

    function Signal:Once(fn)
    	local connection
    	local done = false

    	connection = self:Connect(function(...)
    		if done then
    			return
    		end

    		done = true
    		connection:Disconnect()
    		fn(...)
    	end)

    	return connection
    end

    function Signal:GetConnections()
    	local items = {}

    	local item = self._handlerListHead
    	while item do
    		table.insert(items, item)
    		item = item._next
    	end

    	return items
    end
    function Signal:DisconnectAll()
    	local item = self._handlerListHead
    	while item do
    		item.Connected = false
    		item = item._next
    	end
    	self._handlerListHead = false

    	local yieldedThreads = rawget(self, "_yieldedThreads")
    	if yieldedThreads then
    		for thread in yieldedThreads do
    			if coroutine.status(thread) == "suspended" then
    				warn(debug.traceback(thread, "signal disconnected; yielded thread cancelled", 2))
    				task.cancel(thread)
    			end
    		end
    		table.clear(self._yieldedThreads)
    	end
    end

    function Signal:Fire(...)
    	local item = self._handlerListHead
    	while item do
    		if item.Connected then
    			if not freeRunnerThread then
    				freeRunnerThread = coroutine.create(runEventHandlerInFreeThread)
    			end
    			task.spawn(freeRunnerThread, item._fn, ...)
    		end
    		item = item._next
    	end
    end
    function Signal:FireDeferred(...)
    	local item = self._handlerListHead
    	while item do
    		local conn = item
    		task.defer(function(...)
    			if conn.Connected then
    				conn._fn(...)
    			end
    		end, ...)
    		item = item._next
    	end
    end

    function Signal:Wait()
    	local yieldedThreads = rawget(self, "_yieldedThreads")
    	if not yieldedThreads then
    		yieldedThreads = {}
    		rawset(self, "_yieldedThreads", yieldedThreads)
    	end

    	local thread = coroutine.running()
    	yieldedThreads[thread] = true

    	self:Once(function(...)
    		yieldedThreads[thread] = nil
    		task.spawn(thread, ...)
    	end)

    	return coroutine.yield()
    end

    function Signal:Destroy()
    	self:DisconnectAll()

    	local proxyHandler = rawget(self, "_proxyHandler")
    	if proxyHandler then
    		proxyHandler:Disconnect()
    	end
    end


    setmetatable(Signal, {
    	__index = function(_tb, key)
    		error(("Attempt to get Signal::%s (not a valid member)"):format(tostring(key)), 2)
    	end,
    	__newindex = function(_tb, key, _value)
    		error(("Attempt to set Signal::%s (not a valid member)"):format(tostring(key)), 2)
    	end,
    })

    return table.freeze({
    	new = Signal.new,
    	Wrap = Signal.Wrap,
    	Is = Signal.Is,
    })
    end)()


    local function inside(x, y, pX, pY, sX, sY)
    return x > pX and x < pX + sX and y > pY and y < pY + sY
    end

    local function insideFrame(input, frame)
    	local position = frame.AbsolutePosition
    	local size = frame.AbsoluteSize

    	return inside(input.X, input.Y, position.X, position.Y, size.X, size.Y)
    end

    local function deepCopy(t)
    local copy = {}

    	for k, v in t do
    		if type(v) == "table" then
    			v = deepCopy(v)
    		end

    		copy[k] = v
    	end

    	return copy
    end







    local UISection = {}
    UISection.__index = UISection
    do
    	function UISection.new(parent, side, label)
    local self = setmetatable({}, UISection)
    		self._trove = parent._trove:Extend()
    		self.instances = {}
    		self.parent = parent

    		return UISection.into((self ) , side, label)
    	end

    	function UISection.setLabel(self, label)
    		assert(label, "UISection.setLabel(_, _, label) -> expected string got nil")
    		assert(typeof(label) == "string", "UISection.setLabel(_, _, label) -> expected string, got " .. typeof(label))

    		self.instances.label.Text = label
    	end

    	function UISection._makeInstances(self, side)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    		container.BorderColor3 = Color3.fromRGB(50, 50, 50)
    		container.Size = UDim2.new(1, -2, 0, 22)
    		self.instances.container = container

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		inline.BorderSizePixel = 0
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.Parent = container

    		local theme= Instance.new("Frame")
    		theme.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
    		theme.BorderSizePixel = 0
    		theme.Size = UDim2.new(1, 0, 0, 2)
    		theme.Parent = inline

    		local label= Instance.new("TextLabel")
    		label.BackgroundTransparency = 1
    		label.Font = Enum.Font.Arial
    		label.TextSize = 12
    		label.TextStrokeTransparency = 0
    		label.TextColor3 = Color3.fromRGB(255, 255, 255)
    		label.TextXAlignment = Enum.TextXAlignment.Left
    		label.Position = UDim2.new(0, 3, 0, 5)
    		label.Size = UDim2.new(1, -6, 0, 11)
    		label.Parent = inline
    		self.instances.label = label

    		local canvas= Instance.new("Frame")
    		canvas.Position = UDim2.new(0, 0, 1, 0)
    		canvas.Size = UDim2.new(1, 0, 1, -20)
    		canvas.AnchorPoint = Vector2.new(0, 1)
    		canvas.BackgroundTransparency = 1
    		canvas.Parent = inline
    		self.instances.canvas = canvas

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.Padding = UDim.new(0, 4)
    		listLayout.FillDirection = Enum.FillDirection.Vertical
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = canvas

    		container.Parent = self.parent.canvas[side]
    	end

    	function UISection.into(self, side, label)
    self:_makeInstances(side)
    		self:setLabel(label)
    		return self
    	end
    end

    local UISectionHolder = {}
    UISectionHolder.__index = UISectionHolder
    do
    	function UISectionHolder.new(parent)
    local self = setmetatable({}, UISectionHolder)
    		self._trove = parent._trove:Extend()
    		self.sections = {
    			left = {},
    			right = {},
    		}
    		self.parent = parent

    		return UISectionHolder.into((self ) )
    	end

    	function UISectionHolder.newSection(self, side, label)
    assert(side, "UIExtendable.newSection(_, side) : _ -> expected string got nil")
    		assert(typeof(side) == "string", "UIExtendable.newSection(_, side) : _ -> expected string, got " .. typeof(side))
    		assert(side == "left" or side == "right", "UIExtendable.newSection(_, side) : _ -> expected { \"Left\" | \"Right\" }, got \"" .. side .. "\"")

    		return UISection.new(self, side, label)
    	end

    	function UISectionHolder._makeInstances(self)
    		assert(self.sections, "UIExtendable._makeSectionInstances(_) -> internal failure")

    		local leftCanvas= Instance.new("ScrollingFrame")
    		leftCanvas.BackgroundTransparency = 1
    		leftCanvas.Position = UDim2.new(0, 5, 0, 5)
    		leftCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
    		leftCanvas.Size = UDim2.new(0.5, -8, 1, -10)
    		leftCanvas.BorderSizePixel = 0
    		leftCanvas.CanvasSize = UDim2.new(0, 0)
    		leftCanvas.ScrollBarThickness = 1

    		local uiLayout = Instance.new("UIListLayout")
    		uiLayout.Padding = UDim.new(0, 7)
    		uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    		uiLayout.Parent = leftCanvas

    		local uiPadding = Instance.new("UIPadding")
    		uiPadding.PaddingTop = UDim.new(0, 1)
    		uiPadding.PaddingBottom = UDim.new(0, 1)
    		uiPadding.Parent = leftCanvas

    		local rightCanvas= Instance.new("ScrollingFrame")
    		rightCanvas.BackgroundTransparency = 1
    		rightCanvas.Position = UDim2.new(0.5, 3, 0, 5)
    		rightCanvas.AutomaticCanvasSize = Enum.AutomaticSize.Y
    		rightCanvas.Size = UDim2.new(0.5, -8, 1, -10)
    		rightCanvas.BorderSizePixel = 0
    		rightCanvas.CanvasSize = UDim2.new(0, 0)
    		rightCanvas.ScrollBarThickness = 1

    		local uiLayout = Instance.new("UIListLayout")
    		uiLayout.Padding = UDim.new(0, 7)
    		uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    		uiLayout.Parent = rightCanvas

    		local uiPadding = Instance.new("UIPadding")
    		uiPadding.PaddingTop = UDim.new(0, 1)
    		uiPadding.PaddingBottom = UDim.new(0, 1)
    		uiPadding.Parent = rightCanvas

    		self.canvas = {
    			left = leftCanvas,
    			right = rightCanvas,
    		}

    		leftCanvas.Parent = self.parent.instances.canvas
    		rightCanvas.Parent = self.parent.instances.canvas
    	end

    	function UISectionHolder.into(self)
    self:_makeInstances()
    		return self
    	end
    end

    local UIExtendable = {}
    UIExtendable.__index = UIExtendable
    do
    	function UIExtendable.new()
    local self = setmetatable({}, UIExtendable)
    		self.instances = {}
    		self.visible = false

    		return UIExtendable.into((self ) )
    	end

    	function UIExtendable.into(self)
    return self
    	end

    	function UIExtendable.intoSections(self)
    local child = UISectionHolder.new(self)
    		self.child = child

    		return child
    	end
    end


    local UIColorpickerMenu = {}
    UIColorpickerMenu.__index = UIColorpickerMenu
    do
    	function UIColorpickerMenu.new(base)
    		local self = setmetatable({}, UIColorpickerMenu)
    		self._trove = base._trove:Extend()

    		self.instances = {}
    		self.ref = base
    		self.options = {}

    		return UIColorpickerMenu.into((self ) )
    	end

    	function UIColorpickerMenu.attach(self, colorpicker, base)
    		if base.activeMenu ~= "none" then
    			self:detach(base )
    		end

    		self.feature = colorpicker

    		if colorpicker.hasAlpha then
    			self.instances.alphaPicker.Visible = true
    			self.instances.container.Size = UDim2.new(0, 246, 0, 260)
    		else
    			self.instances.alphaPicker.Visible = false
    			self.instances.container.Size = UDim2.new(0, 246, 0, 236)
    		end

    		self._trove:Connect(UserInputService.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				local inputX, inputY = input.Position.X, input.Position.Y

    				local container = self.instances.container
    				local position, size = container.AbsolutePosition, container.AbsoluteSize

    				if inside(inputX, inputY, position.X, position.Y, size.X, size.Y) then
    					return
    				end

    				local outline = colorpicker.instances.container
    				local absPosition, absSize = outline.AbsolutePosition, outline.AbsoluteSize

    				if not inside(inputX, inputY, absPosition.X, absPosition.Y, absSize.X, absSize.Y) then
    					self:detach(base)

    					colorpicker.open = false
    				end
    			end
    		end)

    		self._trove:Connect((colorpicker.changed ), function(state)
    			local h, s, v = state.rgb:ToHSV()

    			self.instances.saturationGradient.Color = ColorSequence.new({
    				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    				ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1)),
    			})

    			self.instances.huePosition.Position = UDim2.new(0.5, -4, 0, math.clamp(200 - (h * 200), 0, 198))
    			self.instances.chromePosition.Position = UDim2.new(0, math.clamp((s * 200), 0, 196), 0, math.clamp(200 - (v * 200), 0, 196))

    			self.instances.alphaPosition.Position = UDim2.new(0, math.clamp(state.alpha * 224, 0, 222), 0.5, -4)
    		end)


    		do
    			local h, s, v = colorpicker.value.rgb:ToHSV()

    			self.instances.saturationGradient.Color = ColorSequence.new({
    				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    				ColorSequenceKeypoint.new(1, Color3.fromHSV(h, 1, 1)),
    			})

    			self.instances.huePosition.Position = UDim2.new(0.5, -4, 0, math.clamp(200 - (h * 200), 0, 198))
    			self.instances.chromePosition.Position = UDim2.new(0, math.clamp((s * 200), 0, 196), 0, math.clamp(200 - (v * 200), 0, 196))

    			self.instances.alphaPosition.Position = UDim2.new(0, math.clamp(colorpicker.value.alpha * 224, 0, 222), 0.5, -4)
    		end

    		base:makeDraggable(self.instances.huePicker, self._trove, function(input)
    			local inline = self.instances.huePicker
    			local position = input.Position

    			local percent = 1 - math.clamp((position.Y - inline.AbsolutePosition.Y) / inline.AbsoluteSize.Y, 0, 1)

    			local h, s, v = colorpicker.value.rgb:ToHSV()
    			colorpicker:set({ rgb = Color3.fromHSV(percent, s, v), alpha = colorpicker.value.alpha })

    			self.instances.huePosition.Position = UDim2.new(0.5, -4, 0, math.clamp(200 - (percent * 200), 0, 198))
    		end)

    		base:makeDraggable(self.instances.chromePicker, self._trove, function(input)
    			local inline = self.instances.chromePicker
    			local position = input.Position

    			local percentX = math.clamp((position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X, 0, 1)
    			local percentY = math.clamp((position.Y - inline.AbsolutePosition.Y) / inline.AbsoluteSize.Y, 0, 1)

    			local h, s, v = colorpicker.value.rgb:ToHSV()

    			colorpicker:set({ rgb = Color3.fromHSV(h, percentX, 1 - percentY), alpha = colorpicker.value.alpha })

    			self.instances.chromePosition.Position = UDim2.new(0, math.clamp((percentX * 200), 0, 196), 0, math.clamp(200 - ((1 - percentY) * 200), 0, 196))
    		end)

    		if colorpicker.hasAlpha then
    			base:makeDraggable(self.instances.alphaPicker, self._trove, function(input)
    				local inline = self.instances.alphaPicker
    				local position = input.Position

    				local percent = math.clamp((position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X, 0, 1)

    				colorpicker:set({ rgb = colorpicker.value.rgb, alpha = percent })
    			end)
    		end

    		self.instances.container.Position = UDim2.new(0, colorpicker.instances.container.AbsolutePosition.X, 0, colorpicker.instances.container.AbsolutePosition.Y + 74)

    		self.instances.container.Parent = base.instances.gui
    		base.activeMenu = "color"
    	end

    	function UIColorpickerMenu.detach(self, base)
    		if not self.feature then
    			return
    		end

    		self.feature.open = false
    		self.feature = nil

    		base.activeMenu = "none"
    		self.instances.container.Parent = nil
    		self._trove:Clean()
    	end

    	function UIColorpickerMenu._makeInstances(self)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
    		container.BorderSizePixel = 1
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.Size = UDim2.new(0, 246, 0, 236)
    		container.ZIndex = 2
    		self.instances.container = container

    		local background= Instance.new("Frame")
    		background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		background.BorderSizePixel = 0
    		background.Position = UDim2.new(0, 1, 0, 1)
    		background.Size = UDim2.new(1, -2, 1, -2)
    		background.ZIndex = 2
    		background.Parent = container

    		local title= Instance.new("TextLabel")
    		title.Font = Enum.Font.Arial
    		title.Position = UDim2.new(0, 4, 0, 4)
    		title.Size = UDim2.new(1, -8, 0, 11)
    		title.ZIndex = 2
    		title.BackgroundTransparency = 1
    		title.TextColor3 = Color3.fromRGB(255, 255, 255)
    		title.TextStrokeTransparency = 0
    		title.TextSize = 12
    		title.Text = "Colorpicker"
    		title.TextXAlignment = Enum.TextXAlignment.Left
    		title.Parent = background

    		local canvas= Instance.new("Frame")
    		canvas.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    		canvas.BorderColor3 = Color3.fromRGB(50, 50, 50)
    		canvas.Position = UDim2.new(0, 5, 0, 19)
    		canvas.Size = UDim2.new(1, -10, 1, -24)
    		canvas.ZIndex = 2
    		canvas.Parent = background

    		local inline= Instance.new("Frame")
    		inline.ZIndex = 2
    		inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BorderSizePixel = 0
    		inline.Parent = canvas

    		local huePicker= Instance.new("TextButton")
    		huePicker.Text = ""
    		huePicker.AutoButtonColor = false
    		huePicker.BorderSizePixel = 0
    		huePicker.Position = UDim2.new(0, 208, 0, 4)
    		huePicker.Size = UDim2.new(0, 20, 0, 200)
    		huePicker.ZIndex = 2
    		huePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		huePicker.Parent = inline
    		self.instances.huePicker = huePicker

    		local hueGradient= Instance.new("UIGradient")
    		hueGradient.Rotation = 90
    		hueGradient.Color = ColorSequence.new({
    			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    			ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 0, 255)),
    			ColorSequenceKeypoint.new(0.335, Color3.fromRGB(0, 0, 255)),
    			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
    			ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 255, 0)),
    			ColorSequenceKeypoint.new(0.84, Color3.fromRGB(255, 255, 0)),
    			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    		})
    		hueGradient.Parent = huePicker

    		local huePosition= Instance.new("Frame")
    		huePosition.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		huePosition.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		huePosition.Position = UDim2.new(0.5, -4, 0, 0)
    		huePosition.Size = UDim2.new(0, 8, 0, 2)
    		huePosition.ZIndex = 2
    		huePosition.Parent = huePicker
    		self.instances.huePosition = huePosition

    		local chromePicker= Instance.new("TextButton")
    		chromePicker.Text = ""
    		chromePicker.AutoButtonColor = false
    		chromePicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		chromePicker.BorderSizePixel = 0
    		chromePicker.Position = UDim2.new(0, 4, 0, 4)
    		chromePicker.Size = UDim2.new(0, 200, 0, 200)
    		chromePicker.ZIndex = 2
    		chromePicker.Parent = inline
    		self.instances.chromePicker = chromePicker

    		local saturation= Instance.new("Frame")
    		saturation.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		saturation.BorderSizePixel = 0
    		saturation.Size = UDim2.new(1, 0, 1, 0)
    		saturation.ZIndex = 2
    		saturation.Parent = chromePicker

    		local saturationGradient= Instance.new("UIGradient")
    		saturationGradient.Color = ColorSequence.new({
    			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
    		})
    		saturationGradient.Transparency = NumberSequence.new({
    			NumberSequenceKeypoint.new(0, 1),
    			NumberSequenceKeypoint.new(1, 0),
    		})
    		saturationGradient.Parent = saturation
    		self.instances.saturationGradient = saturationGradient

    		local brightness= Instance.new("Frame")
    		brightness.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		brightness.BorderSizePixel = 0
    		brightness.Size = UDim2.new(1, 0, 1, 0)
    		brightness.ZIndex = 2
    		brightness.Parent = chromePicker

    		local brightnessGradient= Instance.new("UIGradient")
    		brightnessGradient.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
    		brightnessGradient.Rotation = 90
    		brightnessGradient.Transparency = NumberSequence.new({
    			NumberSequenceKeypoint.new(0, 1),
    			NumberSequenceKeypoint.new(1, 0),
    		})
    		brightnessGradient.Parent = brightness

    		local chromePosition= Instance.new("Frame")
    		chromePosition.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		chromePosition.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		chromePosition.Position = UDim2.new(0, 0, 0, 0)
    		chromePosition.Size = UDim2.new(0, 4, 0, 4)
    		chromePosition.ZIndex = 2
    		chromePosition.Parent = chromePicker
    		self.instances.chromePosition = chromePosition

    		local alphaPicker= Instance.new("TextButton")
    		alphaPicker.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		alphaPicker.BorderSizePixel = 0
    		alphaPicker.Position = UDim2.new(0, 4, 0, 208)
    		alphaPicker.Size = UDim2.new(0, 224, 0, 20)
    		alphaPicker.ZIndex = 2
    		alphaPicker.Text = ""
    		alphaPicker.AutoButtonColor = false
    		alphaPicker.Parent = inline
    		self.instances.alphaPicker = alphaPicker

    		local alphaGradient= Instance.new("UIGradient")
    		alphaGradient.Color = ColorSequence.new({
    			ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
    		})
    		alphaGradient.Parent = alphaPicker

    		local alphaPosition= Instance.new("Frame")
    		alphaPosition.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		alphaPosition.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		alphaPosition.Position = UDim2.new(0, 0, 0.5, -4)
    		alphaPosition.Size = UDim2.new(0, 2, 0, 8)
    		alphaPosition.ZIndex = 2
    		alphaPosition.Parent = alphaPicker
    		self.instances.alphaPosition = alphaPosition
    	end

    	function UIColorpickerMenu.into(self)
    self:_makeInstances()
    		return self
    	end

    	function UIColorpickerMenu.Destroy(self)

    	end
    end
    local UIDropdownMenu = {}
    UIDropdownMenu.__index = UIDropdownMenu
    do
    	function UIDropdownMenu.new(base)
    		local self = setmetatable({}, UIDropdownMenu)
    		self._trove = base._trove:Extend()

    		self.instances = {}
    		self.ref = base
    		self.options = {}

    		return UIDropdownMenu.into((self ) )
    	end

    	function UIDropdownMenu.resize(self)
    		assert(self.feature, "")
    		self.instances.container.Size = UDim2.new(1, 0, 0, math.min(6, #self.feature.options) * 17 + 1)
    	end

    	function UIDropdownMenu.add(self, option)
    assert(self.feature, "")
    		local trove = self._trove:Extend()

    		local outline= Instance.new("TextButton")
    		outline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		outline.BorderColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.Size = UDim2.new(1, 0, 0, 16)
    		outline.AutoButtonColor = false
    		outline.Text = ""
    		outline.ZIndex = 2

    		local label= Instance.new("TextLabel")
    		label.Font = Enum.Font.Arial
    		label.TextSize = 12
    		label.TextStrokeTransparency = 0
    		label.Position = UDim2.new(0, 4, 0, 3)
    		label.Size = UDim2.new(1, -8, 0, 11)
    		label.Text = option
    		label.BackgroundTransparency = 1
    		label.TextXAlignment = Enum.TextXAlignment.Left
    		label.ZIndex = 2
    		label.Parent = outline

    		local value = self.feature.value
    		if typeof(value) == "table" and value[option] or option == value then
    			label.TextColor3 = Color3.fromRGB(55, 175, 225)
    		else
    			label.TextColor3 = Color3.fromRGB(255, 255, 255)
    		end

    		outline.Parent = self.instances.layout

    		trove:Connect(outline.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				local value = self.feature.value

    				if typeof(value) == "table" then
    					value[option] = not value[option]

    					self.feature:set(value)
    				else
    					self.feature:set(option)
    				end
    			end
    		end)

    		self:resize()
    		trove:Add(outline)
    		return trove
    	end

    	function UIDropdownMenu.attach(self, dropdown, base)
    		if base.activeMenu ~= "none" then
    			self:detach(base )
    		end

    		self.feature = dropdown

    		for _, option in dropdown.options do
    			self.options[option] = self:add(option)
    		end

    		self._trove:Connect((dropdown.onOptionAdded ), function(option)
    			self.options[option] = self:add(option)
    		end)

    		self._trove:Connect((dropdown.onOptionRemoved ), function(option)
    			self._trove:Remove(self.options[option])
    			self.options[option] = nil

    			self:resize()
    		end)

    		self._trove:Connect((dropdown.changed ), function(value)
    			for _, outline in self.instances.layout:GetChildren() do
    				if outline:IsA("UIListLayout") then
    					continue
    				end

    				local label = outline:FindFirstChildOfClass("TextLabel")
    				assert(label, "internal error")

    				if typeof(value) == "table" and value[label.Text] or label.Text == value then
    					label.TextColor3 = Color3.fromRGB(55, 175, 225)
    				else
    					label.TextColor3 = Color3.fromRGB(255, 255, 255)
    				end
    			end
    		end)

    		self._trove:Connect(UserInputService.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				local inputX, inputY = input.Position.X, input.Position.Y

    				local container = self.instances.container
    				local position, size = container.AbsolutePosition, container.AbsoluteSize

    				if inside(inputX, inputY, position.X, position.Y, size.X, size.Y) then
    					return
    				end

    				local outline = dropdown.instances.outline
    				local absPosition, absSize = outline.AbsolutePosition, outline.AbsoluteSize

    				if not inside(inputX, inputY, absPosition.X, absPosition.Y, absSize.X, absSize.Y) then
    					self:detach(base )

    					dropdown:setOpen(false, base)
    				end
    			end
    		end)

    		self:resize()

    		self.instances.container.Position = UDim2.new(0, dropdown.instances.outline.AbsolutePosition.X + 1, 0, dropdown.instances.outline.AbsolutePosition.Y + 80)
    		self.instances.container.Size = UDim2.new(0, dropdown.instances.outline.AbsoluteSize.X, 0, self.instances.container.Size.Y.Offset)
    		self.instances.container.Parent = base.instances.gui
    		base.activeMenu = "dropdown"
    	end

    	function UIDropdownMenu.detach(self, base)
    		assert(self.feature, "?")

    		self.feature:setOpen(false, base)
    		self.feature = nil

    		base.activeMenu = "none"
    		self.instances.container.Parent = nil
    		self._trove:Clean()
    		self.options = {}
    	end

    	function UIDropdownMenu._makeInstances(self)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		container.BorderSizePixel = 1
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.Position = UDim2.new(0, 0, 1, 3)
    		container.Size = UDim2.new(1, 0, 0, 0)
    		container.ZIndex = 2
    		self.instances.container = container

    		local layout= Instance.new("ScrollingFrame")
    		layout.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    		layout.BorderSizePixel = 0
    		layout.Position = UDim2.new(0, 1, 0, 1)
    		layout.Size = UDim2.new(1, -2, 1, -2)
    		layout.AutomaticCanvasSize = Enum.AutomaticSize.Y
    		layout.CanvasSize = UDim2.new(0, 0, 0, 0)
    		layout.ScrollBarImageColor3 = Color3.fromRGB(55, 175, 225)
    		layout.ScrollingDirection = Enum.ScrollingDirection.Y
    		layout.ScrollBarThickness = 4
    		layout.TopImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.MidImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.BottomImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.ZIndex = 2
    		layout.Parent = container
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.Padding = UDim.new(0, 1)
    		listLayout.Parent = layout
    	end

    	function UIDropdownMenu.into(self)
    self:_makeInstances()
    		return self
    	end

    	function UIDropdownMenu.Destroy(self)

    	end
    end

    local UIIconList = {}
    UIIconList.__index = UIIconList; do
    	function UIIconList.new(parent)
            assert(parent, "TabList.new(parent) : _ -> expected UIExtendable, got nil")

    		local self = setmetatable({}, UIIconList)
    		self._trove = parent._trove:Extend()
    		self.instances = {}
    		self.children = {}
    		self.parent = parent

    		return UIIconList.into((self ) )
    	end

    	function UIIconList.newIcon(self, image)
    		assert(image, "UIIconList.newIcon(_, image) : _ -> expected string got nil")
    		assert(typeof(image) == "string", "UIIconList.newIcon(_, image) : _ -> expected string, got " .. typeof(image))

    		local tab= UIExtendable.new()
    		tab._trove = self._trove:Extend()

    		local tab= tab
            tab.setVisible = UIIconList.setVisible
    		tab.parent = self
    		table.insert(self.children, tab)

    		self:_makeIconInstances(tab)
    		tab.instances.image.Image = image

    		if #self.children == 1 then
    			tab:setVisible(true)
    		end

    		self._trove:Connect(tab.instances.button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				tab:setVisible(true)
    			end
    		end)

    		self:_resize()

    		return tab
    	end

    	function UIIconList.setVisible(self, state)
    		return UIIconList.setIconVisible(self , state)
    	end

    	function UIIconList.setIconVisible(self, state)
    		assert(typeof(state) == "boolean", "UIIconList.setVisible(_, state: boolean) -> expected boolean, got " .. typeof(state))
    		assert(state, "UIIconList.setVisible(_, state: boolean) -> unused variable")

    		if self.visible == state then
    			return
    		end

    		self.visible = state

    		assert(self.parent, "UIIconList.setIconVisible(_, _) -> internal failure")

    		for _, tab in (self.parent.children )do
    			local instances = tab.instances
    			instances.image.ImageColor3 = Color3.fromRGB(150, 150, 150)
    			instances.canvas.Visible = false

    			tab.visible = false
    		end

    		local instances = self.instances
    		instances.image.ImageColor3 = Color3.fromRGB(255, 255, 255)
    		instances.canvas.Visible = true
    	end

    	function UIIconList._makeIconInstances(self, tab)
    		local button= Instance.new("TextButton")
    		button.Size = UDim2.new(0, 0, 1, 0)
    		button.BackgroundTransparency = 1
    		button.Text = ""
    		tab.instances.button = button

    		local image= Instance.new("ImageLabel")
    		image.Position = UDim2.new(0.5, 0, 0.5, 0)
    		image.AnchorPoint = Vector2.new(0.5, 0.5)
    		image.Size = UDim2.new(0, 48, 1, 0)
    		image.BackgroundTransparency = 1
    		image.ImageColor3 = Color3.fromRGB(150, 150, 150)
    		image.Parent = button
    		tab.instances.image = image

    		local canvas= Instance.new("Frame")
    		canvas.Size = UDim2.new(1, 0, 1, 0)
    		canvas.BackgroundTransparency = 1
    		canvas.Visible = false
    		canvas.Parent = self.instances.canvas
    		tab.instances.canvas = canvas
    		tab.instances.container = canvas

    		button.Parent = self.instances.layout
    	end

    	function UIIconList._makeInstances(self)
    		local container= Instance.new("Frame")
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		container.Size = UDim2.new(1, -10, 0, 50)
    		container.Position = UDim2.new(0, 5, 0, 5)

    		local layout= Instance.new("Frame")
    		layout.BorderSizePixel = 0
    		layout.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		layout.Size = UDim2.new(1, -2, 1, -2)
    		layout.Position = UDim2.new(0, 1, 0, 1)
    		layout.Parent = container
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.FillDirection = Enum.FillDirection.Horizontal
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = layout

    		local canvas= Instance.new("Frame")
    		canvas.BackgroundTransparency = 1
    		canvas.Position = UDim2.new(0, 0, 0, 55)
    		canvas.Size = UDim2.new(1, 0, 1, -55)
    		self.instances.canvas = canvas

    		container.Parent = self.parent.instances.canvas
    		canvas.Parent = self.parent.instances.canvas
    	end

    	function UIIconList._resize(self)
    		local layout= self.instances.layout
    		local cnt= #self.children

    		local totalSize= layout.AbsoluteSize.X
    		local size= totalSize / cnt

    		for _, tab in self.children do
    			tab.instances.button.Size = UDim2.new(0, size, 1, 0)
    		end

    		local last= self.children[#self.children]
    		local button= last.instances.button

    		local curr= button.AbsolutePosition.X + button.AbsoluteSize.X
    		local expected= layout.AbsolutePosition.X + layout.AbsoluteSize.X
    		local diff= expected - curr

    		if diff ~= 0 then
    			button.Size += UDim2.new(0, diff, 0, 0)
    		end
    	end

    	function UIIconList.into(self)
    self:_makeInstances()
    		return self
    	end
    end

    local UITabList = {}
    UITabList.__index = UITabList do
    	function UITabList.new(parent)
            assert(parent, "TabList.new(parent) : _ -> expected UIExtendable, got nil")

    		local self = setmetatable({}, UITabList)
    		self._trove = parent._trove:Extend()
    		self.instances = {}
    		self.children = {}
    		self.parent = parent

    		return UITabList.into((self ) )
    	end

    	function UITabList.newTab(self, label)
            assert(label, "TabList.newTab(_, label) : _ -> expected string got nil")
    		assert(typeof(label) == "string", "TabList.newTab(_, label) : _ -> expected string, got " .. typeof(label))

    		local tab= UIExtendable.new()
    		tab._trove = self._trove:Extend()

    		local tab= tab
    tab.setVisible = UITabList.setVisible
    		tab.parent = self
    		table.insert(self.children, tab)

    		self:_makeTabInstances(tab)
    		tab.instances.button.Text = label

    		if #self.children == 1 then
    			tab:setVisible(true)
    		end

    		self._trove:Connect(tab.instances.button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				tab:setVisible(true)
    			end
    		end)

    		self:_resize()

    		return tab
    	end

    	function UIExtendable.newTabList(self)
    assert(self.sectionHolder == nil, "UIExtendable.newIconList(_) : _ -> expected sections to be nil")
    		assert(self.child == nil, "UIExtendable.newTabList(_) : _ -> expected child to be nil")

    		local tabList= UITabList.new(self)
    		self.child = tabList

    		return tabList
    	end

    	function UIExtendable.newIconList(self)
    assert(self.sectionHolder == nil, "UIExtendable.newIconList(_) : _ -> expected sections to be nil")
    		assert(self.child == nil, "UIExtendable.newIconList(_) : _ -> expected child to be nil")

    		local iconList= UIIconList.new(self)
    		self.child = iconList

    		return iconList
    	end

    	function UITabList.setVisible(self, state)
    		return UITabList.setTabVisible(self , state)
    	end

    	function UITabList.setTabVisible(self, state)
    		assert(typeof(state) == "boolean", "UIExtendable.setVisible(_, state: boolean) -> expected boolean, got " .. typeof(state))
    		assert(state, "UIExtendable.setVisible(_, state: boolean) -> unused variable")

    		if self.visible == state then
    			return
    		end

    		self.visible = state

    		assert(self.parent, "UITabList.setTabVisible(_, _) -> internal failure")

    		for _, tab in (self.parent.children )do
    			local instances = tab.instances
    			instances.inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    			instances.cover.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    			instances.cover.Size = UDim2.new(1, 0, 0, 1)
    			instances.canvas.Visible = false

    			tab.visible = false
    		end

    		local instances = self.instances
    		instances.inline.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		instances.cover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		instances.cover.Size = UDim2.new(1, 0, 0, 2)
    		instances.canvas.Visible = true
    	end

    	function UITabList._makeTabInstances(self, tab)
    		local outline= Instance.new("Frame")
    		outline.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    		outline.BorderSizePixel = 0
    		outline.Size = UDim2.new(0, 0, 1, 0)
    		tab.instances.outline = outline

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		inline.BorderColor3 = Color3.fromRGB(50, 50, 50)
    		inline.Position = UDim2.new(0, 2, 0, 2)
    		inline.Size = UDim2.new(1, -4, 1, -3)
    		inline.Parent = outline
    		tab.instances.inline = inline

    		local cover= Instance.new("Frame")
    		cover.BorderSizePixel = 0
    		cover.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		cover.Position = UDim2.new(0, 0, 1, 0)
    		cover.Size = UDim2.new(1, 0, 0, 1)
    		cover.Parent = inline
    		tab.instances.cover = cover

    		local button= Instance.new("TextButton")
    		button.BackgroundTransparency = 1
    		button.Font = Enum.Font.Arial
    		button.TextSize = 12
    		button.TextColor3 = Color3.fromRGB(255, 255, 255)
    		button.Size = UDim2.new(1, 0, 1, 0)
    		button.TextStrokeTransparency = 0
    		button.Parent = inline
    		tab.instances.button = button

    		local canvas= Instance.new("Frame")
    		canvas.Size = UDim2.new(1, 0, 1, 0)
    		canvas.BackgroundTransparency = 1
    		canvas.Visible = false
    		canvas.Parent = self.instances.canvas
    		tab.instances.canvas = canvas
    		tab.instances.container = canvas

    		outline.Parent = self.instances.layout
    	end

    	function UITabList._resize(self)
    		local layout= self.instances.layout
    		local cnt= #self.children

    		local totalSize= layout.AbsoluteSize.X - (cnt - 1) * 4
    		local size= totalSize / cnt

    		for _, tab in self.children do
    			tab.instances.outline.Size = UDim2.new(0, size, 1, 0)
    		end

    		local last= self.children[#self.children]
    		local outline= last.instances.outline

    		local curr= outline.AbsolutePosition.X + outline.AbsoluteSize.X
    		local expected= layout.AbsolutePosition.X + layout.AbsoluteSize.X
    		local diff= expected - curr

    		if diff ~= 0 then
    			outline.Size += UDim2.new(0, diff, 0, 0)
    		end
    	end

    	function UITabList._makeInstances(self)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.BorderSizePixel = 1
    		container.Position = UDim2.new(0, 5, 0, 26)
    		container.Size = UDim2.new(1, -10, 1, -31)
    		self.instances.container = container

    		local canvas= Instance.new("Frame")
    		canvas.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		canvas.BorderSizePixel = 0
    		canvas.Position = UDim2.new(0, 1, 0, 1)
    		canvas.Size = UDim2.new(1, -2, 1, -2)
    		canvas.Parent = container
    		self.instances.canvas = canvas

    		local layout= Instance.new("Frame")
    		layout.BackgroundTransparency = 1
    		layout.Position = UDim2.new(0, -1, 0, -21)
    		layout.Size = UDim2.new(1, 2, 0, 21)
    		layout.Parent = container
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.Padding = UDim.new(0, 4)
    		listLayout.FillDirection = Enum.FillDirection.Horizontal
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = layout

    		container.Parent = self.parent.instances.canvas
    	end

    	function UITabList.into(self)
    self:_makeInstances()
    		self.parent.child = self
    		return self
    	end
    end

    UIBase = {}
    UIBase.__index = UIBase do
    	function UIBase.new()
            local self = setmetatable({}, UIBase)
    		self._trove = Trove.new()

    		self.refs = {}
    		self.instances = {}
    		self.features = {}

    		self.visible = true
    		self.dragging = false
    		self.keybind = Enum.KeyCode.RightShift

    		self.activeMenu = "none"

    		self.visibilityChanged = self._trove:Add(Signal.new())

    		return UIBase.into((self ) )
    	end

    	function UIBase.setLabel(self, label)
            assert(label, "UIBase.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UIBase.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.label.Text = label
    		return self
    	end

    	function UIBase.setKeybind(self, keybind)
            assert(keybind, "UIBase.setKeybind(_, keybind) : _ -> expected Enum.KeyCode, got nil")
    		assert(typeof(keybind) == "EnumItem", "UIBase.setKeybind(_, keybind) : _ -> expected Enum.KeyCode, got " .. typeof(keybind))

    		self.keybind = keybind
    		return self
    	end

    	function UIBase.setVisible(self, state)
    		assert(typeof(state) == "boolean", "UIBase.setVisible(_, state: boolean) -> expected boolean, got " .. typeof(state))

    		if self.visible == state then
    			return
    		end

    		self.visible = state
    		self.instances.container.Visible = self.visible

    		self.visibilityChanged:Fire(self.visible)
    	end

    	function UIBase.makeDraggable(self, guiObject, trove, callback)
    		local dragInput
            local dragging= false

    		local onMouseMove = function(input)
    			if dragging and input == dragInput then
    				callback(input)
    			end
    		end

    		local connection = self._trove:Connect(UserInputService.InputChanged, onMouseMove)

    		trove:Connect((self.visibilityChanged ), function(state)
    			if not state then
    				dragging = false
    				trove:Remove(connection)
    				return
    			end

    			connection = trove:Connect(UserInputService.InputChanged, onMouseMove)
    		end)

    		trove:Connect(guiObject.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				dragging = true
    				dragInput = input

    				onMouseMove(input)

    				local onChanged
    				onChanged = self._trove:Connect(input.Changed, function()
    					if input.UserInputState == Enum.UserInputState.End then
    						dragging = false
    						trove:Remove(onChanged)
    						dragInput = nil
    					end
    				end)
    			end
    		end)

    		trove:Connect(guiObject.InputChanged, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    				dragInput = input
    			end
    		end)
    	end

    	function UIBase._makeInstances(self)
    		local screenGui= Instance.new("ScreenGui")
    		screenGui.ResetOnSpawn = false
    		screenGui.IgnoreGuiInset = true
    		screenGui.ScreenInsets = Enum.ScreenInsets.None
    		screenGui.DisplayOrder = 100
    		self.instances.gui = screenGui

    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
    		container.BorderSizePixel = 1
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.AnchorPoint = Vector2.new(0, 0)
    		container.Position = UDim2.new(0.5, -500 / 2, 0.5, -330 / 2)
    		container.Size = UDim2.new(0, 500, 0, 330)
    		container.Parent = screenGui
    		self.instances.container = container

    		local background= Instance.new("Frame")
    		background.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    		background.Position = UDim2.new(0, 1, 0, 1)
    		background.Size = UDim2.new(1, -2, 1, -2)
    		background.BorderSizePixel = 0
    		background.Parent = container

    		local outer= Instance.new("Frame")
    		outer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    		outer.Position = UDim2.new(0, 5 , 0, 19)
    		outer.Size = UDim2.new(1, -10, 1, -24)
    		outer.BorderColor3 = Color3.fromRGB(50, 50, 50)
    		outer.Parent = background

    		local canvas= Instance.new("Frame")
    		canvas.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		canvas.Position = UDim2.new(0, 1, 0, 1)
    		canvas.Size = UDim2.new(1, -2, 1, -2)
    		canvas.BorderSizePixel = 0
    		canvas.Parent = outer
    		self.instances.canvas = canvas

    		local title= Instance.new("TextLabel")
    		title.Size = UDim2.new(1, -8, 0, 11)
    		title.Position = UDim2.new(0, 4, 0, 4)
    		title.Font = Enum.Font.Arial
    		title.TextSize = 12
    		title.TextStrokeTransparency = 0
    		title.BackgroundTransparency = 1
    		title.TextXAlignment = Enum.TextXAlignment.Left
    		title.TextColor3 = Color3.fromRGB(255, 255, 255)
    		title.Parent = background
    		self.instances.label = title

    		local drag= Instance.new("TextButton")
    		drag.BackgroundTransparency = 1
    		drag.Text = ""
    		drag.Size = UDim2.new(1, 0, 0, 20)
    		drag.Modal = true
    		drag.Parent = container
    		self.instances.drag = drag

    		local resize= Instance.new("TextButton")
    		resize.BackgroundTransparency = 1
    		resize.Text = ""
    		resize.Position = UDim2.new(1, 0, 1, 0)
    		resize.AnchorPoint = Vector2.new(1, 1)
    		resize.Size = UDim2.new(0, 13, 0, 13)
    		resize.Parent = container
    		self.instances.resize = resize

    		local open= Instance.new("TextButton")
    		open.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		open.AutoButtonColor = false
    		open.Position = UDim2.new(0.5, 0, 0, 0)
    		open.Size = UDim2.new(0, 50, 0, 50)
    		open.Font = Enum.Font.Arimo
    		open.TextSize = 12
    		open.TextColor3 = Color3.fromRGB(255, 255, 255)
    		open.Text = "Open"
    		open.BackgroundTransparency = 0.5
    		open.AnchorPoint = Vector2.new(0.5, 0)
    		open.Parent = screenGui
    		self.instances.open = open

    		local uiCorner = Instance.new("UICorner")
    		uiCorner.CornerRadius = UDim.new(0, 5)
    		uiCorner.Parent = open
    	end

    	function UIBase.into(self)
    self:_makeInstances()

    		local dragInput= nil
    		local dragStart= Vector3.zero
    		local guiStart= UDim2.new()

    		self._trove:Connect(self.instances.drag.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				self.dragging = true

    				dragStart = input.Position
    				guiStart = self.instances.container.Position
    				dragInput = input

    				local onChanged
    				onChanged = self._trove:Connect(input.Changed, function()
    					if input.UserInputState == Enum.UserInputState.End then
    						self.dragging = false
    						self._trove:Remove(onChanged)
    						dragInput = nil
    					end
    				end)
    			end
    		end)

    		self._trove:Connect(UserInputService.InputChanged, function(input)
            if self.dragging and input == dragInput then
                local delta = input.Position - dragStart
                local container = self.instances.container
                local screenSize = self.instances.gui.AbsoluteSize
                local containerSize = container.AbsoluteSize

                local newX = guiStart.X.Offset + delta.X
                local newY = guiStart.Y.Offset + delta.Y

                local maxX = math.max(0, screenSize.X - containerSize.X)
                local maxY = math.max(0, screenSize.Y - containerSize.Y)

                container.Position = UDim2.new(
                    guiStart.X.Scale,
                    math.clamp(newX, -screenSize.X * guiStart.X.Scale, maxX),
                    guiStart.Y.Scale,
                    math.clamp(newY, -screenSize.Y * guiStart.Y.Scale, maxY)
                )
            end
        end)

        self._trove:Connect(self.instances.drag.InputChanged, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    				dragInput = input
    			end
    		end)

    		self._trove:Add(self.instances.gui)

    		local resizeInput= nil
    		local resizeStart= Vector3.zero

    		self._trove:Connect(self.instances.resize.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				self.resizing = true

    				dragStart = input.Position
    				guiStart = self.instances.container.Position
    				resizeInput = input

    				local onChanged
    				onChanged = self._trove:Connect(input.Changed, function()
    					if input.UserInputState == Enum.UserInputState.End then
    						self.resizing = false
    						self._trove:Remove(onChanged)
    						resizeInput = nil
    					end
    				end)
    			end
    		end)

    		self._trove:Connect(UserInputService.InputChanged, function(input)
    			if self.resizing and input == resizeInput then
    				local uiPosition = self.instances.container.AbsolutePosition
    				local mousePosition= Vector2.new(input.Position.X, input.Position.Y)
    				local delta= mousePosition - uiPosition


    				local newSize = UDim2.new(0, math.max(500, delta.X), 0, math.max(330, delta.Y))
    				self.instances.container.Size = newSize

    				local function recursiveResize(parent)


    local child = ((parent.child ))

    if child then
    						if child._resize then
    							child:_resize()
    						end

    						if child.children then
    							for _, tab in child.children do
    								if tab.child then
    									recursiveResize((tab ) )
    								end
    							end
    						else

    							local sections = ((child ) ).sections

    							local left = sections.left[#sections.left]

    							if left then

    							end
    						end
    					end
    				end

    				recursiveResize(self)
    			end
    		end)

    		self._trove:Connect(self.instances.resize.InputChanged, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    				resizeInput = input
    			end
    		end)

    		self.menus = {
    			dropdown = UIDropdownMenu.new(self),
    			colorpicker = UIColorpickerMenu.new(self),
    		}

    self._trove:Add(self.menus.dropdown)
    		self._trove:Add(self.menus.colorpicker)

    		self._trove:Connect(self.instances.open.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				self:setVisible(not self.visible)
    			end
    		end)

    		return self
    	end

    	function UIBase.newTabList(self)
    assert(self.child == nil, "UIBase.newTabList(_) : _ -> expected child to be nil")

    		local tabList= UITabList.new(self)
    		self.child = tabList

    		return tabList
    	end

    	function UIBase.newIconList(self)
    assert(self.child == nil, "UIBase.newIconList(_) : _ -> expected child to be nil")

    		local iconList= UIIconList.new(self)
    		self.child = iconList

    		return iconList
    	end

    	function UIBase.encodeJSON(self)
    local config = {}

    		for flag, feature in self.features do
    			if typeof(feature.value) == "table" then
    				local clone = table.clone(feature.value)

    				for k, v in clone do
    					if typeof(v) == "Color3" then
    						clone[k] = { v.R, v.G, v.B }
    					elseif typeof(v) == "EnumItem" then
    						local key = clone.key
    						clone[k] = {
    							"Enum",
    							key ~= "None" and tostring(key.EnumType) or "Unknown",
    							key ~= "None" and key.Name or "None",
    						}
    					end
    				end

    				config[flag] = clone
    			else
    				config[flag] = feature.value
    			end
    		end

    		return HttpService:JSONEncode(config)
    	end

    	function UIBase.decodeJSON(self, json)
            local jsonDecoded = HttpService:JSONDecode(json)

            local status, err = pcall(function()
                for flag, value in next, jsonDecoded do
    				pcall(function()
    					if type(value) == "table" then
    						if value.rgb and value.alpha then
    							self.features[flag]:set({ rgb = Color3.new(value.rgb[1], value.rgb[2], value.rgb[3]), alpha = value.alpha })
    						elseif value.key and value.mode then
    							self.features[flag]:set({ key = Enum[value.key[2]][value.key[3]], mode = value.mode })
    						else
    							self.features[flag]:set(value)
    						end
    					else
    						self.features[flag]:set(value)
    					end
    				end)
                end
            end)

            return status, err
        end

    	function UIBase.Finish(self)
    		if setidentity then
    			setidentity(8)
    		end
    		self.instances.gui.Parent = CoreGui
    	end

    	function UIBase.Destroy(self)
    		self._trove:Clean()
    	end
    end

    local UIColorpicker = {}
    UIColorpicker.__index = UIColorpicker do
    	function UIColorpicker.new(parent, flag, base, hasAlpha)
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIColorpicker)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = { rgb = Color3.new(), alpha = 0 }
    		self.hasAlpha = hasAlpha

    		return UIColorpicker.into((self ) , parent, base, flag)
    	end

    	function UIColorpicker.set(self, value)
    if self.value.rgb == value.rgb and self.value.alpha == value.alpha then
    			return self
    		end

    		local color = value.rgb
    		local top = Color3.fromRGB(math.min(255, color.R * 255 + 20), math.min(255, color.G * 255 + 20), math.min(255, color.B * 255 + 20))
    		local bottom = Color3.fromRGB(math.max(0, color.R * 255 - 20), math.max(0, color.G * 255 - 20), math.max(0, color.B * 255 - 20))

    		self.instances.gradient.Color = ColorSequence.new(top, bottom)

    		self.value = value
    		self.changed:Fire(self.value)

    		return self
    	end

    	function UIColorpicker._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		container.BorderSizePixel = 1
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.Size = UDim2.new(0, 40, 1, 0)
    		self.instances.container = container

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BorderSizePixel = 0
    		inline.Parent = container

    		local button= Instance.new("TextButton")
    		button.Size = UDim2.new(1, 0, 1, 0)
    		button.AutoButtonColor = false
    		button.BorderSizePixel = 0
    		button.TextStrokeTransparency = 0
    		button.Text = ""
    		button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		button.BackgroundTransparency = 0
    		button.Parent = inline

    		local gradient= Instance.new("UIGradient")
    		gradient.Rotation = 90
    		gradient.Parent = button
    		self.instances.gradient = gradient

    		container.Parent = parent.instances.layout
    		self.instances.button = button
    	end

    	function UIColorpicker.into(self, parent, base, flag)
    self:_makeInstances(parent)
    		self:set({ rgb = Color3.fromRGB(255, 255, 225), alpha = 0 })

    		self._trove:Connect(self.instances.button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self.open = not self.open

    				if self.open then
    					base.menus.colorpicker:attach(self, base )
    				else
    					base.menus.colorpicker:detach(base )
    				end
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end





    local UIKeybind = {}
    UIKeybind.__index = UIKeybind
    do
    	function UIKeybind.new(parent, flag, modes, base)
    		assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIKeybind)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = {}

    		self.binding = false
    		self.active = false
    		self.activeChanged = self._trove:Add(Signal.new())

    		self.modes = modes

    		return UIKeybind.into((self ) , parent, base, flag)
    	end

    	function UIKeybind.set(self, value)
    if self.value.key == value.key and self.value.mode == value.mode and not self.binding then
    			return self
    		end

    		if value.key == Enum.UserInputType.MouseMovement then
    			return self
    		end

    		self.instances.button.Text = string.format("%s: %s", value.mode, value.key and value.key.Name or "None")

    		self.value = value
    		self.changed:Fire(self.value)
    		return self
    	end

    	function UIKeybind._setActive(self, state)
    		if self.active == state then
    			return
    		end

    		self.active = state
    		self.activeChanged:Fire(self.active)
    	end

    	function UIKeybind.isInputKey(self, input)
    local key = self.value.key

    		if not key then
    			return false
    		end

    		if key.EnumType == Enum.KeyCode and input.KeyCode ~= key then
    			return false
    		end

    		if key.EnumType == Enum.UserInputType and input.UserInputType ~= key then
    			return false
    		end

    		return true
    	end

    	function UIKeybind._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		container.BorderSizePixel = 1
    		container.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		container.Size = UDim2.new(0, 0, 1, 0)
    		self.instances.container = container

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BorderSizePixel = 0
    		inline.Parent = container

    		local button= Instance.new("TextButton")
    		button.Size = UDim2.new(1, 0, 1, 0)
    		button.TextColor3 = Color3.fromRGB(255, 255, 255)
    		button.TextStrokeTransparency = 0
    		button.TextXAlignment = Enum.TextXAlignment.Center
    		button.Font = Enum.Font.Arial
    		button.TextSize = 12
    		button.BackgroundTransparency = 1
    		button.Parent = inline

    		container.Parent = parent.instances.layout
    		self.instances.button = button
    	end

    	function UIKeybind.into(self, parent, base, flag)
    self:_makeInstances(parent)

    		self._trove:Connect(self.instances.button:GetPropertyChangedSignal("TextBounds"), function()
    			self.instances.container.Size = UDim2.new(0, self.instances.button.TextBounds.X + 8, 1, 0)
    		end)

    		self._trove:Connect((self.changed ), function(state)
    			self:_setActive(state.mode == "Always")
    		end)

    		self:set({ key = nil, mode = (self.modes[1] )})

    		local disable_keybind = false

    		self._trove:Connect(UserInputService.InputBegan, function(input)
    			if not self:isInputKey(input) then
    				return
    			end

    			if disable_keybind then
    				disable_keybind = false
    				return
    			end

    			local mode = self.value.mode

    			if mode == "Toggle" or mode == "Tap" then
    				self:_setActive(not self.active)
    			elseif mode == "Hold" or mode == "Release" then
    				self:_setActive(mode == "Hold")
    			end
    		end)

    		self._trove:Connect(UserInputService.InputEnded, function(input)
    			if not self:isInputKey(input) then
    				return
    			end

    			local mode = self.value.mode

    			if mode == "Hold" or mode == "Release" then
    				self:_setActive(mode == "Release")
    			end
    		end)

    		local inputBegan, inputEnded

    		self._trove:Connect(self.instances.button.InputBegan, function(input)
    			if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    				return
    			end

    			if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    				return
    			end

    			if base.binding then
    				return
    			end


    			if input.UserInputType == Enum.UserInputType.MouseButton1 then
    				base.binding = self
    				self.binding = true
    				self.instances.button.Text = "..."


    				local debounce = true

    				local connection
    				connection = self._trove:Connect(UserInputService.InputBegan, function(input)
    					if debounce then
    						debounce = false
    						return
    					end

    					if input.UserInputType == Enum.UserInputType.MouseMovement then
    						return
    					end

    					local key

    if input.KeyCode ~= Enum.KeyCode.Backspace then
    						if input.KeyCode ~= Enum.KeyCode.Unknown then
    							key = input.KeyCode
    						else
    							key = input.UserInputType
    						end
    					end

    					disable_keybind = true

    					self:set({ key = key, mode = self.value.mode })
    					self.binding = false
    					base.binding = nil

    					self._trove:Remove(connection)
    				end)
    			elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
    				local index = (table.find(self.modes, self.value.mode) )
    self:set({ key = self.value.key, mode = (self.modes[(index % #self.modes) + 1] )})
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UIToggle = {}
    UIToggle.__index = UIToggle
    do
    	function UIToggle.new(parent, flag)
    		assert(flag, "UIToggle.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UIToggle.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIToggle)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = false

    		self.base = base

    		parent.instances.container.Size += UDim2.new(0 , 0, 0, 19)
    		return UIToggle.into((self ) , parent, base, flag)
    	end

    	function UISection.newToggle(self, flag)
    return UIToggle.new(self, flag)
    	end

    	function UIToggle.set(self, state)
    if typeof(state) ~= "boolean" then
    			warn("UIToggle.set(_, state) : _ -> expected boolean, got " .. typeof(state))
    			return self
    		end

    		local self = self

    if self.value == state then
    			return self
    		end

    		self.value = state

    		local gradient= self.instances.gradient

    		if self.value then
    			gradient.Color = ColorSequence.new(Color3.fromRGB(60, 180, 230), Color3.fromRGB(10, 130, 180))
    		else
    			gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		end

    		self.changed:Fire(self.value)
    		return self
    	end

    	function UIToggle.setLabel(self, label)
    assert(label, "UIToggle.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UIToggle.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.label.Text = label
    		return self
    	end

    	function UIToggle.newKeybind(self, flag, modes)
    return ((UIKeybind.new(self, flag, modes or { "Always", "Toggle", "Hold", "Release" }, self.base) ))
    end

    	function UIToggle.newColorpicker(self, flag, hasAlpha)
    return ((UIColorpicker.new(self, flag, self.base, hasAlpha or false) ))
    end

    	function UIToggle._makeInstances(self, parent)
    		local button = Instance.new("TextButton")
    		button.BackgroundTransparency = 1
    		button.Size = UDim2.new(1, 0, 0, 15)
    		button.Text = ""

    		local outline= Instance.new("Frame")
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.Size = UDim2.new(0, 13, 0, 13)
    		outline.Position = UDim2.new(0, 5, 0.5, 0)
    		outline.AnchorPoint = Vector2.new(0, 0.5)
    		outline.Parent = button

    		local inline= Instance.new("Frame")
    		inline.BorderSizePixel = 0
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.Parent = outline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline
    		self.instances.gradient = gradient

    		local label= Instance.new("TextLabel")
    		label.Font = Enum.Font.Arial
    		label.TextSize = 12
    		label.TextStrokeTransparency = 0
    		label.Position = UDim2.new(0, 23, 0.5, 0)
    		label.Size = UDim2.new(1, -27, 0, 11)
    		label.AnchorPoint = Vector2.new(0, 0.5)
    		label.Text = ""
    		label.BackgroundTransparency = 1
    		label.TextColor3 = Color3.fromRGB(255, 255, 255)
    		label.TextXAlignment = Enum.TextXAlignment.Left
    		label.Parent = button
    		self.instances.label = label

    		local layout= Instance.new("Frame")
    		layout.Size = UDim2.new(1, -10, 0, 13)
    		layout.Position = UDim2.new(0, 5, 0, 1)
    		layout.BackgroundTransparency = 1
    		layout.Parent = button
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.Padding = UDim.new(0, 4)
    		listLayout.FillDirection = Enum.FillDirection.Horizontal
    		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = layout

    		button.Parent = parent.instances.canvas
    		self.instances.button = button
    	end

    	function UIToggle.into(self, parent, base, flag)
    self:_makeInstances(parent)

    		self._trove:Connect(self.instances.button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self:set(not self.value)
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UISlider = {}
    UISlider.__index = UISlider
    do
    	function UISlider.new(parent, flag, min, max, decimals)
    		assert(flag, "UISlider.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UISlider.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UISlider)
    		self._trove = parent._trove:Extend()

    		self.min = min or 0
    		self.max = max or 100
    		self.decimals = decimals or 1

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = nil

    		parent.instances.container.Size += UDim2.new(0, 0, 0, 30)
    		return UISlider.into((self ) , parent, base, flag)
    	end

    	function UISection.newSlider(self, flag, min, max, decimals)
    return UISlider.new(self, flag, min, max, decimals)
    	end

    	function UISlider.set(self, value)
    if typeof(value) ~= "number" then
    			warn("UISlider.set(_, value) : _ -> expected number, got " .. typeof(value))
    			return self
    		end

    		local self = self

    local value = math.clamp(math.round(value * self.decimals) / self.decimals, self.min, self.max)
    		local equal = self.value == value

    		self.value = value
    		self.instances.scale.Size = UDim2.new((self.value - self.min) / (self.max - self.min), 0, 1, 0)
    		self.instances.value.Text = string.format("%s/%s", tostring(self.value), tostring(self.max))

    		if not equal then
    			self.changed:Fire(self.value)
    		end

    		return self
    	end

    	function UISlider.setLabel(self, label)
    assert(label, "UISlider.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UISlider.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.label.Text = label
    		return self
    	end

    	function UISlider._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.BackgroundTransparency = 1
    		container.Size = UDim2.new(1, 0, 0, 26)

    		local label= Instance.new("TextLabel")
    		label.Font = Enum.Font.Arial
    		label.TextSize = 12
    		label.TextStrokeTransparency = 0
    		label.Position = UDim2.new(0, 5, 0, 1)
    		label.Size = UDim2.new(1, -6, 0, 11)
    		label.Text = ""
    		label.BackgroundTransparency = 1
    		label.TextColor3 = Color3.fromRGB(255, 255, 255)
    		label.TextXAlignment = Enum.TextXAlignment.Left
    		label.Parent = container
    		self.instances.label = label

    		local outline= Instance.new("TextButton")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Size = UDim2.new(1, -10, 0, 10)
    		outline.Position = UDim2.new(0, 5, 0, 15)
    		outline.Text = ""
    		outline.AutoButtonColor = false
    		outline.Parent = container
    		self.instances.outline = outline

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.BorderSizePixel = 0
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Parent = outline
    		self.instances.inline = inline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline

    		local scale= Instance.new("Frame")
    		scale.BorderSizePixel = 0
    		scale.Size = UDim2.new(0.5, 0, 1, 0)
    		scale.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		scale.BorderSizePixel = 0
    		scale.Parent = inline
    		self.instances.scale = scale

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(60, 180, 230), Color3.fromRGB(10, 130, 180))
    		gradient.Rotation = 90
    		gradient.Parent = scale

    		local plus= Instance.new("TextButton")
    		plus.Text = "+"
    		plus.BackgroundTransparency = 1
    		plus.Size = UDim2.new(0, 11, 0, 11)
    		plus.Font = Enum.Font.Arial
    		plus.TextSize = 12
    		plus.Position = UDim2.new(1, -13, 0, 0)
    		plus.TextStrokeTransparency = 0
    		plus.TextColor3 = Color3.fromRGB(255, 255, 255)
    		plus.Parent = container
    		self.instances.plus = plus

    		local minus= Instance.new("TextButton")
    		minus.Text = "-"
    		minus.BackgroundTransparency = 1
    		minus.Size = UDim2.new(0, 11, 0, 11)
    		minus.Font = Enum.Font.Arial
    		minus.TextSize = 12
    		minus.Position = UDim2.new(1, -26, 0, 0)
    		minus.TextStrokeTransparency = 0
    		minus.TextColor3 = Color3.fromRGB(255, 255, 255)
    		minus.Parent = container
    		self.instances.minus = minus

    		local value= Instance.new("TextLabel")
    		value.Font = Enum.Font.Arial
    		value.TextSize = 12
    		value.TextStrokeTransparency = 0
    		value.Position = UDim2.new(0, 0, 0, 0)
    		value.Size = UDim2.new(1, 0, 1, 0)
    		value.Text = "undefined"
    		value.BackgroundTransparency = 1
    		value.TextColor3 = Color3.fromRGB(255, 255, 255)
    		value.TextXAlignment = Enum.TextXAlignment.Center
    		value.Parent = inline
    		self.instances.value = value

    		container.Parent = parent.instances.canvas
    	end

    	function UISlider.into(self, parent, base, flag)
    self:_makeInstances(parent)
    		self:set((self.min + self.max) / 2)

    		local dragInput
    local dragging= false

    		local onMouseMove = function(input)
    			if dragging and input == dragInput then
    				local inline = self.instances.inline
    				local position = input.Position

    				local percent = math.clamp((position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X, 0, 1)
    				self:set(self.min + (self.max - self.min) * percent)
    			end
    		end

    		local connection = self._trove:Connect(UserInputService.InputChanged, onMouseMove)

    		self._trove:Connect((base.visibilityChanged ), function(state)
    			if not state then
    				dragging = false
    				self._trove:Remove(connection)
    				return
    			end

    			connection = self._trove:Connect(UserInputService.InputChanged, onMouseMove)
    		end)

    		self._trove:Connect(self.instances.outline.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				dragging = true
    				dragInput = input

    				onMouseMove(input)

    				local onChanged
    				onChanged = self._trove:Connect(input.Changed, function()
    					if input.UserInputState == Enum.UserInputState.End then
    						dragging = false
    						self._trove:Remove(onChanged)
    						dragInput = nil
    					end
    				end)
    			end
    		end)

    		self._trove:Connect(self.instances.outline.InputChanged, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
    				dragInput = input
    			end
    		end)

    		self._trove:Connect(self.instances.plus.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self:set(self.value + (1 / self.decimals))
    			end
    		end)

    		self._trove:Connect(self.instances.minus.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self:set(self.value - (1 / self.decimals))
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UIDropdown = {}
    UIDropdown.__index = UIDropdown
    do
    	function UIDropdown.new(parent, flag, multi, options)
    		assert(flag, "UIDropdown.new(_, flag, _) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UIDropdown.new(_, flag, _) : _ -> expected string, got " .. typeof(flag))
    		assert(options, "todo: error")
    		assert(typeof(options) == "table", "todo: error")

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIDropdown)
    		self._trove = parent._trove:Extend()

    		self.base = base

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = nil

    		self.onOptionAdded = self._trove:Add(Signal.new())
    		self.onOptionRemoved = self._trove:Add(Signal.new())

    		self.open = false
    		self.options = options

    		self.multi = multi

    		parent.instances.container.Size += UDim2.new(0, 0, 0, 24)
    		return UIDropdown.into((self ) , parent, base, flag)
    	end

    	function UISection.newDropdown(self, flag, multi, options)
    return UIDropdown.new(self, flag, multi, options)
    	end

    	function UIDropdown.add(self, option)
    		if not table.find(self.options, option) then
    			table.insert(self.options, option)
    			self.onOptionAdded:Fire(option)
    		end
    	end

    	function UIDropdown.remove(self, option)
    		local index = table.find(self.options, option)

    		if index then
    			table.remove(self.options, index)
    			self.onOptionRemoved:Fire(option)

    			local value = self.value

    			if typeof(value) == "table" then
    				if value[option] then
    					value[option] = nil

    					self:set(value)
    				end
    			else
    				if self.value == option then
    					self:set(self.options[1])
    				end
    			end
    		end
    	end

    	function UIDropdown._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, 20)
    		container.BackgroundTransparency = 1

    		local outline= Instance.new("TextButton")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Position = UDim2.new(0, 5, 0, 0)
    		outline.Size = UDim2.new(1, -10, 0, 18)
    		outline.AutoButtonColor = false
    		outline.Text = ""
    		outline.Parent = container
    		self.instances.outline = outline

    		local inline= Instance.new("Frame")
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.BorderSizePixel = 0
    		inline.Parent = outline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline

    		local value= Instance.new("TextLabel")
    		value.Font = Enum.Font.Arial
    		value.TextSize = 12
    		value.TextStrokeTransparency = 0
    		value.Position = UDim2.new(0, 4, 0.5, 0)
    		value.Size = UDim2.new(1, -18, 0, 11)
    		value.AnchorPoint = Vector2.new(0, 0.5)
    		value.Text = "None"
    		value.BackgroundTransparency = 1
    		value.TextColor3 = Color3.fromRGB(255, 255, 255)
    		value.TextXAlignment = Enum.TextXAlignment.Left
    		value.TextTruncate = Enum.TextTruncate.AtEnd
    		value.Parent = inline
    		self.instances.value = value

    		local open= Instance.new("TextLabel")
    		open.Font = Enum.Font.Arial
    		open.TextSize = 12
    		open.TextStrokeTransparency = 0
    		open.Position = UDim2.new(0, 5, 0.5, -1)
    		open.Size = UDim2.new(1, -8, 0, 11)
    		open.AnchorPoint = Vector2.new(0, 0.5)
    		open.Text = "+"
    		open.BackgroundTransparency = 1
    		open.TextColor3 = Color3.fromRGB(255, 255, 255)
    		open.TextXAlignment = Enum.TextXAlignment.Right
    		open.Parent = inline
    		self.instances.open = open

    		container.Parent = parent.instances.canvas
    	end

    	function UIDropdown.setOpen(self, state, base)
    		if self.open == state then
    			return
    		end

    		self.open = state
    		self.instances.open.Text = self.open and "-" or "+"
    	end

    	function UIDropdown.set(self, value)
    		if self.value == value and not self.multi then
    			return
    		end

    		self.value = value

    		if typeof(value) == "table" then
    			local res = ""

    			for _, option in self.options do
    				if value[option] then
    					res ..= option .. ", "
    				end
    			end

    			if string.len(res) == 0 then
    				self.instances.value.Text = "..."
    			else
    				self.instances.value.Text = string.sub(res, 1, string.len(res) - 2)
    			end
    		else
    			self.instances.value.Text = value or "None"
    		end

    		self.changed:Fire(self.value)
    	end

    	function UIDropdown.into(self, parent, base, flag)
    self:_makeInstances(parent)

    		if not self.multi then
    			self:set(self.options[1])
    		else
    			self:set({})
    		end

    		self._trove:Connect(self.instances.outline.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self:setOpen(not self.open, base)

    				if self.open then
    					base.menus.dropdown:attach(self, base )
    				else
    					base.menus.dropdown:detach(base )
    				end
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UIButton = {}
    UIButton.__index = UIButton
    do
    	function UIButton.new(parent, flag)
    		assert(flag, "UIButton.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UIButton.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIButton)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())

    		parent.instances.container.Size += UDim2.new(0 , 0, 0, 24)
    		return UIButton.into((self ) , parent, base, flag)
    	end

    	function UISection.newButton(self, flag)
    return UIButton.new(self, flag)
    	end

    	function UIButton.set(self, state)
    return self
    	end

    	function UIButton.setLabel(self, label)
    assert(label, "UIButton.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UIButton.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.button.Text = label
    		return self
    	end

    	function UIButton._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, 20)
    		container.BackgroundTransparency = 1

    		local outline= Instance.new("Frame")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Position = UDim2.new(0, 5, 0, 0)
    		outline.Size = UDim2.new(1, -10, 0, 18)
    		outline.Parent = container

    		local inline= Instance.new("Frame")
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.BorderSizePixel = 0
    		inline.Parent = outline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline

    		local button= Instance.new("TextButton")
    		button.Font = Enum.Font.Arial
    		button.TextSize = 12
    		button.TextStrokeTransparency = 0
    		button.Position = UDim2.new(0, 0, 0, 0)
    		button.Size = UDim2.new(1, 0, 1, 0)
    		button.BackgroundTransparency = 1
    		button.TextColor3 = Color3.fromRGB(255, 255, 255)
    		button.TextXAlignment = Enum.TextXAlignment.Center
    		button.Parent = inline
    		self.instances.button = button

    		container.Parent = parent.instances.canvas
    	end

    	function UIButton.into(self, parent, base, flag)
    self:_makeInstances(parent)

    		self._trove:Connect(self.instances.button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				if base.activeMenu == "dropdown" and insideFrame(input.Position, base.menus.dropdown.instances.container) then
    					return
    				end

    				if base.activeMenu == "color" and insideFrame(input.Position, base.menus.colorpicker.instances.container) then
    					return
    				end

    				self.changed:Fire()
    				self.instances.button.TextColor3 = Color3.fromRGB(55, 175, 225)
    			end
    		end)

    		self._trove:Connect(self.instances.button.InputEnded, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				self.instances.button.TextColor3 = Color3.fromRGB(255, 255, 255)
    			end
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UIList = {}
    UIList.__index = UIList
    do
    	function UIList.new(parent, flag, size, options)
    		assert(flag, "UIList.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UIList.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UIList)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())

    		self.options = options
    		self.size = size * 18 + 4

    		parent.instances.container.Size += UDim2.new(0, 0, 0, self.size + 4)
    		return UIList.into((self ) , parent, base, flag)
    	end

    	function UISection.newList(self, flag, size, options)
    return UIList.new(self, flag, size, options)
    	end

    	function UIList.set(self, value)
    if self.value == value then
    			return self
    		end

    		self.value = value
    		self.changed:Fire(self.value)
    		return self
    	end

    	function UIList.add(self, option)
    		if self.options[option] then
    			return
    		end

    		local trove = self._trove:Extend()

    		local container= Instance.new("Frame")
    		container.BackgroundTransparency = 1
    		container.Size = UDim2.new(1, 0, 0, 18)

    		local button= Instance.new("TextButton")
    		button.Text = option
    		button.Size = UDim2.new(1, 0, 1, 0)
    		button.TextColor3 = Color3.fromRGB(255, 255, 255)
    		button.TextStrokeTransparency = 0
    		button.TextXAlignment = Enum.TextXAlignment.Center
    		button.Font = Enum.Font.Arial
    		button.TextSize = 12
    		button.BackgroundTransparency = 1
    		button.Parent = container

    		container.Parent = self.instances.layout

    		trove:Connect(button.InputBegan, function(input)
    			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
    				self:set(option)
    			end
    		end)

    		local function updateColors()
    			if option == self.value then
    				button.TextColor3 = Color3.fromRGB(55, 175, 225)
    			else
    				button.TextColor3 = Color3.fromRGB(255, 255, 255)
    			end
    		end

    		updateColors()
    		trove:Connect((self.changed ), updateColors)

    		trove:Add(container)
    		self.options[option] = trove
    	end

    	function UIList.remove(self, option)
    		self._trove:Remove(self.options[option])
    		self.options[option] = nil
    		self:set(nil)
    	end

    	function UIList._reset(self)
    		for option in self.options do
    			self:set(option)
    			break
    		end
    	end

    	function UIList._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, self.size)
    		container.BackgroundTransparency = 1

    		local outline= Instance.new("Frame")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Position = UDim2.new(0, 5, 0, 0)
    		outline.Size = UDim2.new(1, -10, 1, 0)
    		outline.Parent = container

    		local layout= Instance.new("ScrollingFrame")
    		layout.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    		layout.BorderSizePixel = 0
    		layout.Position = UDim2.new(0, 1, 0, 1)
    		layout.Size = UDim2.new(1, -2, 1, -2)
    		layout.AutomaticCanvasSize = Enum.AutomaticSize.Y
    		layout.CanvasSize = UDim2.new(0, 0, 0, 0)
    		layout.ScrollBarImageColor3 = Color3.fromRGB(55, 175, 225)
    		layout.ScrollingDirection = Enum.ScrollingDirection.Y
    		layout.ScrollBarThickness = 4
    		layout.TopImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.MidImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.BottomImage = "rbxasset://textures/AvatarEditorImages/LightPixel.png"
    		layout.Parent = outline
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.FillDirection = Enum.FillDirection.Vertical
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = layout

    		container.Parent = parent.instances.canvas
    	end

    	function UIList.into(self, parent, base, flag)
    self:_makeInstances(parent)
    		self:_reset()

    		base.features[flag] = self
    		return self
    	end
    end

    local UITextBox = {}
    UITextBox.__index = UITextBox
    do
    	function UITextBox.new(parent, flag)
    		assert(flag, "UITextBox.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UITextBox.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UITextBox)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())

    		parent.instances.container.Size += UDim2.new(0 , 0, 0, 24)
    		return UITextBox.into((self ) , parent, base, flag)
    	end

    	function UISection.newTextBox(self, flag)
    return UITextBox.new(self, flag)
    	end

    	function UITextBox.set(self, text)
    local textbox = (self ).instances.textbox
    		local text = string.sub(text, 1, 20)

    		if self.value == text then
    			textbox.Text = text
    			return self
    		end

    		textbox.Text = text

    		self.value = text
    		self.changed:Fire(self.value)
    		return self
    	end

    	function UITextBox.setLabel(self, label)
    assert(label, "UITextBox.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UITextBox.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.textbox.PlaceholderText = label
    		return self
    	end

    	function UITextBox._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, 20)
    		container.BackgroundTransparency = 1

    		local outline= Instance.new("Frame")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Position = UDim2.new(0, 5, 0, 0)
    		outline.Size = UDim2.new(1, -10, 0, 18)
    		outline.Parent = container

    		local inline= Instance.new("Frame")
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.BorderSizePixel = 0
    		inline.Parent = outline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline

    		local textbox= Instance.new("TextBox")
    		textbox.Font = Enum.Font.Arial
    		textbox.TextSize = 12
    		textbox.TextStrokeTransparency = 0
    		textbox.Position = UDim2.new(0, 0, 0, 0)
    		textbox.Size = UDim2.new(1, 0, 1, 0)
    		textbox.BackgroundTransparency = 1
    		textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
    		textbox.TextXAlignment = Enum.TextXAlignment.Center
    		textbox.Text = ""
    		textbox.ClearTextOnFocus = false
    		textbox.Parent = inline
    		self.instances.textbox = textbox

    		container.Parent = parent.instances.canvas
    	end

    	function UITextBox.into(self, parent, base, flag)
    self:_makeInstances(parent)
    		self:set("")

    		local textbox = self.instances.textbox

    		self._trove:Connect(textbox:GetPropertyChangedSignal("Text"), function()
    			textbox.TextXAlignment = Enum.TextXAlignment.Center
    			self:set(textbox.Text)
    		end)

    		base.features[flag] = self
    		return self
    	end
    end

    local UILabel = {}
    UILabel.__index = UILabel
    do
    	function UILabel.new(parent, flag)
    		assert(flag, "UILabel.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UILabel.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UILabel)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = false

    		self.base = base

    		parent.instances.container.Size += UDim2.new(0 , 0, 0, 19)
    		return UILabel.into((self ) , parent, base, flag)
    	end

    	function UISection.newLabel(self, flag)
    return UILabel.new(self, flag)
    	end

    	function UILabel.set(self, state)
    return self
    	end

    	function UILabel.setLabel(self, label)
    assert(label, "UILabel.setLabel(_, label) : _ -> expected string, got nil")
    		assert(typeof(label) == "string", "UILabel.setLabel(_, label) : _ -> expected string, got " .. typeof(label))

    		self.instances.label.Text = label
    		return self
    	end

    	function UILabel.newKeybind(self, flag, modes)
    return ((UIKeybind.new(self, flag, modes or { "Always", "Toggle", "Hold", "Release" }, self.base) ))
    end

    	function UILabel.newColorpicker(self, flag, hasAlpha)
    return ((UIColorpicker.new(self, flag, self.base, hasAlpha or false) ))
    end

    	function UILabel._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, 15)
    		container.BackgroundTransparency = 1

    		local label= Instance.new("TextLabel")
    		label.Font = Enum.Font.Arial
    		label.TextSize = 12
    		label.TextStrokeTransparency = 0
    		label.Position = UDim2.new(0, 5, 0.5, 0)
    		label.AnchorPoint = Vector2.new(0, 0.5)
    		label.Size = UDim2.new(1, -10, 0, 11)
    		label.Text = ""
    		label.BackgroundTransparency = 1
    		label.TextColor3 = Color3.fromRGB(255, 255, 255)
    		label.TextXAlignment = Enum.TextXAlignment.Left
    		label.Parent = container
    		self.instances.label = label

    		local layout= Instance.new("Frame")
    		layout.Size = UDim2.new(1, -10, 0, 13)
    		layout.Position = UDim2.new(0, 5, 0, 1)
    		layout.BackgroundTransparency = 1
    		layout.Parent = container
    		self.instances.layout = layout

    		local listLayout= Instance.new("UIListLayout")
    		listLayout.Padding = UDim.new(0, 4)
    		listLayout.FillDirection = Enum.FillDirection.Horizontal
    		listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    		listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    		listLayout.Parent = layout

    		container.Parent = parent.instances.canvas
    	end

    	function UILabel.into(self, parent, base, flag)
    self:_makeInstances(parent)

    		base.features[flag] = self
    		return self
    	end
    end

    local UICurveGraph = {}
    UICurveGraph.__index = UICurveGraph
    do
    	function UICurveGraph.new(parent, flag)
    		assert(flag, "UICurveGraph.new(_, flag) : _ -> expected string, got nil")
    		assert(typeof(flag) == "string", "UICurveGraph.new(_, flag) : _ -> expected string, got " .. typeof(flag))

    		local base= parent

    		while base.parent do
    			base = base.parent
    		end

    		local base = base
    assert(base.features[flag] == nil, string.format("UIBase.features[\"%s\"] already exists.", flag))

    		local self = setmetatable({}, UICurveGraph)
    		self._trove = parent._trove:Extend()

    		self.instances = {}
    		self.instances.points = {}
    		self.changed = self._trove:Add(Signal.new())
    		self.value = { a = Vector2.new(0, 1), b = Vector2.new(1, 0) }
    		self.base = base

    		self.dragging = false

    		parent.instances.container.Size += UDim2.new(0 , 0, 0, 104)
    		return UICurveGraph.into((self ) , parent, base, flag)
    	end

    	function UISection.newCurveGraph(self, flag)
    return UICurveGraph.new(self, flag)
    	end

    	function UICurveGraph.set(self, value)
    if self.value.a == value.a and self.value.b == value.b then
    			return self
    		end

    		local self = self
    self.value = value
    		self:updatePoints()

    		self.changed:Fire(self.value)
    		return self
    	end

    	function UICurveGraph.updatePoints(self)
    		local instances = self.instances
    		local size = instances.outline.AbsoluteSize

    		local start = size.Y
    		local pointA = size.Y * self.value.a.Y * 3
    		local pointB = size.Y * self.value.b.Y * 3

    		for i = 1, 19 do
    			local t = i / 20
    			local t_1 = 1 - t
    			local p1 = start * t_1 * t_1 * t_1
    			local p2 = pointA * t_1 * t_1 * t
    			local p3 = pointB * t_1 * t * t

    			local point = p1 + p2 + p3

    			self.instances.points[i].Position = UDim2.new(i / 20, 0, point / size.Y, 0)
    		end

    		local value = self.value
    		instances.controlA.Position = UDim2.new(value.a.X, 0, value.a.Y, 0)
    		instances.controlB.Position = UDim2.new(value.b.X, 0, value.b.Y, 0)
    	end

    	function UICurveGraph._makeInstances(self, parent)
    		local container= Instance.new("Frame")
    		container.Size = UDim2.new(1, 0, 0, 100)
    		container.BackgroundTransparency = 1

    		local outline= Instance.new("Frame")
    		outline.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    		outline.BorderSizePixel = 1
    		outline.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		outline.Size = UDim2.new(1, -10, 1, -2)
    		outline.Position = UDim2.new(0, 5, 0, 1)
    		outline.Parent = container
    		self.instances.outline = outline

    		local inline= Instance.new("Frame")
    		inline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    		inline.BorderSizePixel = 0
    		inline.Size = UDim2.new(1, -2, 1, -2)
    		inline.Position = UDim2.new(0, 1, 0, 1)
    		inline.Parent = outline
    		self.instances.inline = inline

    		local gradient= Instance.new("UIGradient")
    		gradient.Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(25, 25, 25))
    		gradient.Rotation = 90
    		gradient.Parent = inline

    		for scale = 0.25, 0.75, 0.25 do
    			local line = Instance.new("Frame")
    			line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    			line.Position = UDim2.new(scale, 0, 0, 0)
    			line.BorderSizePixel = 0
    			line.Size = UDim2.new(0, 1, 1, 0)
    			line.Parent = inline
    		end

    		for scale = 0.25, 0.75, 0.25 do
    			local line = Instance.new("Frame")
    			line.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    			line.Position = UDim2.new(0, 0, scale, 0)
    			line.BorderSizePixel = 0
    			line.Size = UDim2.new(1, 0, 0, 1)
    			line.Parent = inline
    		end

    		local graph= Instance.new("Frame")
    		graph.BorderSizePixel = 0
    		graph.Size = UDim2.new(1, -6, 1, -6)
    		graph.Position = UDim2.new(0, 3, 0, 3)
    		graph.BackgroundTransparency = 1
    		graph.Parent = inline
    		self.instances.graph = graph

    		for i = 1, 19 do
    			local point = Instance.new("Frame")
    			point.BackgroundColor3 = Color3.fromRGB(55, 175, 225)
    			point.Position = UDim2.new(i / 20, 0, 0.5, 0)
    			point.AnchorPoint = Vector2.new(0.5, 0.5)
    			point.BorderSizePixel = 1
    			point.BorderColor3 = Color3.fromRGB(0, 0, 0)
    			point.Size = UDim2.new(0, 4, 0, 4)
    			point.Parent = graph
    			self.instances.points[i] = point
    		end

    		local controlA = Instance.new("TextButton")
    		controlA.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    		controlA.AnchorPoint = Vector2.new(0.5, 0.5)
    		controlA.BorderSizePixel = 1
    		controlA.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		controlA.Size = UDim2.new(0, 4, 0, 4)
    		controlA.Text = ""
    		controlA.AutoButtonColor = false
    		controlA.Parent = graph
    		self.instances.controlA = controlA

    		local controlB = Instance.new("TextButton")
    		controlB.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    		controlB.AnchorPoint = Vector2.new(0.5, 0.5)
    		controlB.BorderSizePixel = 1
    		controlB.BorderColor3 = Color3.fromRGB(0, 0, 0)
    		controlB.Size = UDim2.new(0, 4, 0, 4)
    		controlB.Text = ""
    		controlB.AutoButtonColor = false
    		controlB.Parent = graph
    		self.instances.controlB = controlB

    		container.Parent = parent.instances.canvas
    	end

    	function UICurveGraph.into(self, parent, base, flag)
    self:_makeInstances(parent)
    		self:updatePoints()

    		local base = base

    base:makeDraggable(self.instances.controlA, self._trove, function(input)
    			local inline = self.instances.graph
    			local position = input.Position

    			local percentX = math.clamp((position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X, 0, 1)
    			local percentY = math.clamp((position.Y - inline.AbsolutePosition.Y) / inline.AbsoluteSize.Y, 0, 1)

    			self:set({ a = Vector2.new(percentX, percentY), b = self.value.b })
    		end)

    		base:makeDraggable(self.instances.controlB, self._trove, function(input)
    			local inline = self.instances.graph
    			local position = input.Position

    			local percentX = math.clamp((position.X - inline.AbsolutePosition.X) / inline.AbsoluteSize.X, 0, 1)
    			local percentY = math.clamp((position.Y - inline.AbsolutePosition.Y) / inline.AbsoluteSize.Y, 0, 1)

    			self:set({ a = self.value.a, b = Vector2.new(percentX, percentY) })
    		end)

    		base.features[flag] = self
    		return self
    	end
    end
end


-- ====================== COSMETIC CHANGER INTEGRATION ======================
-- Uses the UI already implemented in this file; no Linoria dependency is added.
-- The supplied Cosmetic Changer exposes:
--   GetWeapons(), GetCosmetics(weapon, type), Apply(weapon, cosmetic, type)
--   GetEquipData(), LoadEquipData(), GetEquipped()
-- ============================================================
-- Cosmetic Changer - UI 제거 버전 (로직만)
-- 당신의 UI에서 호출해서 쓰세요
-- ============================================================

local CosmeticChanger = {}

do
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
if not lp then return end

local lps = lp:FindFirstChild("PlayerScripts") or lp:WaitForChild("PlayerScripts", 10)
local ctrls = lps and (lps:FindFirstChild("Controllers") or lps:WaitForChild("Controllers", 10))
local rmods = ReplicatedStorage:FindFirstChild("Modules") or ReplicatedStorage:WaitForChild("Modules", 10)
if not ctrls or not rmods then return end

local function safeRequire(m)
if not m then return nil end
local ok, r = pcall(require, m)
return ok and r or nil
end

local elib = safeRequire(rmods:WaitForChild("EnumLibrary", 10))
if elib and elib.WaitForEnumBuilder then
pcall(function() elib:WaitForEnumBuilder() end)
end
local clib = safeRequire(rmods:WaitForChild("CosmeticLibrary", 10))
local ilib = safeRequire(rmods:WaitForChild("ItemLibrary", 10))
local consts = safeRequire(rmods:WaitForChild("CONSTANTS", 10))
local dctrl = safeRequire(ctrls:WaitForChild("PlayerDataController", 10))
if not (elib and clib and ilib and consts and dctrl and clib.Cosmetics) then
warn("[CosmeticChanger] 필수 모듈 로드 실패")
return
end
local coss = clib.Cosmetics

-- ============================================================
-- 상수 (커스텀 스킨 ID)
-- ============================================================
local KNIFE_CUSTOM_SKIN = "Knife (Custom Skin)"
local REAVER_KNIFE_CUSTOM_SKIN = "reaver"
local DAGGERS_CUSTOM_SKIN = "Jett"
local SATCHEL_CUSTOM_SKIN = "Raze"
local SNIPER_CUSTOM_SKIN = "Chamber"
local RPG_CUSTOM_SKIN = "RPG Raze"
local FISTS_CUSTOM_SKIN = "Agent"
local BOW_CUSTOM_SKIN = "Sova"
local ASSAULT_RIFLE_CUSTOM_SKIN = "Vandal"
local DICE_TRIPMINE_SKIN = "Subspace Tripmine (Custom Skin)"
local DICE_TRIPMINE_OUTER_MESH_ID = "rbxassetid://5555691474"
local DICE_TRIPMINE_INNER_MESH_ID = "rbxassetid://5555691356"
local DICE_TRIPMINE_IMAGE_ID = "rbxassetid://98372867049331"
local DICE_TRIPMINE_IMAGE_HIGH_RES_ID = "rbxassetid://75601061529918"
local DICE_TRIPMINE_MESH_SCALE = 3.35
local DICE_TRIPMINE_WORLD_MESH_SCALE = 3.25
local SPIKE_TRIPMINE_SKIN = "Spike"
local SPIKE_TRIPMINE_MESH_ID = "rbxassetid://97754746098028"
local TRIPMINE_STAR_REMOVE_MESH_ID = "rbxassetid://13792525075"
local SPIKE_TRIPMINE_MESH_SCALE = 85
local SPIKE_TRIPMINE_WORLD_MESH_SCALE = 50
local SNIPER_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://98786413608787"
local SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID = "rbxassetid://131686603013672"
local SNIPER_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.025, 0.025, 0.025)
local SNIPER_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0, -0.25, 0)
local DAGGERS_CUSTOM_SOURCE_MESH_ID = "rbxassetid://94772705561955"
local DAGGERS_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://128075492497238"
local DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID= "rbxassetid://79246900644201"
local DAGGERS_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.03, 0.03, 0.03)
local DAGGERS_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, -90)
local SATCHEL_CUSTOM_REPLACEMENT_MESH_ID = "rbxassetid://129982008330139"
local SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID= "rbxassetid://121713947189258"
local SATCHEL_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.5, 0.5, 0.5)
local SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE= Vector3.new(0.6, 0.6, 0.6)
local SATCHEL_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, -90, 0)
local RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://81554047161707"
local RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://133257377819985"
local RPG_CUSTOM_REPLACEMENT_SCALE = 0.5
local RPG_CUSTOM_REPLACEMENT_ROTATION = Vector3.new(0, 90, 0)
local RPG_CUSTOM_REPLACEMENT_OFFSET = Vector3.new(0.04, 0, 0)
local FISTS_CUSTOM_LEFT_MESH_ID = "rbxassetid://120273083766829"
local FISTS_CUSTOM_LEFT_TEXTURE_ID = "rbxassetid://124608382264962"
local FISTS_CUSTOM_RIGHT_MESH_ID = "rbxassetid://129220833982000"
local FISTS_CUSTOM_RIGHT_TEXTURE_ID = "rbxassetid://118482605175566"
local FISTS_CUSTOM_MESH_SCALE = Vector3.new(0.1, 0.1, 0.1)
local FISTS_CUSTOM_LEFT_ROTATION = Vector3.new(45, 0, 0)
local FISTS_CUSTOM_RIGHT_ROTATION = Vector3.new(-45, 0, 0)
local BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID = "rbxassetid://80147707463344"
local BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID = "rbxassetid://87690225474067"
local BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID = "rbxassetid://97839236861642"
local BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID = "rbxassetid://82458179247269"
local BOW_CUSTOM_REPLACEMENT_SIZE = Vector3.new(0.25, 0.25, 0.25)

local CUSTOM_SKIN_IMAGE_OVERRIDES = {
[REAVER_KNIFE_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
["sky"] = { Image = "", ImageHighResolution = "" },
["Camera"] = { Image = "", ImageHighResolution = "" },
["Grenade Raze"] = { Image = "", ImageHighResolution = "" },
[DAGGERS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
[SATCHEL_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
[SNIPER_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
["Operator"] = { Image = "", ImageHighResolution = "" },
[RPG_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
[FISTS_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
[BOW_CUSTOM_SKIN] = { Image = "", ImageHighResolution = "" },
[ASSAULT_RIFLE_CUSTOM_SKIN]= { Image = "", ImageHighResolution = "" },
[DICE_TRIPMINE_SKIN] = { Image = DICE_TRIPMINE_IMAGE_ID, ImageHighResolution = DICE_TRIPMINE_IMAGE_HIGH_RES_ID },
[SPIKE_TRIPMINE_SKIN] = { Image = "", ImageHighResolution = "" }
}

local SNIPER_MESH_SKIN_OVERRIDES = {
[SNIPER_CUSTOM_SKIN] = {
Skin = SNIPER_CUSTOM_SKIN,
BodyMeshIds = { "rbxassetid://95497877882755", "rbxassetid://118920880889483", "rbxassetid://80662423119419" },
RemoveMeshIds = { "rbxassetid://100168191352015", "rbxassetid://82935541182957", "rbxassetid://95388370230390", "rbxassetid://84918196407550" },
ReplacementMeshId = SNIPER_CUSTOM_REPLACEMENT_MESH_ID,
ReplacementTextureId = SNIPER_CUSTOM_REPLACEMENT_TEXTURE_ID,
ReplacementSize = SNIPER_CUSTOM_REPLACEMENT_SIZE,
ReplacementOffset = SNIPER_CUSTOM_REPLACEMENT_OFFSET
},
["Operator"] = {
Skin = "Operator",
BodyMeshIds = { "rbxassetid://13188893115", "rbxassetid://13188892761", "rbxassetid://14778413014", "rbxassetid://13188893017", "rbxassetid://14774727092" },
RemoveMeshIds = { "rbxassetid://13188893310", "rbxassetid://13188892855" },
BulletMeshIds = { "rbxassetid://14002915797" },
MagazineMeshIds = { "rbxassetid://13188892532", "rbxassetid://13188892651" },
BodyReplacementMeshId = "rbxassetid://132995629661821",
BodyReplacementTextureId = "rbxassetid://80634410259243",
ScopeReplacementMeshId = "rbxassetid://103988563532751",
ScopeReplacementTextureId = "rbxassetid://136789986141252",
MagazineReplacementMeshId = "rbxassetid://80074307887476",
MagazineReplacementTextureId = "rbxassetid://80634410259243",
ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
ReplacementOffset = Vector3.new(0, -0.25, 0),
ScopeOffset = Vector3.new(0.175, 0.5, 0.005),
MagazineOffset = Vector3.new(0.7, 0, 0.05),
BulletOffset = Vector3.new(-1.25, 0, 0),
ReplacementVersion = 9
}
}

local DAGGERS_MESH_SKIN_OVERRIDES = {
[DAGGERS_CUSTOM_SKIN] = {
Skin = DAGGERS_CUSTOM_SKIN,
SourceMeshIds = { DAGGERS_CUSTOM_SOURCE_MESH_ID },
ReplacementMeshId = DAGGERS_CUSTOM_REPLACEMENT_MESH_ID,
ReplacementTextureId = DAGGERS_CUSTOM_REPLACEMENT_TEXTURE_ID,
ReplacementSize = DAGGERS_CUSTOM_REPLACEMENT_SIZE,
ReplacementRotation = DAGGERS_CUSTOM_REPLACEMENT_ROTATION,
ReplacementVersion = 6,
FallbackBodyNames = { "LeftBody", "RightBody" }
}
}

local SATCHEL_MESH_SKIN_OVERRIDES = {
[SATCHEL_CUSTOM_SKIN] = {
Skin = SATCHEL_CUSTOM_SKIN,
SourceMeshIds = { "rbxassetid://138805549853994", "rbxassetid://125258747465100", "rbxassetid://111319295872696", "rbxassetid://129504437671598", "rbxassetid://104440368867933" },
ReplacementMeshId = SATCHEL_CUSTOM_REPLACEMENT_MESH_ID,
ReplacementTextureId = SATCHEL_CUSTOM_REPLACEMENT_TEXTURE_ID,
ReplacementSize = SATCHEL_CUSTOM_REPLACEMENT_SIZE,
WorldReplacementSize = SATCHEL_CUSTOM_WORLD_REPLACEMENT_SIZE,
ReplacementRotation = SATCHEL_CUSTOM_REPLACEMENT_ROTATION,
ReplacementVersion = 5
},
[REAVER_KNIFE_CUSTOM_SKIN] = {
Skin = REAVER_KNIFE_CUSTOM_SKIN,
SourceMeshIds = { "rbxassetid://85166039303292", "rbxassetid://125674590013235", "rbxassetid://97042702941502", "rbxassetid://116723276788898", "rbxassetid://99266754879173" },
ReplacementMeshId = "rbxassetid://76054449109492",
ReplacementTextureId = "rbxassetid://117578984602503",
ReplacementSize = Vector3.new(0.3, 0.3, 0.3),
ReplacementRotation = Vector3.new(0, 90, 0),
ReplacementOffset = Vector3.new(0, 0.5, 0),
ReplacementVersion = 3
},
["sky"] = {
Skin = "sky",
SourceMeshIds = { "rbxassetid://140203670599306" },
ReplacementMeshId = "rbxassetid://78577370691269",
ReplacementTextureId = "rbxassetid://130284287910497",
ReplacementSize = Vector3.new(0.6, 0.6, 0.6),
ReplacementRotation = Vector3.new(0, 90, 0),
WorldSourceMeshIds = { "rbxassetid://140203670599306" },
WorldReplacementMeshId = "rbxassetid://111122607123480",
WorldReplacementTextureId = "rbxassetid://86629139856581",
WorldReplacementSize = Vector3.new(0.3, 0.3, 0.3),
WorldReplacementRotation = Vector3.zero,
ReplacementVersion = 2
},
["Grenade Raze"] = {
Skin = "Grenade Raze",
SourceMeshIds = { "rbxassetid://87132852844264", "rbxassetid://96681677373844", "rbxassetid://121396126155803", "rbxassetid://121842208464560" },
ReplacementMeshId = "rbxassetid://80612596590820",
ReplacementTextureId = "rbxassetid://123233413518598",
ReplacementSize = Vector3.new(0.8, 0.8, 0.8),
ReplacementVersion = 2
},
["Camera"] = {
Skin = "Camera",
SourceMeshIds = { "rbxassetid://17835823024", "rbxassetid://17835823121", "rbxassetid://17835823211" },
ReplacementMeshId = "rbxassetid://112849634500139",
ReplacementTextureId = "rbxassetid://126465878813440",
ReplacementSize = Vector3.new(0.5, 0.5, 0.5),
ReplacementRotation = Vector3.new(0, 0, -90),
WorldSourceMeshIds = { "rbxassetid://17835823024", "rbxassetid://17835823121", "rbxassetid://17835823211" },
WorldReplacementSize = Vector3.new(2, 2, 2),
WorldReplacementRotation = Vector3.new(0, 90, -90),
ReplacementVersion = 2
}
}

local RPG_MESH_SKIN_OVERRIDES = {
[RPG_CUSTOM_SKIN] = {
Skin = RPG_CUSTOM_SKIN,
BodyMeshIds = { "rbxassetid://17638908187", "rbxassetid://17638908626" },
JuggleMeshIds = { "rbxassetid://17638908803", "rbxassetid://17638907818" },
RocketMeshIds = { "rbxassetid://17638908803", "rbxassetid://17638907818" },
BodyReplacementMeshId = RPG_CUSTOM_BODY_REPLACEMENT_MESH_ID,
BodyReplacementTextureId = RPG_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
ReplacementScale = RPG_CUSTOM_REPLACEMENT_SCALE,
ReplacementRotation = RPG_CUSTOM_REPLACEMENT_ROTATION,
ReplacementOffset = RPG_CUSTOM_REPLACEMENT_OFFSET,
ReplacementVersion = 3
}
}

local FISTS_MESH_SKIN_OVERRIDES = {
[FISTS_CUSTOM_SKIN] = {
Skin = FISTS_CUSTOM_SKIN,
LeftPartName = "LeftItem", RightPartName = "RightItem",
LeftMeshId = FISTS_CUSTOM_LEFT_MESH_ID, LeftTextureId = FISTS_CUSTOM_LEFT_TEXTURE_ID,
RightMeshId = FISTS_CUSTOM_RIGHT_MESH_ID, RightTextureId = FISTS_CUSTOM_RIGHT_TEXTURE_ID,
MeshScale = FISTS_CUSTOM_MESH_SCALE,
LeftRotation = FISTS_CUSTOM_LEFT_ROTATION,
RightRotation = FISTS_CUSTOM_RIGHT_ROTATION,
ReplacementVersion = 1
}
}

local BOW_MESH_SKIN_OVERRIDES = {
[BOW_CUSTOM_SKIN] = {
Skin = BOW_CUSTOM_SKIN,
BodyMeshIds = { "rbxassetid://116947825701555", "rbxassetid://80510746199823" },
ArrowMeshIds = { "rbxassetid://108027163190911", "rbxassetid://114261802270550" },
BodyReplacementMeshId = BOW_CUSTOM_BODY_REPLACEMENT_MESH_ID,
BodyReplacementTextureId = BOW_CUSTOM_BODY_REPLACEMENT_TEXTURE_ID,
ArrowReplacementMeshId = BOW_CUSTOM_ARROW_REPLACEMENT_MESH_ID,
ArrowReplacementTextureId = BOW_CUSTOM_ARROW_REPLACEMENT_TEXTURE_ID,
ReplacementSize = BOW_CUSTOM_REPLACEMENT_SIZE,
ReplacementVersion = 2
}
}

local ASSAULT_RIFLE_MESH_SKIN_OVERRIDES = {
[ASSAULT_RIFLE_CUSTOM_SKIN] = {
Skin = ASSAULT_RIFLE_CUSTOM_SKIN,
BodyMeshIds = { "rbxassetid://17661950733", "rbxassetid://17661950585", "rbxassetid://17662005180", "rbxassetid://17662016762" },
BoltMeshIds = { "rbxassetid://17661950452" },
MagazineMeshIds = { "rbxassetid://17662005301", "rbxassetid://17662005453" },
ReloadMagazineMeshIds = { "rbxassetid://17662005453", "rbxassetid://17662005301" },
BodyReplacementMeshId = "rbxassetid://138100951261312",
BodyReplacementTextureId = "rbxassetid://84167100219585",
MagazineReplacementMeshId = "rbxassetid://92935167277909",
MagazineReplacementTextureId = "rbxassetid://84167100219585",
ReloadMagazineReplacementMeshId = "rbxassetid://92935167277909",
ReloadMagazineReplacementTextureId = "rbxassetid://84167100219585",
ReplacementSize = Vector3.new(0.35, 0.35, 0.35),
ReplacementOffset = Vector3.new(0.1, -0.25, 0.04),
MagazineOffset = Vector3.new(-0.135, -0.2, -0.03),
ReplacementVersion = 6
}
}

local TRIPMINE_MESH_SKIN_OVERRIDES = {
[DICE_TRIPMINE_SKIN] = {
Skin = DICE_TRIPMINE_SKIN,
MeshIds = { DICE_TRIPMINE_OUTER_MESH_ID, DICE_TRIPMINE_INNER_MESH_ID },
RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
Scale = DICE_TRIPMINE_MESH_SCALE, WorldScale = DICE_TRIPMINE_WORLD_MESH_SCALE,
WorldGroundOffset = 0.5, ExtraMeshScale = 1.15, WorldExtraMeshScale = 1,
Color = Color3.fromRGB(255, 255, 255), Material = Enum.Material.SmoothPlastic, Reflectance = 0, ClearTexture = true
},
[SPIKE_TRIPMINE_SKIN] = {
Skin = SPIKE_TRIPMINE_SKIN,
MeshId = SPIKE_TRIPMINE_MESH_ID,
RemoveMeshId = TRIPMINE_STAR_REMOVE_MESH_ID,
Scale = SPIKE_TRIPMINE_MESH_SCALE, WorldScale = SPIKE_TRIPMINE_WORLD_MESH_SCALE,
WorldGroundOffset = 0.5, Color = Color3.fromRGB(163, 162, 165), ClearTexture = true
}
}

-- ============================================================
-- 핵심 데이터
-- ============================================================
local equip, favs = {}, {}
local fcache = {}

local function banned(n)
if type(n) ~= "string" then return true end
return n:find("MISSING_") or n:find("Bubblegum") or n:find("Ragdoll")
or n:find("Fall Apart") or n:find("Every Finisher Ever")
end

local function toenum(n)
if not elib then return nil end
local ok, id = pcall(elib.ToEnum, elib, n)
return ok and id or nil
end

local function clonecos(name, ctype, inv, favonly)
if banned(name) then return nil end
local base = coss[name]
if not base then return nil end
local d = table.clone(base)
d.Name = name
d.Type = d.Type or ctype
d.Seed = d.Seed or math.random(1, 1000000)
d.Owned, d.Unlocked, d.Locked = true, true, false
d.Amount = math.max(1, tonumber(d.Amount) or 1)
d.Count = math.max(1, tonumber(d.Count) or 1)
local eid = toenum(name)
if eid then d.Enum = eid; d.ObjectID = d.ObjectID or eid end
if inv ~= nil then d.Inverted = inv end
if favonly ~= nil then d.OnlyUseFavorites = favonly end
return d
end

local finv = {}
local function rebuildinv()
table.clear(finv)
for _, cos in pairs(equip) do
for _, cd in pairs(cos) do
if cd and cd.Name and not banned(cd.Name) then
finv[cd.Name] = cd
end
end
end
end
rebuildinv()

-- ============================================================
-- PlayerData 훅 (가짜 인벤토리)
-- ============================================================
local oget = dctrl.Get
dctrl.Get = function(self, key)
local data = oget(self, key)
if key == "CosmeticInventory" then
local proxy = {}
if data then for k, v in pairs(data) do if not banned(k) then proxy[k] = v end end end
for name, c in pairs(finv) do
if proxy[name] == nil or type(proxy[name]) == "boolean" then
proxy[name] = c
end
end
return proxy
end
if key == "FavoritedCosmetics" then
local res = data and table.clone(data) or {}
for wep, fv in pairs(favs) do
local slot = res[wep] or {}
res[wep] = slot
for name, f in pairs(fv) do
if not banned(name) then slot[name] = f end
end
end
return res
end
return data
end

local ogetwep = dctrl.GetWeaponData
dctrl.GetWeaponData = function(self, wname)
local data = ogetwep(self, wname)
if not data then return nil end
local merged = table.clone(data)
merged.Name = wname
local weq = equip[wname]
if weq then for ct, cd in pairs(weq) do merged[ct] = cd end end
return merged
end

local function saferep(key)
pcall(function()
if dctrl.CurrentData then dctrl.CurrentData:Replicate(key) end
end)
end

-- ============================================================
-- 리모트 훅
-- ============================================================
local fctrl = safeRequire(ctrls:WaitForChild("FighterController", 10))
local citem = safeRequire(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
local cvm = safeRequire(lps.Modules.ClientReplicatedClasses.ClientFighter.ClientItem.ClientViewModel)

if hookfunction then
local rems = ReplicatedStorage:FindFirstChild("Remotes")
local drems = rems and rems:FindFirstChild("Data")
local eqrem = drems and drems:FindFirstChild("EquipCosmetic")
local favrem = drems and drems:FindFirstChild("FavoriteCosmetic")

if eqrem then
hookfunction(eqrem.FireServer, newcclosure(function(self, wname, ctype, cname, opts)
opts = opts or {}
if not cname or cname == "None" or cname == "" then
equip[wname] = equip[wname] or {}
equip[wname][ctype] = nil
if not next(equip[wname]) then equip[wname] = nil end
rebuildinv()
task.defer(saferep, "WeaponInventory")
return eqrem.FireServer(self, wname, ctype, cname, opts)
end
if banned(cname) then return eqrem.FireServer(self, wname, ctype, cname, opts) end
local rdata = oget(dctrl, "CosmeticInventory")
if rdata and type(rdata[cname]) ~= "boolean" and rdata[cname] ~= nil then
return eqrem.FireServer(self, wname, ctype, cname, opts)
end
equip[wname] = equip[wname] or {}
local cloned = clonecos(cname, ctype, opts.IsInverted, opts.OnlyUseFavorites)
if cloned then equip[wname][ctype] = cloned end
if ctype == "Finisher" then fcache[wname] = cname end
rebuildinv()
task.defer(saferep, "WeaponInventory")
end))
end

if favrem then
hookfunction(favrem.FireServer, newcclosure(function(self, fwep, fname, fstate)
if not fname or fname == "None" or fname == "" then
return favrem.FireServer(self, fwep, fname, fstate)
end
if banned(fname) then return favrem.FireServer(self, fwep, fname, fstate) end
favs[fwep] = favs[fwep] or {}
favs[fwep][fname] = fstate or nil
task.spawn(saferep, "FavoritedCosmetics")
end))
end
end

-- ============================================================
-- 뷰모델 훅
-- ============================================================
if cvm and type(cvm.new) == "function" then
local onew = cvm.new
cvm.new = function(rdata, cliitm)
local wname = cliitm.Name
local wplr = cliitm.ClientFighter and cliitm.ClientFighter.Player
if wplr == lp and equip[wname] then
local rc = require(ReplicatedStorage.Modules.ReplicatedClass)
local dk = rc:ToEnum("Data")
local slot = rdata[dk] or rdata.Data or {}
rdata[dk] = slot; rdata.Data = nil
local cos = equip[wname]
if cos.Skin then slot[rc:ToEnum("Skin")] = cos.Skin end
if cos.Wrap then slot[rc:ToEnum("Wrap")] = cos.Wrap end
if cos.Charm then slot[rc:ToEnum("Charm")] = cos.Charm end
slot[rc:ToEnum("Name")] = (cos.Skin and (cos.Skin.ViewModelName or cos.Skin.Name)) or wname
slot.Skin, slot.Wrap, slot.Charm, slot.Name = nil, nil, nil, nil
end
return onew(rdata, cliitm)
end
end

-- ============================================================
-- PUBLIC API (당신 UI에서 호출)
-- ============================================================

-- 무기 목록
function CosmeticChanger.GetWeapons()
local list = {}
for name, data in pairs(coss) do
if not banned(name) and data.Type == "Weapon" then
table.insert(list, name)
end
end
table.sort(list)
return list
end

-- 특정 무기의 코스메틱 목록 (ctype: "Skin"/"Wrap"/"Charm"/"Finisher")
function CosmeticChanger.GetCosmetics(weapon, ctype)
ctype = ctype or "Skin"
local list = {}
for name, data in pairs(coss) do
if not banned(name) and data.Type == ctype then
local item = data.ItemName or data.WeaponName or data.Weapon or data.Item
if not item or tostring(item):lower() == tostring(weapon or ""):lower() then
table.insert(list, name)
end
end
end
table.sort(list)
return list
end

-- 스킨 적용
function CosmeticChanger.Apply(weapon, cosmeticName, ctype)
if not weapon or weapon == "" then return end
ctype = ctype or "Skin"
equip[weapon] = equip[weapon] or {}
if not cosmeticName or cosmeticName == "" or cosmeticName == "None" then
equip[weapon][ctype] = nil
else
local cloned = clonecos(cosmeticName, ctype)
if cloned then
equip[weapon][ctype] = cloned
if ctype == "Finisher" then fcache[weapon] = cloned.Name end
end
end
if not next(equip[weapon]) then equip[weapon] = nil end
rebuildinv()
task.defer(function()
saferep("CosmeticInventory")
saferep("WeaponInventory")
end)
end

-- 현재 장착 상태 내보내기
function CosmeticChanger.GetEquipData()
local export = {}
for w, cats in pairs(equip) do
export[w] = {}
for cat, data in pairs(cats) do
export[w][cat] = data and data.Name or nil
end
end
return export
end

-- 장착 상태 불러오기
function CosmeticChanger.LoadEquipData(data)
if type(data) ~= "table" then return end
table.clear(equip)
for w, cats in pairs(data) do
if type(cats) == "table" then
for cat, name in pairs(cats) do
equip[w] = equip[w] or {}
local cloned = clonecos(name, cat)
if cloned then equip[w][cat] = cloned end
end
end
end
rebuildinv()
task.defer(function()
saferep("CosmeticInventory")
saferep("WeaponInventory")
end)
end

-- 특정 무기의 특정 타입 코스메틱 이름 반환
function CosmeticChanger.GetEquipped(weapon, ctype)
local w = equip[weapon]
if not w then return nil end
local c = w[ctype or "Skin"]
return c and c.Name or nil
end

-- 전체 리셋
function CosmeticChanger.Reset()
table.clear(equip)
table.clear(fcache)
rebuildinv()
saferep("WeaponInventory")
end

CosmeticChanger.GetRawEquip = function() return equip end
end

shared.CosmeticChanger = CosmeticChanger


local CosmeticChanger = shared.CosmeticChanger
if not CosmeticChanger then
    warn("[Minho Hub] CosmeticChanger failed to initialize.")
end

-- Example
do
    local base = UIBase.new():setLabel("Minho Hub") do
        local tabList= base:newTabList()
    
        local main= tabList:newTab("Combat")
        local mainTabs = main:newTabList()
        do
            local aimbot = mainTabs:newTab("Aimbot"):intoSections()
            do
                -- UI layout: Main Settings (left), Smooth Settings (left), FOV Settings (right).
                local settings = aimbot:newSection("left", "Main Settings")
                settings:newToggle("main/aimbot/enabled"):setLabel("Enabled")
                settings:newToggle("main/aimbot/closest_part"):setLabel("Closest Part")
                settings:newToggle("main/aimbot/closest_position"):setLabel("Closest Position")
                settings:newToggle("main/aimbot/delay_position"):setLabel("Delay Position")

                local smoothSettings = aimbot:newSection("left", "Smooth Settings")
                smoothSettings:newToggle("main/aimbot/x_smooth"):setLabel("X Smooth")
                smoothSettings:newToggle("main/aimbot/y_smooth"):setLabel("Y Smooth")
                smoothSettings:newToggle("main/aimbot/jump_smoothing"):setLabel("Jump Smoothing")
                smoothSettings:newSlider("main/aimbot/smooth_speed", 1, 100, 1):set(50):setLabel("Speed")

                local aimbotFov = aimbot:newSection("right", "FOV Settings")
                local aimbotFovEnabled = aimbotFov:newToggle("main/aimbot/fov_enabled"):setLabel("Enabled")
                local aimbotShowFov = aimbotFov:newToggle("main/aimbot/show_fov"):setLabel("Show Fov")
                aimbotFov:newToggle("main/aimbot/outline"):setLabel("Outline")
                aimbotFov:newToggle("main/aimbot/fill"):setLabel("Fill")
                aimbotFov:newDropdown("main/aimbot/moving_rotation", false, {"None", "Camera", "Target", "Velocity"}):set("None")
                aimbotFov:newSlider("main/aimbot/rotation_speed", 1, 100, 1):set(50):setLabel("Speed")
                aimbotFov:newSlider("main/aimbot/fov", 5, 3000, 5):set(100):setLabel("FOV")

                aimbotFovEnabled.changed:Connect(function(state)
                    aimbotShowFov:set(state)
                end)
            end

            local silentaimtab = mainTabs:newTab("Silent Aim"):intoSections()
            do
                -- UI layout: Main Settings (left), FOV Settings (right).
                local settings = silentaimtab:newSection("left", "Main Settings")
                settings:newToggle("main/silent_aim/enabled"):setLabel("Enabled")
                settings:newToggle("main/silent_aim/manipulation"):setLabel("Manipulation")
                settings:newToggle("main/silent_aim/closest_part"):setLabel("Closest Part")
                settings:newToggle("main/silent_aim/hit_chance"):setLabel("Hit Chance")
                settings:newSlider("main/silent_aim/hit_chance_value", 1, 100, 1):set(100):setLabel("Hit Chance")

                local silentFov = silentaimtab:newSection("right", "FOV Settings")
                local silentFovEnabled = silentFov:newToggle("main/silent_aim/fov_enabled"):setLabel("Enabled")
                local silentShowFov = silentFov:newToggle("main/silent_aim/show_fov"):setLabel("Show Fov")
                silentFov:newToggle("main/silent_aim/outline"):setLabel("Outline")
                silentFov:newToggle("main/silent_aim/fill"):setLabel("Fill")
                silentFov:newDropdown("main/silent_aim/moving_rotation", false, {"None", "Camera", "Target", "Velocity"}):set("None")
                silentFov:newSlider("main/silent_aim/rotation_speed", 1, 100, 1):set(50):setLabel("Speed")
                silentFov:newSlider("main/silent_aim/fov", 5, 3000, 5):set(100):setLabel("FOV")

                silentFovEnabled.changed:Connect(function(state)
                    silentShowFov:set(state)
                end)
            end

            local triggerbot = mainTabs:newTab("Triggerbot"):intoSections()
            do
                -- Main Triggerbot controls are on the right; requested dropdowns stay at the bottom.
                local settings = triggerbot:newSection("right", "Triggerbot")
                settings:newToggle("main/triggerbot/reaction_time"):setLabel("Reaction Time")
                settings:newToggle("main/triggerbot/reaction_time_offset"):setLabel("Reaction Time Offset")
                settings:newToggle("main/triggerbot/forget_time"):setLabel("Forget Time")
                settings:newToggle("main/triggerbot/shoot_delay"):setLabel("Shoot Delay")
                settings:newToggle("main/triggerbot/max_distance"):setLabel("Max Distance")
                settings:newToggle("main/triggerbot/part_blacklist"):setLabel("Part Blacklist")
                settings:newToggle("main/triggerbot/no_delay_between_targets"):setLabel("No Delay Between Targets")
                settings:newToggle("main/triggerbot/anti_katana"):setLabel("Anti Katana")
                settings:newToggle("main/triggerbot/check_scoped"):setLabel("Check Scoped")
                settings:newDropdown("main/triggerbot/part_blacklist_list", true, {"Head", "Body", "Arms", "Legs"}):set({})
                settings:newDropdown("main/triggerbot/check_scoped_if", true, {"Sniper", "Crossbow"}):set({})
            end

            local rage = mainTabs:newTab("Rage"):intoSections()
            do
                local info = rage:newSection("left", "Main")
                info:newToggle("main/rage/enabled"):setLabel("Enable Rage")
            end
        end
    
        -- Visual parent tab with functional subtabs.
        local visual = tabList:newTab("Visual")
        local visualTabs = visual:newTabList()

        -- Player ESP
        local espOptionsTab = visualTabs:newTab("Player ESP"):intoSections()
        do
            local espLeft = espOptionsTab:newSection("left", "Player ESP")
            espLeft:newToggle("esp/enabled"):setLabel("Enable")
            espLeft:newToggle("esp/box"):setLabel("Box")
            espLeft:newToggle("esp/box_fill"):setLabel("Box Fill")
            espLeft:newToggle("esp/name"):setLabel("Name")
            espLeft:newToggle("esp/health"):setLabel("Health Bar")
            espLeft:newToggle("esp/distance"):setLabel("Distance")
            espLeft:newToggle("esp/highlight"):setLabel("Highlight")
            espLeft:newToggle("esp/display_name"):setLabel("Display Name")

            local espRight = espOptionsTab:newSection("right", "Colors / Style")
            espRight:newLabel("esp/box_color_label"):setLabel("Box Color"):newColorpicker("esp/box_color", false):set({rgb = Color3.fromRGB(255,255,255), alpha = 1})
            espRight:newLabel("esp/box_fill_color_label"):setLabel("Box Fill Color"):newColorpicker("esp/box_fill_color", false):set({rgb = Color3.fromRGB(255,255,255), alpha = 1})
            espRight:newLabel("esp/name_color_label"):setLabel("Name Color"):newColorpicker("esp/name_color", false):set({rgb = Color3.fromRGB(255,255,255), alpha = 1})
            espRight:newLabel("esp/health_color_label"):setLabel("Health Color"):newColorpicker("esp/health_color", false):set({rgb = Color3.fromRGB(153,196,39), alpha = 1})
            espRight:newLabel("esp/highlight_color_label"):setLabel("Highlight Color"):newColorpicker("esp/highlight_color", false):set({rgb = Color3.fromRGB(153,196,39), alpha = 1})
            espRight:newSlider("esp/box_transparency", 0, 1, 100):set(0):setLabel("Box Transparency")
            espRight:newSlider("esp/fill_transparency", 0, 1, 100):set(0.75):setLabel("Fill Transparency")
            espRight:newSlider("esp/name_size", 10, 24, 1):set(14):setLabel("Name Size")
        end

        -- HUD
        local hudTab = visualTabs:newTab("Hud"):intoSections()
        do
            local cross = hudTab:newSection("left", "Crosshair")
            cross:newToggle("hud/crosshair"):setLabel("Crosshair")
            cross:newSlider("drawing_crosshair_length", 1, 20, 1):set(5):setLabel("Length")
            cross:newSlider("drawing_crosshair_gap", 0, 30, 1):set(5):setLabel("Gap")
            cross:newToggle("drawing_crosshair_spin"):setLabel("Spin")
            cross:newSlider("drawing_crosshair_speed", 1, 20, 1):set(5):setLabel("Spin Speed")
            cross:newDropdown("drawing_crosshair_location", false, {"Mouse", "Center", "Target"}):set("Mouse")
            cross:newLabel("hud/crosshair_color_label"):setLabel("Crosshair Color"):newColorpicker("hud/crosshair_color", false):set({rgb = Color3.fromRGB(255,255,255), alpha = 1})

            local target = hudTab:newSection("right", "Target Info")
            target:newToggle("hud/target_info"):setLabel("Target Info")
            target:newDropdown("hud/target_location", false, {"Mouse", "Center", "Target"}):set("Target")

            local notifications = hudTab:newSection("left", "Notifications")
            notifications:newToggle("hud/notifications"):setLabel("Notifications")
            notifications:newDropdown("notification_style", false, {"Default", "Minimalistic", "Eclipse"}):set("Default")
            notifications:newSlider("notification_y_offset", 0, 500, 1):set(50):setLabel("Y Offset")

            local keybinds = hudTab:newSection("right", "Keybind List")
            keybinds:newToggle("hud/keybinds"):setLabel("Keybinds")
            keybinds:newSlider("keybind_x", 0, 2000, 1):set(500):setLabel("X Position")
            keybinds:newSlider("keybind_y", 0, 2000, 1):set(500):setLabel("Y Position")

            local watermark = hudTab:newSection("left", "Watermark")
            watermark:newToggle("hud/watermark"):setLabel("Watermark")
            watermark:newTextBox("watermark_text"):setLabel("Text") :set("mihno.win")
            watermark:newDropdown("watermark_location", false, {"Center", "Mouse", "Target"}):set("Center")
            watermark:newSlider("watermark_x_offset", -1000, 1000, 1):set(0):setLabel("X Offset")
            watermark:newSlider("watermark_y_offset", -1000, 1000, 1):set(0):setLabel("Y Offset")
        end

        -- World (moved from the top-level tabs into Visual).
        local world = visualTabs:newTab("World"):intoSections()
        do
            local environment = world:newSection("left", "World")
            environment:newToggle("world_brightness"):setLabel("World Brightness")
            environment:newSlider("world_brightness_value", 0, 5, 10):set(game:GetService("Lighting").Brightness):setLabel("Brightness")
            environment:newToggle("remove_shadows"):setLabel("Remove Shadows")
            environment:newToggle("world_exposure"):setLabel("World Exposure")
            environment:newSlider("world_exposure_value", -2, 3, 10):set(game:GetService("Lighting").ExposureCompensation):setLabel("Exposure")
            environment:newToggle("world_ambient"):setLabel("World Ambient")
            environment:newLabel("world_ambient_color_label"):setLabel("Ambient Color"):newColorpicker("world_ambient_color", false):set({rgb = game:GetService("Lighting").Ambient, alpha = 1})
            environment:newToggle("world_time"):setLabel("World Time")
            environment:newSlider("world_time_value", 0, 24, 10):set(game:GetService("Lighting").ClockTime):setLabel("Time")
            environment:newToggle("fog_changer"):setLabel("World Fog")
            environment:newLabel("fog_color_label"):setLabel("Fog Color"):newColorpicker("fog_color", false):set({rgb = game:GetService("Lighting").FogColor, alpha = 1})
            environment:newSlider("fog_start", 1, 5000, 1):set(game:GetService("Lighting").FogStart):setLabel("Fog Start")
            environment:newSlider("fog_end", 1, 5000, 1):set(game:GetService("Lighting").FogEnd):setLabel("Fog End")

            local texturePack = world:newSection("right", "Texture Pack")
            texturePack:newToggle("world/texture_pack/enabled"):setLabel("Texture Pack")
            texturePack:newDropdown("world/texture_pack/pack", false, {"Minecraft", "Grods"}):set("Minecraft")
        end

        -- Other: sounds moved here from the old World area.
        local other = visualTabs:newTab("Other"):intoSections()
        do
            local hitSound = other:newSection("left", "Hit Sound")
            hitSound:newToggle("world/sound/hit_enabled"):setLabel("Hit Sound")
            hitSound:newDropdown("world/sound/hit_sound", false, {"sparkle", "bubble", "rust", "pick", "neverlose", "minecraft_zombie", "minecraft_levelup", "minecraft_hit", "minecraft_bow"}):set("sparkle")
            hitSound:newSlider("world/sound/hit_volume", 0, 2, 10):set(1):setLabel("Hit Sound Volume")
            hitSound:newToggle("world/sound/hit_original"):setLabel("Play Original Sound")

            local killSound = other:newSection("right", "Kill Sound")
            killSound:newToggle("world/sound/kill_enabled"):setLabel("Kill Sound")
            killSound:newDropdown("world/sound/kill_sound", false, {"Default", "Bell", "Bubble", "Click", "Minecraft"}):set("Default")
            killSound:newSlider("world/sound/kill_volume", 0, 2, 10):set(1):setLabel("Kill Sound Volume")
        end
        local misc = tabList:newTab("Misc"):intoSections()
        do
            -- Cosmetics is a checkbox-style toggle and is placed above Movement.
            local cosmetics = misc:newSection("left", "Cosmetics")
            do
                cosmetics:newToggle("misc/cosmetics/show_changer"):setLabel("Cosmetics")
            end

            -- Skin Changer: native Minho Hub UI, backed directly by CosmeticChanger.
            local skinChanger = misc:newSection("left", "Skin Changer")
            do
                local weaponOptions = {}
                local skinOptions = {}

                if CosmeticChanger then
                    for _, weapon in ipairs(CosmeticChanger.GetWeapons()) do
                        weaponOptions[weapon] = true
                    end
                end

                local weaponList = skinChanger:newList(
                    "misc/cosmetics/weapon",
                    8,
                    weaponOptions
                )

                local skinList = skinChanger:newList(
                    "misc/cosmetics/skin",
                    8,
                    skinOptions
                )

                local selectedWeapon = nil
                local selectedType = "Skin"

                local function clearList(list)
                    for option in pairs(list.options) do
                        list:remove(option)
                    end
                    list:set(nil)
                end

                local function refreshSkins(weapon)
                    clearList(skinList)
                    if not CosmeticChanger or not weapon then
                        return
                    end

                    local equipped = CosmeticChanger.GetEquipped(weapon, selectedType)
                    for _, cosmetic in ipairs(CosmeticChanger.GetCosmetics(weapon, selectedType)) do
                        skinList:add(cosmetic)
                    end

                    if equipped and skinList.options[equipped] then
                        skinList:set(equipped)
                    end
                end

                weaponList.changed:Connect(function(weapon)
                    selectedWeapon = weapon
                    refreshSkins(weapon)
                end)

                skinList.changed:Connect(function(cosmetic)
                    if not CosmeticChanger or not selectedWeapon or not cosmetic then
                        return
                    end

                    local ok, err = pcall(function()
                        CosmeticChanger.Apply(selectedWeapon, cosmetic, selectedType)
                    end)

                    if not ok then
                        warn("[Minho Hub] Skin apply failed:", err)
                        return
                    end

                    -- Re-read the current equipped value so the selected item
                    -- remains highlighted after Apply() updates the internal data.
                    task.defer(function()
                        local current = CosmeticChanger.GetEquipped(selectedWeapon, selectedType)
                        if current and skinList.options[current] then
                            skinList:set(current)
                        end
                    end)
                end)

                skinChanger:newLabel("misc/cosmetics/info"):setLabel("Select Weapon / Skin")

                -- Optional local persistence for the cosmetic state.
                local saveBtn = skinChanger:newButton("misc/cosmetics/save"):setLabel("Save Skins")
                local loadBtn = skinChanger:newButton("misc/cosmetics/load"):setLabel("Load Skins")
                local resetBtn = skinChanger:newButton("misc/cosmetics/reset"):setLabel("Reset Skins")

                local skinConfigPath = HOME_DIR .. "CosmeticEquip.json"

                saveBtn.changed:Connect(function()
                    if not CosmeticChanger or not writefile then
                        return
                    end
                    pcall(function()
                        writefile(skinConfigPath, HttpService:JSONEncode(CosmeticChanger.GetEquipData()))
                    end)
                end)

                loadBtn.changed:Connect(function()
                    if not CosmeticChanger or not readfile or not isfile then
                        return
                    end
                    if not isfile(skinConfigPath) then
                        return
                    end

                    local ok, data = pcall(function()
                        return HttpService:JSONDecode(readfile(skinConfigPath))
                    end)

                    if ok and type(data) == "table" then
                        CosmeticChanger.LoadEquipData(data)
                        if selectedWeapon then
                            refreshSkins(selectedWeapon)
                        end
                    end
                end)

                resetBtn.changed:Connect(function()
                    if not CosmeticChanger then
                        return
                    end
                    CosmeticChanger.Reset()
                    if selectedWeapon then
                        refreshSkins(selectedWeapon)
                    end
                end)

                -- Load previously saved cosmetic state once on startup.
                if CosmeticChanger and readfile and isfile and isfile(skinConfigPath) then
                    task.defer(function()
                        local ok, data = pcall(function()
                            return HttpService:JSONDecode(readfile(skinConfigPath))
                        end)
                        if ok and type(data) == "table" then
                            pcall(function()
                                CosmeticChanger.LoadEquipData(data)
                            end)
                        end
                    end)
                end
            end

            local movement = misc:newSection("left", "Movement")
            do
                movement:newToggle("misc/movement/no_slide_cooldown"):setLabel("No Slide Cooldown")
                movement:newToggle("misc/movement/speed_multiplier/enabled"):setLabel("Enable Speed Multiplier")
                movement:newSlider("misc/movement/speed_multiplier/mult", 1, 10, 100):set(2):setLabel("Speed Multiplier")
                movement:newToggle("misc/movement/jump_height/enabled"):setLabel("Jump Height Multiplier")
                movement:newSlider("misc/movement/jump_height/mult", 1, 10, 100):set(2):setLabel("Jump Height Multiplier")
                movement:newToggle("misc/movement/infinite_jump"):setLabel("Infinite Jump")
            end

            -- UI only: no functionality is attached to these controls.
            -- Guns stay on the right, with Utilities below them.
            local guns = misc:newSection("right", "Guns")
            do
                guns:newToggle("misc/guns/no_recoil"):setLabel("No Recoil")
                guns:newToggle("misc/guns/no_spread"):setLabel("No Spread")
                guns:newToggle("misc/guns/no_shoot_cooldown"):setLabel("No Shoot Cooldown")
                guns:newSlider("misc/guns/shoot_cooldown", 10, 100, 1):set(10):setLabel("Shoot Cooldown")
            end

            local miscTools = misc:newSection("right", "Utilities")
            do
                -- Checkbox-style controls.
                miscTools:newToggle("misc/utilities/name_spoofer"):setLabel("Name Spoofer")
                miscTools:newTextBox("misc/utilities/name_spoofer_text"):setLabel("Name")
                miscTools:newToggle("misc/utilities/info_spoofer"):setLabel("Info Spoofer")
                miscTools:newDropdown("misc/utilities/info_spoofer_platform", false, {
                    "Mobile",
                    "Desktop",
                    "Controller",
                    "VR",
                }):set("Mobile")
                miscTools:newToggle("misc/utilities/auto_queue"):setLabel("Auto Queue")
            end

        end
    
        local settings= tabList:newTab("Settings"):intoSections()
        do
            local discord = settings:newSection("left", "Discord")
            do
                local DISCORD_INVITE = "https://discord.gg/WXCupTFwu5"
                local joinDiscord = discord:newButton("settings/discord/join"):setLabel("Join Discord")
                local copyInvite = discord:newButton("settings/discord/copy_invite"):setLabel("Copy Discord Invite")

                joinDiscord.changed:Connect(function()
                    if setclipboard then
                        pcall(setclipboard, DISCORD_INVITE)
                    elseif toclipboard then
                        pcall(toclipboard, DISCORD_INVITE)
                    end
                end)

                copyInvite.changed:Connect(function()
                    if setclipboard then
                        pcall(setclipboard, DISCORD_INVITE)
                    elseif toclipboard then
                        pcall(toclipboard, DISCORD_INVITE)
                    end
                end)
            end

            local menu = settings:newSection("left", "Menu")
            do
                menu:newLabel("settings/menu/label_accent"):setLabel("Accent"):newColorpicker("settings/menu/accent"):set({rgb = Color3.fromRGB(55, 175, 225), alpha = 1})
                menu:newLabel("settings/menu/label_font"):setLabel("Font")
                menu:newDropdown("settings/menu/font", false, {"SourceSans"}):set("SourceSans")
                menu:newSlider("settings/menu/text_size", 1, 26, 1):set(16):setLabel("Text Size")
                menu:newButton("settings/menu/unload"):setLabel("Unload")
                menu:newToggle("settings/menu/debug_mode"):setLabel("Debug Mode")
                menu:newToggle("settings/menu/keybind_menu"):setLabel("Keybind Menu")
                menu:newToggle("settings/menu/auto_reconnect"):setLabel("Auto Reconnect")
                menu:newToggle("settings/menu/auto_run_script"):setLabel("Auto Run Script")
                menu:newToggle("settings/menu/auto_load"):setLabel("Auto Load")
                menu:newLabel("settings/menu/label_keybind"):setLabel("Menu Keybind")
                    :newKeybind("settings/menu/menu_keybind", { "Tap" }):set({ key = Enum.KeyCode.RightShift, mode = "Tap" })
                    .activeChanged:Connect(function()
                        base:setVisible(not base.visible)
                    end)
            end

            local configuration = settings:newSection("right", "Configuration")
            do
                configuration:newTextBox("settings/config/name"):setLabel("Config Name")
                configuration:newButton("settings/config/create"):setLabel("Create")
                configList = configuration:newList("settings/config/list", 6, {})
                configList:add("default.json")
                configuration:newButton("settings/config/load"):setLabel("Load")
                configuration:newButton("settings/config/save"):setLabel("Save")
                configuration:newButton("settings/config/delete"):setLabel("Delete")
                configuration:newToggle("settings/config/auto_save"):setLabel("Auto Save To Config")
            end
        end
    
    
        -- ====================== HIT SOUNDS ======================
        -- Do NOT replace every SoundId in the game. That caused footsteps and ambient
        -- sounds to become the selected hit sound. Instead, watch enemy Humanoids and
        -- play a dedicated sound only when their health decreases.
        local hitSoundToggle = base.features["world/sound/hit_enabled"]
        local hitSoundDropdown = base.features["world/sound/hit_sound"]
        local hitSoundVolume = base.features["world/sound/hit_volume"]
        local hitSoundOriginal = base.features["world/sound/hit_original"]

        local function volumeStep(v)
            v = tonumber(v) or 1
            return math.clamp(math.floor(v * 10 + 0.5) / 10, 0, 2)
        end

        local HIT_SOUNDS = {
            sparkle = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/sparkle.mp3",
            bubble = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/bubble.mp3",
            rust = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Rust%20HS.mp3",
            pick = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Pick.mp3",
            neverlose = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Neverlose.mp3",
            minecraft_zombie = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Minecraft_zombie.mp3",
            minecraft_levelup = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Minecraft_levelup.mp3",
            minecraft_hit = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Minecraft_Hit.mp3",
            minecraft_bow = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Hit_Sound/Minecraft_Bow.mp3",
        }

        local hitCache = {}
        local hitWatched = {}

        local function getAsset(url)
            if hitCache[url] then return hitCache[url] end
            local result = url
            pcall(function()
                if writefile and isfile and getcustomasset then
                    local fileName = "minho_sound_" .. tostring(#url % 100000) .. ".asset"
                    if not isfile(fileName) then
                        local data = game:HttpGet(url)
                        if data and #data > 80 then writefile(fileName, data) end
                    end
                    if isfile(fileName) then
                        local custom = getcustomasset(fileName)
                        if custom and custom ~= "" then result = custom end
                    end
                end
            end)
            hitCache[url] = result
            return result
        end

        local function playSound(url, volume, name)
            if not url then return end
            local s = Instance.new("Sound")
            s.Name = name
            s.SoundId = getAsset(url)
            s.Volume = volumeStep(volume)
            s.Parent = game:GetService("SoundService")
            s:Play()
            s.Ended:Connect(function() if s then s:Destroy() end end)
            task.delay(10, function() if s and s.Parent then s:Destroy() end end)
        end

        local function playHit()
            if not hitSoundToggle or not hitSoundToggle.value then return end
            local selected = hitSoundDropdown and hitSoundDropdown.value
            local url = HIT_SOUNDS[selected]
            if url then
                playSound(url, hitSoundVolume and hitSoundVolume.value or 1, "MinhoHub_HitSound")
            end
        end

        local function watchHumanoid(h)
            if not h or not h:IsA("Humanoid") or hitWatched[h] then return end
            hitWatched[h] = h.Health
            h.HealthChanged:Connect(function(newHealth)
                local oldHealth = hitWatched[h]
                hitWatched[h] = newHealth
                if not hitSoundToggle or not hitSoundToggle.value then return end
                if oldHealth and newHealth < oldHealth and newHealth > 0 then
                    local lp = game.Players.LocalPlayer
                    if not (lp and lp.Character and h:IsDescendantOf(lp.Character)) then
                        playHit()
                    end
                end
            end)
        end

        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Humanoid") then watchHumanoid(obj) end
        end
        game.DescendantAdded:Connect(function(obj)
            if obj:IsA("Humanoid") then task.defer(watchHumanoid, obj) end
        end)

        -- Volume remains unchanged when selecting another hit sound.
        if hitSoundVolume then
            hitSoundVolume.changed:Connect(function()
                local v = volumeStep(hitSoundVolume.value)
                if hitSoundVolume.value ~= v then pcall(function() hitSoundVolume:set(v) end) end
            end)
        end

        -- Original hit-sound control. We do not globally replace SoundId, so normal
        -- footsteps/ambient sounds are unaffected. If disabled, likely hit/damage sounds
        -- are muted by name; if enabled, they remain untouched.
        local originalMuted = {}
        local function updateOriginalSounds()
            local allow = hitSoundOriginal and hitSoundOriginal.value
            if allow or not (hitSoundToggle and hitSoundToggle.value) then
                for s, v in pairs(originalMuted) do
                    if s and s.Parent then pcall(function() s.Volume = v end) end
                end
                table.clear(originalMuted)
                return
            end
            for _, s in ipairs(game:GetDescendants()) do
                if s:IsA("Sound") then
                    local n = string.lower(s.Name)
                    if n:find("hit") or n:find("damage") or n:find("hurt") or n:find("impact") then
                        if originalMuted[s] == nil then originalMuted[s] = s.Volume end
                        pcall(function() s.Volume = 0 end)
                    end
                end
            end
        end

        if hitSoundToggle then hitSoundToggle.changed:Connect(updateOriginalSounds) end
        if hitSoundOriginal then hitSoundOriginal.changed:Connect(updateOriginalSounds) end
        task.delay(1.5, updateOriginalSounds)

        -- ====================== KILL SOUND ======================
        local killSoundToggle = base.features["world/sound/kill_enabled"]
        local killSoundDropdown = base.features["world/sound/kill_sound"]
        local killSoundVolume = base.features["world/sound/kill_volume"]

        local KILL_SOUNDS = {
            Default = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Kill_Sound/Default.mp3",
            Bell = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Kill_Sound/Bell.mp3",
            Bubble = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Kill_Sound/Bubble.mp3",
            Click = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Kill_Sound/Click.mp3",
            Minecraft = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/Kill_Sound/Minecraft.mp3",
        }

        local function playKill()
            if not killSoundToggle or not killSoundToggle.value then return end
            local selected = killSoundDropdown and killSoundDropdown.value
            local url = KILL_SOUNDS[selected]
            if url then playSound(url, killSoundVolume and killSoundVolume.value or 1, "MinhoHub_KillSound") end
        end

        local killWatched = {}
        local function watchKill(h)
            if not h or not h:IsA("Humanoid") or killWatched[h] then return end
            killWatched[h] = true
            h.Died:Connect(function()
                if not killSoundToggle or not killSoundToggle.value then return end
                local lp = game.Players.LocalPlayer
                if not lp or (lp.Character and h:IsDescendantOf(lp.Character)) then return end
                local creator = h:FindFirstChild("creator")
                if creator and creator.Value == lp then playKill() end
            end)
        end

        for _, obj in ipairs(game:GetDescendants()) do
            if obj:IsA("Humanoid") then watchKill(obj) end
        end
        game.DescendantAdded:Connect(function(obj)
            if obj:IsA("Humanoid") then task.defer(watchKill, obj) end
        end)

        if killSoundVolume then
            killSoundVolume.changed:Connect(function()
                local v = volumeStep(killSoundVolume.value)
                if killSoundVolume.value ~= v then pcall(function() killSoundVolume:set(v) end) end
            end)
        end

        -- ====================== WORLD MODIFIER ======================
        -- World runtime, based on the supplied World file.
        local Lighting = game:GetService("Lighting")
        local original = {
            Brightness = Lighting.Brightness,
            ExposureCompensation = Lighting.ExposureCompensation,
            Ambient = Lighting.Ambient,
            ClockTime = Lighting.ClockTime,
            GlobalShadows = Lighting.GlobalShadows,
            FogColor = Lighting.FogColor,
            FogStart = Lighting.FogStart,
            FogEnd = Lighting.FogEnd,
        }

        local World = {}

        function World.brightness(value)
            if type(value) ~= "number" then return end
            Lighting.Brightness = math.clamp(value, 0, 5)
        end
        function World.exposure(value)
            if type(value) ~= "number" then return end
            Lighting.ExposureCompensation = math.clamp(value, -2, 3)
        end
        function World.ambient(color)
            if typeof(color) ~= "Color3" then return end
            Lighting.Ambient = color
        end
        function World.removeShadows(bool)
            Lighting.GlobalShadows = not bool
        end
        function World.time(hour)
            if type(hour) ~= "number" then return end
            Lighting.ClockTime = math.clamp(hour, 0, 24)
        end
        function World.fog(color, startDist, endDist)
            if color then Lighting.FogColor = color end
            if startDist then Lighting.FogStart = math.clamp(startDist, 1, 5000) end
            if endDist then Lighting.FogEnd = math.clamp(endDist, 1, 5000) end
        end
        function World.fogStart(value)
            if type(value) ~= "number" then return end
            Lighting.FogStart = math.clamp(value, 1, 5000)
        end
        function World.fogEnd(value)
            if type(value) ~= "number" then return end
            Lighting.FogEnd = math.clamp(value, 1, 5000)
        end
        function World.fullBright()
            Lighting.Brightness = 5
            Lighting.ExposureCompensation = 1
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        end
        function World.nightVision()
            Lighting.Brightness = 5
            Lighting.Ambient = Color3.fromRGB(0, 255, 0)
            Lighting.ExposureCompensation = 2
            Lighting.FogColor = Color3.fromRGB(0, 100, 0)
        end
        function World.hellMode()
            Lighting.Ambient = Color3.fromRGB(150, 0, 0)
            Lighting.FogColor = Color3.fromRGB(255, 50, 0)
            Lighting.FogStart = 10
            Lighting.FogEnd = 300
            Lighting.Brightness = 2
        end
        function World.iceMode()
            Lighting.Ambient = Color3.fromRGB(100, 150, 255)
            Lighting.FogColor = Color3.fromRGB(200, 230, 255)
            Lighting.FogStart = 5
            Lighting.FogEnd = 150
            Lighting.Brightness = 3
        end
        function World.radioactive()
            Lighting.Ambient = Color3.fromRGB(0, 100, 0)
            Lighting.FogColor = Color3.fromRGB(100, 255, 0)
            Lighting.FogStart = 20
            Lighting.FogEnd = 400
            Lighting.Brightness = 1
        end
        function World.horror()
            Lighting.Brightness = 0
            Lighting.ClockTime = 0
            Lighting.Ambient = Color3.fromRGB(0, 0, 0)
            Lighting.FogColor = Color3.fromRGB(20, 20, 20)
            Lighting.FogStart = 1
            Lighting.FogEnd = 50
        end
        function World.night()
            Lighting.ClockTime = 0
            Lighting.Ambient = Color3.fromRGB(0, 0, 100)
            Lighting.FogColor = Color3.fromRGB(20, 20, 60)
            Lighting.Brightness = 1
        end
        function World.day()
            Lighting.ClockTime = 12
            Lighting.Brightness = 2
            Lighting.FogEnd = 100000
        end
        function World.restore()
            Lighting.Brightness = original.Brightness
            Lighting.ExposureCompensation = original.ExposureCompensation
            Lighting.Ambient = original.Ambient
            Lighting.ClockTime = original.ClockTime
            Lighting.GlobalShadows = original.GlobalShadows
            Lighting.FogColor = original.FogColor
            Lighting.FogStart = original.FogStart
            Lighting.FogEnd = original.FogEnd
        end
        pcall(function() getgenv().World = World end)

        local function feature(name) return base.features[name] end
        local brightnessToggle, brightnessValue = feature("world_brightness"), feature("world_brightness_value")
        local exposureToggle, exposureValue = feature("world_exposure"), feature("world_exposure_value")
        local timeToggle, timeValue = feature("world_time"), feature("world_time_value")
        local shadowsToggle = feature("remove_shadows")
        local ambientToggle, ambientColor = feature("world_ambient"), feature("world_ambient_color")
        local fogToggle, fogColor = feature("fog_changer"), feature("fog_color")
        local fogStartValue, fogEndValue = feature("fog_start"), feature("fog_end")

        local function applyBrightness()
            if brightnessToggle.value then World.brightness(tonumber(brightnessValue.value) or original.Brightness)
            else Lighting.Brightness = original.Brightness end
        end
        local function applyExposure()
            if exposureToggle.value then World.exposure(tonumber(exposureValue.value) or original.ExposureCompensation)
            else Lighting.ExposureCompensation = original.ExposureCompensation end
        end
        local function applyTime()
            if timeToggle.value then World.time(tonumber(timeValue.value) or original.ClockTime)
            else Lighting.ClockTime = original.ClockTime end
        end
        local function applyShadows()
            World.removeShadows(shadowsToggle.value)
            if not shadowsToggle.value then Lighting.GlobalShadows = original.GlobalShadows end
        end
        local function applyAmbient()
            if ambientToggle.value and ambientColor.value then World.ambient(ambientColor.value.rgb)
            else Lighting.Ambient = original.Ambient end
        end
        local function applyFog()
            if fogToggle.value and fogColor.value then
                World.fog(fogColor.value.rgb, tonumber(fogStartValue.value), tonumber(fogEndValue.value))
            else
                Lighting.FogColor, Lighting.FogStart, Lighting.FogEnd = original.FogColor, original.FogStart, original.FogEnd
            end
        end

        brightnessToggle.changed:Connect(applyBrightness)
        brightnessValue.changed:Connect(applyBrightness)
        exposureToggle.changed:Connect(applyExposure)
        exposureValue.changed:Connect(applyExposure)
        timeToggle.changed:Connect(applyTime)
        timeValue.changed:Connect(applyTime)
        shadowsToggle.changed:Connect(applyShadows)
        ambientToggle.changed:Connect(applyAmbient)
        ambientColor.changed:Connect(applyAmbient)
        fogToggle.changed:Connect(applyFog)
        fogColor.changed:Connect(applyFog)
        fogStartValue.changed:Connect(applyFog)
        fogEndValue.changed:Connect(applyFog)

        task.defer(function()
            applyBrightness(); applyExposure(); applyTime(); applyShadows(); applyAmbient(); applyFog()
        end)

        -- World Texture Pack
        -- Switches the map texture cleanly: restore the original first, then apply the new pack.
        local worldTextureToggle = base.features["world/texture_pack/enabled"]
        local worldTextureDropdown = base.features["world/texture_pack/pack"]

        local WORLD_TEXTURE_ID = "7658055825"

        local WORLD_TEXTURES = {
            Minecraft = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/texture_pack/item_slot_3_blue_hollow.png",
            Grods = "https://raw.githubusercontent.com/jixyuk12nh-maker/World/main/texture_pack/grods.png",
        }

        local worldTextureCache = {}
        local worldTextureOriginals = {}
        local worldTextureTargets = {}

        local function getWorldTexture(url)
            if worldTextureCache[url] then
                return worldTextureCache[url]
            end

            local success, result = pcall(function()
                if writefile and isfile and getcustomasset then
                    local fileName = "minho_world_" .. tostring(#url % 1000000) .. ".png"

                    if not isfile(fileName) then
                        local data = game:HttpGet(url)
                        if data and #data > 80 then
                            writefile(fileName, data)
                        end
                    end

                    if isfile(fileName) then
                        local asset = getcustomasset(fileName)
                        if asset and asset ~= "" then
                            return asset
                        end
                    end
                end

                return url
            end)

            local asset = (success and result) or url
            worldTextureCache[url] = asset
            return asset
        end

        local function getWorldTextureProperty(obj)
            if obj:IsA("Decal") or obj:IsA("Texture") then
                return "Texture"
            elseif obj:IsA("MeshPart") then
                return "TextureID"
            end
            return nil
        end

        local function getWorldTextureId(value)
            if type(value) ~= "string" then
                return nil
            end
            return string.match(value, "%d+")
        end

        local function rememberWorldTextureTarget(obj, property, original)
            worldTextureOriginals[obj] = original
            worldTextureTargets[obj] = property
        end

        local function findWorldTextureTargets()
            for _, obj in ipairs(game:GetDescendants()) do
                local property = getWorldTextureProperty(obj)
                if property then
                    local success, value = pcall(function()
                        return obj[property]
                    end)

                    if success and type(value) == "string" then
                        -- Only register the actual map texture, not every Decal/Texture/MeshPart.
                        if getWorldTextureId(value) == WORLD_TEXTURE_ID then
                            if worldTextureOriginals[obj] == nil then
                                rememberWorldTextureTarget(obj, property, value)
                            end
                        end
                    end
                end
            end
        end

        local function restoreWorldTextures()
            for obj, original in pairs(worldTextureOriginals) do
                if obj and obj.Parent then
                    local property = worldTextureTargets[obj] or getWorldTextureProperty(obj)
                    if property then
                        pcall(function()
                            -- Remove the currently applied pack before restoring the original.
                            obj[property] = ""
                            obj[property] = original
                        end)
                    end
                end
            end
        end

        local function clearWorldTextureTracking()
            table.clear(worldTextureOriginals)
            table.clear(worldTextureTargets)
        end

        local function getSelectedWorldTexture()
            local selected = worldTextureDropdown and worldTextureDropdown.value or "Minecraft"
            if type(selected) == "table" then
                selected = selected[1]
            end
            return tostring(selected)
        end

        local function applyWorldTexture()
            if not worldTextureToggle or not worldTextureToggle.value then
                return
            end

            local selected = getSelectedWorldTexture()
            local url = WORLD_TEXTURES[selected] or WORLD_TEXTURES.Minecraft

            -- Download/load once BEFORE touching the map. This removes most of the visible delay.
            local asset = getWorldTexture(url)

            findWorldTextureTargets()

            for obj, property in pairs(worldTextureTargets) do
                if obj and obj.Parent then
                    pcall(function()
                        -- Clear the old texture first, then assign the newly selected texture.
                        obj[property] = ""
                        obj[property] = asset
                    end)
                end
            end
        end

        local function switchWorldTexture()
            if not worldTextureToggle or not worldTextureToggle.value then
                return
            end

            -- 1. Remove the currently applied texture and restore the original.
            restoreWorldTextures()
            clearWorldTextureTracking()

            -- 2. Load/apply the newly selected texture.
            applyWorldTexture()
        end

        if worldTextureToggle and worldTextureToggle.changed then
            worldTextureToggle.changed:Connect(function()
                if worldTextureToggle.value then
                    applyWorldTexture()
                else
                    restoreWorldTextures()
                    clearWorldTextureTracking()
                end
            end)
        end

        if worldTextureDropdown and worldTextureDropdown.changed then
            worldTextureDropdown.changed:Connect(function()
                if worldTextureToggle and worldTextureToggle.value then
                    switchWorldTexture()
                end
            end)
        end

        game.DescendantAdded:Connect(function(obj)
            if not worldTextureToggle or not worldTextureToggle.value then
                return
            end

            task.defer(function()
                local property = getWorldTextureProperty(obj)
                if not property then
                    return
                end

                local success, value = pcall(function()
                    return obj[property]
                end)

                if not success or type(value) ~= "string" then
                    return
                end

                if getWorldTextureId(value) == WORLD_TEXTURE_ID then
                    if worldTextureOriginals[obj] == nil then
                        rememberWorldTextureTarget(obj, property, value)
                    end

                    local selected = getSelectedWorldTexture()
                    local url = WORLD_TEXTURES[selected] or WORLD_TEXTURES.Minecraft
                    local asset = getWorldTexture(url)

                    pcall(function()
                        obj[property] = ""
                        obj[property] = asset
                    end)
                end
            end)
        end)

        local nameBox = base.features["settings/config/name"]
        local createButton = base.features["settings/config/create"]
        local loadButton = base.features["settings/config/load"]
        local saveButton = base.features["settings/config/save"]
        local deleteButton = base.features["settings/config/delete"]
        local autoSaveToggle = base.features["settings/config/auto_save"]
        local configList = base.features["settings/config/list"]

        local selectedConfig = "default.json"
        local knownConfigs = {}

        -- Normalize names so "KK" becomes "KK.json" exactly once.
        local function configName(name)
            name = tostring(name or "")
            name = name:gsub("%.json$", "")
            name = name:gsub("[^%w%._%-]", "")
            name = name:gsub("%.json$", "")
            if name == "" then name = "default" end
            return name .. ".json"
        end

        local function configPath(name)
            return CONFIG_DIR .. configName(name)
        end

        local function addConfigToList(filename)
            filename = configName(filename)
            if knownConfigs[filename] then return end
            knownConfigs[filename] = true
            if configList and configList.add then
                pcall(function() configList:add(filename) end)
            end
        end

        local function getSelectedConfig()
            local value = configList and configList.value
            if type(value) == "table" then value = value[1] end
            if value and tostring(value) ~= "" then return configName(value) end
            return selectedConfig
        end

        local function saveConfig(name)
            if not writefile then return false end
            local filename = configName(name)
            local ok = pcall(function()
                writefile(configPath(filename), base:encodeJSON())
            end)
            if ok then
                selectedConfig = filename
                addConfigToList(filename)
            end
            return ok
        end

        local function loadConfig(name)
            if not readfile or not isfile then return false end
            local filename = configName(name)
            local path = configPath(filename)
            if not isfile(path) then return false end
            local ok = pcall(function()
                base:decodeJSON(readfile(path))
            end)
            if ok then
                selectedConfig = filename
                addConfigToList(filename)
            end
            return ok
        end

        -- Load existing .json configs into the list on startup.
        addConfigToList("default.json")
        if listfiles then
            pcall(function()
                for _, path in ipairs(listfiles(CONFIG_DIR)) do
                    local filename = tostring(path):match("([^/\\]+)$")
                    if filename and filename:match("%.json$") then
                        addConfigToList(filename)
                    end
                end
            end)
        end

        createButton.changed:Connect(function()
            local rawName = tostring(nameBox.value or ""):gsub("^%s+", ""):gsub("%s+$", "")
            if rawName == "" then return end
            saveConfig(configName(rawName))
        end)

        saveButton.changed:Connect(function()
            local rawName = tostring(nameBox.value or ""):gsub("^%s+", ""):gsub("%s+$", "")
            saveConfig(rawName ~= "" and rawName or selectedConfig)
        end)

        loadButton.changed:Connect(function()
            loadConfig(getSelectedConfig())
        end)

        deleteButton.changed:Connect(function()
            -- Always keep at least one config in the list.
            local configCount = 0
            for _ in pairs(knownConfigs) do
                configCount += 1
            end

            if configCount <= 1 then
                return
            end

            local filename = getSelectedConfig()
            if delfile and isfile and isfile(configPath(filename)) then
                pcall(delfile, configPath(filename))
            end
            if configList and configList.remove then
                pcall(function() configList:remove(filename) end)
            end
            knownConfigs[filename] = nil
            if selectedConfig == filename then
                selectedConfig = "default.json"
            end
        end)

        for flag, feature in next, base.features do
            if flag ~= "settings/config/auto_save"
                and feature.changed
                and feature.changed.Connect then
                feature.changed:Connect(function()
                    if autoSaveToggle.value then
                        saveConfig(selectedConfig)
                    end
                end)
            end
        end
    end

    -- Live Settings: default text size 16, original blue accent.
    local originalAccent = Color3.fromRGB(55, 175, 225)
    local currentAccent = originalAccent

    local function applyMenuSettings()
        local accentFeature = base.features["settings/menu/accent"]
        local sizeFeature = base.features["settings/menu/text_size"]
        local accent = originalAccent
        if accentFeature and accentFeature.value and accentFeature.value.rgb then
            accent = accentFeature.value.rgb
        end
        local textSize = math.clamp(tonumber(sizeFeature and sizeFeature.value) or 16, 1, 26)
        local gui = base.instances.gui
        if not gui then return end

        local objects = {gui}
        for _, obj in ipairs(gui:GetDescendants()) do
            table.insert(objects, obj)
        end
        for _, obj in ipairs(objects) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                obj.TextSize = textSize
                if obj.TextColor3 == currentAccent or obj.TextColor3 == originalAccent then
                    obj.TextColor3 = accent
                end
            elseif obj:IsA("Frame") then
                if obj.BackgroundColor3 == currentAccent or obj.BackgroundColor3 == originalAccent then
                    obj.BackgroundColor3 = accent
                end
            elseif obj:IsA("ScrollingFrame") then
                if obj.ScrollBarImageColor3 == currentAccent or obj.ScrollBarImageColor3 == originalAccent then
                    obj.ScrollBarImageColor3 = accent
                end
            end
        end
        currentAccent = accent
    end

    if base.features["settings/menu/accent"] then
        base.features["settings/menu/accent"].changed:Connect(applyMenuSettings)
    end
    if base.features["settings/menu/text_size"] then
        base.features["settings/menu/text_size"].changed:Connect(applyMenuSettings)
    end
    task.defer(applyMenuSettings)


    -- ═══════════════════════════════════════════════════
    -- HUD runtime (based on the supplied Hud file)
    -- ═══════════════════════════════════════════════════
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LocalPlayer = Players.LocalPlayer

    local function getFeature(name)
        return base.features and base.features[name] or nil
    end

    local function getValue(name, fallback)
        local feature = getFeature(name)
        if not feature then return fallback end
        local value = feature.value
        if value == nil then return fallback end
        return value
    end

    local function safeDrawing(kind)
        if not Drawing or type(Drawing.new) ~= "function" then return nil end
        local ok, object = pcall(Drawing.new, kind)
        if ok then return object end
        return nil
    end

    local crosshairDrawings = {}
    for i = 1, 4 do
        local line = safeDrawing("Line")
        local outline = safeDrawing("Line")
        if line then
            line.Thickness = 1
            line.Visible = false
        end
        if outline then
            outline.Thickness = 3
            outline.Color = Color3.new(0,0,0)
            outline.Visible = false
        end
        crosshairDrawings[i] = {line, outline}
    end

    local function hideCrosshair()
        for _, pair in ipairs(crosshairDrawings) do
            if pair[1] then pair[1].Visible = false end
            if pair[2] then pair[2].Visible = false end
        end
    end

    local function getCrosshairLocation()
        local mode = getValue("drawing_crosshair_location", "Mouse")
        local camera = workspace.CurrentCamera
        if not camera then return nil end
        if mode == "Center" then
            return camera.ViewportSize / 2
        elseif mode == "Target" then
            local ok, target = pcall(function() return aimbot.target end)
            if ok and target and player_data and player_data[target] then
                local parts = player_data[target].character_parts
                local hrp = parts and parts.HumanoidRootPart
                if hrp then
                    local pos, visible = camera:WorldToViewportPoint(hrp.Position)
                    if visible then return Vector2.new(pos.X, pos.Y) end
                end
            end
        end
        local mouse = UserInputService:GetMouseLocation()
        return Vector2.new(mouse.X, mouse.Y)
    end

    local spinAngle = 0
    local crosshairConnection
    crosshairConnection = RunService.RenderStepped:Connect(function(dt)
        local ok = pcall(function()
            local toggle = getFeature("hud/crosshair")
            if not toggle or not toggle.value or not Drawing then
                hideCrosshair()
                return
            end

            local location = getCrosshairLocation()
            if not location then hideCrosshair() return end

            local length = getValue("drawing_crosshair_length", 5) * 5
            local gap = getValue("drawing_crosshair_gap", 5)
            local spinning = getValue("drawing_crosshair_spin", false)
            local speed = getValue("drawing_crosshair_speed", 5)
            spinAngle = spinning and (spinAngle + math.rad((speed * 5) * dt)) or 0

            local colorFeature = getFeature("hud/crosshair_color")
            local customColor = colorFeature and colorFeature.value and colorFeature.value.rgb or Color3.new(1,1,1)
            local angles = {0.0, math.pi/2, math.pi, math.pi*1.5}
            local rainbowTime = os.clock() * math.max(0.1, speed * 0.45)

            for i = 1, 4 do
                local line, outline = crosshairDrawings[i][1], crosshairDrawings[i][2]
                if line and outline then
                    local dir = Vector2.new(math.cos(spinAngle + angles[i]), math.sin(spinAngle + angles[i]))
                    line.From = location + dir * gap
                    line.To = line.From + dir * length
                    line.Color = Color3.fromHSV((rainbowTime + (i - 1) * 0.25) % 1, 1, 1)
                    outline.From = location + dir * math.max(0, gap - 1)
                    outline.To = outline.From + dir * (length + 1)
                    line.Visible = true
                    outline.Visible = true
                end
            end
        end)
        if not ok then hideCrosshair() end
    end)

    -- Target-info panel from the supplied HUD source.
    local targetInfoDrawings = {}
    if Drawing then
        local function newText()
            local d = safeDrawing("Text")
            if d then
                d.Size, d.Font, d.Outline = 16, 2, true
                d.Visible = false
            end
            return d
        end
        local bg = safeDrawing("Square")
        local title, targetText, healthText, armorText, gunText = newText(), newText(), newText(), newText(), newText()
        if bg and title and targetText and healthText and armorText and gunText then
            bg.Filled, bg.Visible = true, false
            bg.Size = Vector2.new(240, 100)
            bg.Color = Color3.fromRGB(12,12,12)
            title.Text, targetText.Text = "target info", "no one"
            healthText.Text, armorText.Text = "100/100", "100/130"
            gunText.Text = ""
            title.Center = true
            targetInfoDrawings = {bg,title,targetText,healthText,armorText,gunText}
        else
            for _, d in ipairs({bg,title,targetText,healthText,armorText,gunText}) do
                if d and d.Remove then pcall(function() d:Remove() end) end
            end
        end
    end

    local function hideTargetInfo()
        for _, d in ipairs(targetInfoDrawings) do d.Visible = false end
    end

    local function updateTargetInfo()
        local toggle = getFeature("hud/target_info")
        if not toggle or not toggle.value or #targetInfoDrawings == 0 then
            hideTargetInfo()
            return
        end
        local camera = workspace.CurrentCamera
        local target
        pcall(function() target = aimbot.target end)
        if not target or not player_data or not player_data[target] then
            hideTargetInfo()
            return
        end
        local parts = player_data[target].character_parts
        local hrp = parts and parts.HumanoidRootPart
        local hum = parts and parts.Humanoid
        if not hrp then hideTargetInfo() return end
        local pos, visible = camera:WorldToViewportPoint(hrp.Position)
        if not visible then hideTargetInfo() return end

        local basePos = Vector2.new(pos.X + 20, pos.Y + 20)
        local box = targetInfoDrawings[1]
        box.Position = basePos
        box.Visible = true

        local name = typeof(target) == "Instance" and target.Name or tostring(target)
        targetInfoDrawings[2].Position = basePos + Vector2.new(120,10)
        targetInfoDrawings[2].Text = "target info"
        targetInfoDrawings[2].Center = true
        targetInfoDrawings[2].Visible = true
        targetInfoDrawings[3].Position = basePos + Vector2.new(12,38)
        targetInfoDrawings[3].Text = name
        targetInfoDrawings[3].Visible = true
        targetInfoDrawings[4].Position = basePos + Vector2.new(12,56)
        targetInfoDrawings[4].Text = "health"
        targetInfoDrawings[4].Visible = true
        targetInfoDrawings[5].Position = basePos + Vector2.new(12,74)
        targetInfoDrawings[5].Text = "armor"
        targetInfoDrawings[5].Visible = true
        targetInfoDrawings[6].Position = basePos + Vector2.new(12,92)
        targetInfoDrawings[6].Text = hum and (math.floor(hum.Health).."/"..math.floor(hum.MaxHealth)) or ""
        targetInfoDrawings[6].Visible = true
    end

    -- Watermark: editable text, based on the supplied HUD behavior.
    local watermarkDrawings = {}
    if Drawing then
        local text = safeDrawing("Text")
        if text then
            text.Text = "mihno.win"
            text.Size = 14
            text.Font = 2
            text.Color = Color3.fromRGB(226,226,226)
            text.Outline = true
            text.Center = true
            text.Visible = false
            watermarkDrawings = {text}
        end
    end

    local function updateWatermark()
        local toggle = getFeature("hud/watermark")
        local drawing = watermarkDrawings[1]
        if not toggle or not toggle.value or not drawing then
            if drawing then drawing.Visible = false end
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then drawing.Visible = false return end

        local location = getValue("watermark_location", "Center")
        local pos = camera.ViewportSize / 2
        if location == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            pos = Vector2.new(m.X, m.Y)
        elseif location == "Target" then
            local ok, target = pcall(function() return aimbot.target end)
            if ok and target and player_data and player_data[target] then
                local parts = player_data[target].character_parts
                local hrp = parts and parts.HumanoidRootPart
                if hrp then
                    local p2, on = camera:WorldToViewportPoint(hrp.Position)
                    if on then pos = Vector2.new(p2.X, p2.Y) end
                end
            end
        end

        pos += Vector2.new(getValue("watermark_x_offset", 0), getValue("watermark_y_offset", 0))
        local customText = getValue("watermark_text", "mihno.win")
        customText = tostring(customText or "mihno.win")
        if customText == "" then customText = "mihno.win" end
        drawing.Text = customText
        drawing.Position = pos
        drawing.Visible = true
    end

    RunService.RenderStepped:Connect(function()
        pcall(updateTargetInfo)
        pcall(updateWatermark)
    end)

    -- ═══════════════════════════════════════════════════
    -- Player ESP (fields and object layout based on supplied file)
    -- ═══════════════════════════════════════════════════
    local espObjects = {}

    local function espColor(name, fallback)
        local f = getFeature(name)
        return f and f.value and f.value.rgb or fallback
    end

    local function createESPObjects(player)
        if player == LocalPlayer or not Drawing then return nil end
        local box = safeDrawing("Square")
        local fill = safeDrawing("Square")
        local name = safeDrawing("Text")
        local health = safeDrawing("Line")
        if not (box and fill and name and health) then
            for _, d in ipairs({box, fill, name, health}) do
                if d and d.Remove then pcall(function() d:Remove() end) end
            end
            return nil
        end
        local highlight
        pcall(function()
            highlight = Instance.new("Highlight")
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = false
            highlight.Parent = gethui and gethui() or game:GetService("CoreGui")
        end)
        return {box=box, fill=fill, name=name, health=health, highlight=highlight}
    end

    local function removeESP(player)
        local obj = espObjects[player]
        if not obj then return end
        for _, d in pairs(obj) do
            if typeof(d) == "Instance" then pcall(function() d:Destroy() end)
            elseif d and d.Remove then pcall(function() d:Remove() end) end
        end
        espObjects[player] = nil
    end

    local function updateESP()
        local enabled = getFeature("esp/enabled")
        if not enabled or not enabled.value then
            for _, obj in pairs(espObjects) do
                obj.box.Visible, obj.fill.Visible, obj.name.Visible, obj.health.Visible = false,false,false,false
                if obj.highlight then obj.highlight.Enabled = false end
            end
            return
        end

        local camera = workspace.CurrentCamera
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                local hum = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if character and hum and root and hum.Health > 0 then
                    local obj = espObjects[player] or createESPObjects(player)
                    espObjects[player] = obj
                    if obj then
                        local cf, size = character:GetBoundingBox()
                        local corners = {}
                        for _, sx in ipairs({-1,1}) do
                            for _, sy in ipairs({-1,1}) do
                                for _, sz in ipairs({-1,1}) do
                                    local wp = (cf * CFrame.new(size.X*sx/2,size.Y*sy/2,size.Z*sz/2)).Position
                                    local sp, on = camera:WorldToViewportPoint(wp)
                                    if on then table.insert(corners, Vector2.new(sp.X,sp.Y)) end
                                end
                            end
                        end
                        if #corners > 0 then
                            local minX,maxX,minY,maxY = corners[1].X,corners[1].X,corners[1].Y,corners[1].Y
                            for _, v in ipairs(corners) do minX,maxX = math.min(minX,v.X),math.max(maxX,v.X); minY,maxY = math.min(minY,v.Y),math.max(maxY,v.Y) end
                            local size2 = Vector2.new(maxX-minX,maxY-minY)
                            local boxColor = espColor("esp/box_color",Color3.new(1,1,1))
                            local fillColor = espColor("esp/box_fill_color",Color3.new(1,1,1))
                            local nameColor = espColor("esp/name_color",Color3.new(1,1,1))
                            local healthColor = espColor("esp/health_color",Color3.fromRGB(153,196,39))

                            local boxOn = getValue("esp/box", false)
                            obj.box.Position, obj.box.Size = Vector2.new(minX,minY), size2
                            obj.box.Color, obj.box.Thickness, obj.box.Visible = boxColor,1,boxOn

                            local fillOn = getValue("esp/box_fill", false)
                            obj.fill.Position, obj.fill.Size = Vector2.new(minX,minY), size2
                            obj.fill.Color = fillColor
                            obj.fill.Transparency = getValue("esp/fill_transparency", 0.75)
                            obj.fill.Filled, obj.fill.Visible = true,fillOn

                            local nameOn = getValue("esp/name", false)
                            obj.name.Text = (getValue("esp/display_name", false) and player.DisplayName or player.Name)
                            obj.name.Size = getValue("esp/name_size", 14)
                            obj.name.Color = nameColor
                            obj.name.Center, obj.name.Outline = true,true
                            obj.name.Position, obj.name.Visible = Vector2.new((minX+maxX)/2,minY-16),nameOn

                            local healthOn = getValue("esp/health", false)
                            local ratio = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
                            obj.health.From = Vector2.new(minX-5,maxY)
                            obj.health.To = Vector2.new(minX-5,maxY-(maxY-minY)*ratio)
                            obj.health.Color, obj.health.Thickness, obj.health.Visible = healthColor,2,healthOn

                            if obj.highlight then
                                obj.highlight.Adornee = character
                                obj.highlight.FillColor = espColor("esp/highlight_color",Color3.fromRGB(153,196,39))
                                obj.highlight.FillTransparency = 0.5
                                obj.highlight.OutlineColor = boxColor
                                obj.highlight.Enabled = getValue("esp/highlight", false)
                            end
                        end
                    end
                else
                    if espObjects[player] then
                        espObjects[player].box.Visible,espObjects[player].fill.Visible,espObjects[player].name.Visible,espObjects[player].health.Visible=false,false,false,false
                        if espObjects[player].highlight then espObjects[player].highlight.Enabled=false end
                    end
                end
            end
        end
    end

    RunService.RenderStepped:Connect(function()
        pcall(updateESP)
    end)
    Players.PlayerRemoving:Connect(removeESP)

    base:Finish()
    local unload = base.features["settings/menu/unload"]
    if unload then
        unload.changed:Connect(function()
            if base.instances.gui then
                base.instances.gui:Destroy()
            end
            base.visible = false
        end)
    end
end
