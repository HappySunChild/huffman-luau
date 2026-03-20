local utility_types = require("./types")

local function get_total_bit_count<Symbol>(symbol_mappings: { [Symbol]: utility_types.PrefixCode }, data: { Symbol }): number
	local bit_count = 0

	for _, symbol in data do
		local prefix = symbol_mappings[symbol]

		if prefix == nil then
			error(`Invalid symbol; {symbol}`)
		end

		bit_count += prefix.bit_count
	end

	return bit_count
end

return get_total_bit_count
