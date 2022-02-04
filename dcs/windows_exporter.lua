local start_time = nil
local fps_counter = 0
local file_path = "C:/Users/XXXXX/Saved Games/windows_exporter/textfile_inputs/dcs.prom"

local upstreamLuaExportStart = LuaExportStart
local upstreamLuaExportStop = LuaExportStop
local upstreamLuaExportAfterNextFrame = LuaExportAfterNextFrame
local upstreamLuaExportBeforeNextFrame = LuaExportBeforeNextFrame

function table_print (tt, indent, done)
  done = done or {}
  indent = indent or 0
  if type(tt) == "table" then
    local sb = {}
    for key, value in pairs (tt) do
      table.insert(sb, string.rep (" ", indent)) -- indent it
      if type (value) == "table" and not done [value] then
        done [value] = true
        table.insert(sb, key .. " = {\n");
        table.insert(sb, table_print (value, indent + 2, done))
        table.insert(sb, string.rep (" ", indent)) -- indent it
        table.insert(sb, "}\n");
      elseif "number" == type(key) then
        table.insert(sb, string.format("\"%s\"\n", tostring(value)))
      else
        table.insert(sb, string.format(
            "%s = \"%s\"\n", tostring (key), tostring(value)))
       end
    end
    return table.concat(sb)
  else
    return tt .. "\n"
  end
end

function to_string( tbl )
    if  "nil"       == type( tbl ) then
        return tostring(nil)
    elseif  "table" == type( tbl ) then
        return table_print(tbl)
    elseif  "string" == type( tbl ) then
        return tbl
    else
        return tostring(tbl)
    end
end

function LuaExportStart()
	-- call the upstream
	if upstreamLuaExportStart ~= nil then
			successful, err = pcall(upstreamLuaExportStart)
			if not successful then
					log.write("WIN_EXP", log.ERROR, "Error in upstream LuaExportStart function"..tostring(err))
			end
	end
	start_time = LoGetModelTime()
end

function LuaExportStop()
	-- call the upstream
	if upstreamLuaExportStop ~= nil then
			successful, err = pcall(upstreamLuaExportStop)
			if not successful then
					log.write("WIN_EXP", log.ERROR, "Error in upstream LuaExportStop function"..tostring(err))
			end
	end
	export_file = io.open(file_path, "w")
	export_file:write("# HELP dcs_fps DCS frames per second\n")
	export_file:write("# TYPE dcs_fps gauge\n")
	export_file:write(string.format("dcs_fps %.2f\n", 0 ))
	export_file:close()
end

function LuaExportBeforeNextFrame()
	if upstreamLuaExportBeforeNextFrame ~= nil then
			successful, err = pcall(upstreamLuaExportBeforeNextFrame)
			if not successful then
				 log.write("WIN_EXP", log.ERROR, "Error in upstream LuaExportBeforeNextFrame function"..tostring(err))
			end
	end
end

function LuaExportAfterNextFrame()
	if upstreamLuaExportAfterNextFrame ~= nil then
			successful, err = pcall(upstreamLuaExportAfterNextFrame)
			if not successful then
					log.write("WIN_EXP", log.ERROR, "Error in upstream LuaExportAfterNextFrame function"..tostring(err))
			end
	end
	local end_time = LoGetModelTime()
	fps_counter = fps_counter + 1
	local interval = end_time - start_time
	if interval >= 4.0 then
		export_file = io.open(file_path, "w")
		export_file:write("# HELP dcs_fps DCS frames per second\n")
		export_file:write("# TYPE dcs_fps gauge\n")
		export_file:write(string.format("dcs_fps %.2f\n", fps_counter / interval ))
		export_file:close()
		start_time = end_time
		fps_counter = 0
	end
end
