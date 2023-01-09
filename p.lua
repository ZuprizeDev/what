local AspectRemoteHooking = {}

local ReturnTable = {["RemoteName"] = "RemoteName"}

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

function HandleHookedInfo(...)
	spawn(function()
        coroutine.resume(coroutine.create(function()
            spawn(function()
				local args = {...}

				for i,v in pairs(args) do
					if i == 1 then
						ReturnTable.RemoteName = v
					else
						table.insert(ReturnTable, v)
					end
				end
			
				return ReturnTable
			end)
		end))
	end)
end

function AspectRemoteHooking:GetReturnTable()
	local OldTable = ReturnTable
	local NewTable = {["RemoteName"] = "RemoteName"}
	ReturnTable = NewTable

	return OldTable
end

function AspectRemoteHooking:hookInvoke(RemoteName, WhatToHook)
    local a
    a = hookfunction(WhatToHook, function(...)
		if _G.Invoke == _G.OldInvoke then
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookFire(RemoteName, WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.Remote == _G.OldRemote then
			
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookAllInvokes(WhatToHook)
	local a
    a = hookfunction(WhatToHook, function(...)
		if _G.AllInvoke == _G.OldAllInvoke then
			
			return a(...)
		else
			return a(...)
		end
    end)
end

function AspectRemoteHooking:hookAllFires(WhatToHook)
    local a
    a = hookfunction(WhatToHook, function(...)
		if _G.AllRemote == _G.OldAllRemote then
			
			return a(...)
		else
			return a(...)
		end
    end)
end

return AspectRemoteHooking
