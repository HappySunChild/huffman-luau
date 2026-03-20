local tree_type = require("../tree/types")

local traverse_tree = require("../tree/traverse_tree")
local bitstreamreader = require("../stream/bitstreamreader")
local get_bit_width_range = require("../utility/get_bit_width_range")
local get_symbol_mappings = require("../utility/get_symbol_mappings")

local function decode_string(tree: tree_type.HuffmanTreeNode<string>, data: buffer): string
	local total_bits = buffer.len(data) * 8
	local remaining_bits = total_bits
	local min_width, max_width = get_bit_width_range(get_symbol_mappings(tree))

	local output_str = ""

	local peek, shift = bitstreamreader(data)

	while true do
		local bit_width = math.min(max_width, remaining_bits)

		local code = peek(bit_width)
		local char, bits_used = traverse_tree(tree, code, bit_width)
		output_str ..= char

		local current_bit_cursor = shift(bits_used)
		remaining_bits = total_bits - current_bit_cursor

		if remaining_bits < min_width then
			break
		end
	end

	return output_str
end

return decode_string
