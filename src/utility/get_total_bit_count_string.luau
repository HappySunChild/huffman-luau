local utility_types = require("./types")

local function get_total_bit_count(char_mappings: { [string]: utility_types.PrefixCode }, str: string): number
	local bit_count = 0

	for char in string.gmatch(str, ".") do
		local prefix = char_mappings[char]

		if prefix == nil then
			error(`Invalid character; {char}`)
		end

		bit_count += prefix.bit_count
	end

	return bit_count
end

return get_total_bit_count
