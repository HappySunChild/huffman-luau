local tree_types = require("./types")

local function traverse_tree<Symbol>(
	tree_root: tree_types.HuffmanTreeNode<Symbol>,
	code: number,
	code_width: number
): (Symbol, number)
	local bit_count = code_width
	local current_node = tree_root

	while current_node.symbol == nil do
		bit_count -= 1
		current_node = if bit32.btest(code, bit32.lshift(1, bit_count)) then current_node.right else current_node.left
	end

	return current_node.symbol, code_width - bit_count
end

return traverse_tree
