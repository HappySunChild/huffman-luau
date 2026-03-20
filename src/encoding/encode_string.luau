local tree_types = require("../tree/types")

local bitstreamwriter = require("../stream/bitstreamwriter")
local get_symbol_mappings = require("../utility/get_symbol_mappings")
local get_total_bit_count_string = require("../utility/get_total_bit_count_string")

local function encode_string(tree: tree_types.HuffmanTreeNode<string>, str: string): buffer
	local char_mapping = get_symbol_mappings(tree)

	local output_buffer = buffer.create(math.ceil(get_total_bit_count_string(char_mapping, str) / 8))
	local append, flush = bitstreamwriter(output_buffer)

	for char in string.gmatch(str, ".") do
		local prefix = char_mapping[char]
		append(prefix.code, prefix.bit_count)
	end
	flush()

	return output_buffer
end

return encode_string
