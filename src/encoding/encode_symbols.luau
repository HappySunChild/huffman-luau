local tree_types = require("../tree/types")

local bitstreamwriter = require("../stream/bitstreamwriter")
local get_symbol_mappings = require("../utility/get_symbol_mappings")
local get_total_bit_count = require("../utility/get_total_bit_count")

local function encode_symbols<Symbol>(tree: tree_types.HuffmanTreeNode<Symbol>, symbol_array: { Symbol }): buffer
	local symbol_mapping = get_symbol_mappings(tree)

	local output_buffer = buffer.create(math.ceil(get_total_bit_count(symbol_mapping, symbol_array) / 8))
	local append, flush = bitstreamwriter(output_buffer)

	for _, symbol in symbol_array do
		local prefix = symbol_mapping[symbol]
		append(prefix.code, prefix.bit_count)
	end
	flush()

	return output_buffer
end

return encode_symbols
