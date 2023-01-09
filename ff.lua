local AspectRemoteHooking = {}

_G.ReturnTable = {
	["HookAllFire"] = {},
	["HookAllInvoke"] = {},
	["HookSingalInvoke"] = {},
	["HookSingalFire"] = {}
}

--// Single Invokes Hooking Keys \\--
_G.Invoke = game:GetService("HttpService"):GenerateGUID(false)
_G.OldInvoke = _G.Invoke

--// Single Remotes Hooking Keys \\--
_G.Remote = game:GetService("HttpService"):GenerateGUID(false)
_G.OldRemote = _G.Remote

--// All Invokes Hooking Keys \\--
_G.AllInvoke = game:GetService("HttpService"):GenerateGUID(false)
_G.OldAllInvoke = _G.AllInvoke

--// All Remotes Hooking Keys \\--
_G.AllRemote = game:GetService("HttpService"):GenerateGUID(false)
_G.OldAllRemote = _G.AllRemote

function AspectRemoteHooking:GenerateNewInvokeKey()
    _G.OldInvoke = _G.Invoke
    _G.Invoke = game:GetService("HttpService"):GenerateGUID(false)
    return _G.Invoke
end

function AspectRemoteHooking:GenerateNewRemoteKey()
    _G.OldRemote = _G.Remote
    _G.Remote = game:GetService("HttpService"):GenerateGUID(false)
    return _G.Remote
end

function AspectRemoteHooking:GenerateNewAllInvokeKey()
    _G.OldAllInvoke = _G.AllInvoke
    _G.AllRemote = game:GetService("HttpService"):GenerateGUID(false)
    return _G.AllInvoke
end

function AspectRemoteHooking:GenerateNewAllRemoteKey()
    _G.OldAllRemote = _G.AllRemote
    _G.AllRemote = game:GetService("HttpService"):GenerateGUID(false)
    return _G.AllRemote
end

function HandleHookedInfo(hookData, tbl)
	spawn(function()
        coroutine.resume(coroutine.create(function()
            spawn(function()
				for i,v in pairs(hookData) do
					table.insert(tbl, v)
				end
				return tbl
			end)
		end))
	end)
end

function hookInvoke(tbl, WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.Invoke == _G.OldInvoke then
			task.wait(1)
			HandleHookedInfo({...}, tbl)
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookInvoke(RemoteName, WhatToHook)
	_G.ReturnTable["HookSingalInvoke"][_G.Invoke] = {}
	local tbl = _G.ReturnTable["HookSingalInvoke"][_G.Invoke]
    spawn(function()
		hookInvoke(tbl, WhatToHook)
	end)
	return tbl
end

function hookFire(tbl, WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.Remote == _G.OldRemote then
			task.wait(1)
			HandleHookedInfo({...}, tbl)
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookFire(RemoteName, WhatToHook)
	_G.ReturnTable["HookSingalFire"][_G.Remote] = {}
	local tbl = _G.ReturnTable["HookSingalFire"][_G.Remote]
	spawn(function()
		hookFire(tbl, WhatToHook)
	end)
	return tbl
end

function HookAllInvoke(tbl, WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.AllInvoke == _G.OldAllInvoke then
			task.wait(1)
			HandleHookedInfo({...}, tbl)
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookAllInvokes(WhatToHook)
	_G.ReturnTable["HookAllInvoke"][_G.AllInvoke] = {}
	local tbl = _G.ReturnTable["HookAllInvoke"][_G.AllInvoke]
    spawn(function()
		HookAllInvoke(tbl, WhatToHook)
	end)
	return tbl
end

function HookAllFire(tbl, WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.AllRemote == _G.OldAllRemote then
			task.wait(1)
			tbl = {}
			HandleHookedInfo({...}, tbl)
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookAllFires(WhatToHook)
	_G.ReturnTable["HookAllFire"][_G.AllRemote] = {}
	local tbl = _G.ReturnTable["HookAllFire"][_G.AllRemote]
    spawn(function()
		HookAllFire(tbl, WhatToHook)
	end)
	return tbl
end

return AspectRemoteHooking
