local utility_types = require("./types")

local function get_bit_width_range(symbol_mappings: { [any]: utility_types.PrefixCode }): (number, number)
	local min_width, max_width = math.huge, 0

	for _, prefix in symbol_mappings do
		local bit_count = prefix.bit_count

		if bit_count < min_width then
			min_width = bit_count
		end

		if bit_count > max_width then
			max_width = bit_count
		end
	end

	return min_width, max_width
end

return get_bit_width_range
