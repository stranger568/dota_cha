--调用方法 方法, 实例, 参数表
--debug.traceback 在Source引擎中需要参数的，所以会吞一个参数
--ErrorTracking.Try(HeroBuilder.Test,HeroBuilder,param)
--ErrorTracking.Try(function() end)


ErrorTracking = ErrorTracking or {}
ErrorTracking.collected_errors = ErrorTracking.collected_errors or ""

--重写debug.traceback
debug.oldTraceback = debug.oldTraceback or debug.traceback
debug.traceback = function(...)
	local stack = debug.oldTraceback(...)
	ErrorTracking.Collect(stack)
	return stack
end

function ErrorTracking.Collect(stack)
	stack = stack:gsub(": at 0x%x+", ": at 0x")
	--本机测试中打印错误
	if IsInToolsMode() then
		print(stack)
	end
	ErrorTracking.collected_errors = ErrorTracking.collected_errors.."\n"..stack
	ErrorTracking.collected_errors = ""
end

function ErrorTracking.Try(callback, ...)
	return xpcall(callback, debug.traceback, ...)
end