local M = {}

function M.str_lpad(str, len, char)
	if char == nil then
		char = ""
	end
	return string.rep(char, len - #str) .. str
end

function M.seconds2duration(seconds)
	seconds = seconds or 0
	local h = math.floor(seconds / 3600)
	local m = math.floor((seconds % 3600) / 60)
	local s = math.floor(seconds % 60)
	local out = M.str_lpad(tostring(m), 2, "0") .. ":" .. M.str_lpad(tostring(s), 2, "0")

	if h > 0 then
		out = tostring(h) .. ":" .. out
	end
	return out
end

function M.str_split(str, sep)
	if sep == "" then
		return { str }
	end

	local res, from = {}, 1
	repeat
		local pos = str:find(sep, from)
		res[#res + 1] = str:sub(from, pos and pos - 1)
		from = pos and pos + #sep
	until not from
	return res
end

function M.tbl_merge(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			t1[k] = merge(t1[k], t2[k])
		else
			t1[k] = v
		end
	end
	return t1
end

return M
