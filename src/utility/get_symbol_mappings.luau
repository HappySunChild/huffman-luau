local tree_types = require("../tree/types")
local utility_types = require("./types")

local function load_codes<Symbol>(
	node: tree_types.HuffmanTreeNode<Symbol>,
	output_symbol_mapping: { [Symbol]: utility_types.PrefixCode },
	partial: utility_types.PrefixCode
)
	if node.symbol ~= nil then
		output_symbol_mapping[node.symbol] = partial
	else
		local code, bit_count = partial.code, partial.bit_count
		load_codes(node.left, output_symbol_mapping, { code = code * 2, bit_count = bit_count + 1 })
		load_codes(node.right, output_symbol_mapping, { code = code * 2 + 1, bit_count = bit_count + 1 })
	end
end

local function get_symbol_mappings<Symbol>(tree: tree_types.HuffmanTreeNode<Symbol>): { [Symbol]: utility_types.PrefixCode }
	if tree.symbol ~= nil then
		return {
			[tree.symbol] = { code = 0, bit_count = 1 },
		}
	end

	local symbol_mapping = {}

	load_codes(tree, symbol_mapping, { code = 0, bit_count = 0 })

	return symbol_mapping
end

return get_symbol_mappings
