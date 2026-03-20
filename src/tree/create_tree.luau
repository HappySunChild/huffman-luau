local tree_types = require("./types")

local function pqinsert(queue: { tree_types.HuffmanTreeNode }, node: tree_types.HuffmanTreeNode)
	local node_freq = node.freq

	for index, other in queue do
		if node_freq > other.freq then
			table.insert(queue, index, node)
			return
		end
	end

	table.insert(queue, node)
end

local function create_tree<Symbol>(frequencies: { [Symbol]: number }): tree_types.HuffmanTreeNode<Symbol>
	local queue: { tree_types.HuffmanTreeNode<Symbol> } = {}

	for symbol, freq in frequencies do
		pqinsert(queue, { freq = freq, symbol = symbol })
	end

	assert(#queue > 0, "Not enough frequency data to construct a huffman tree.")

	while #queue > 1 do
		local left, right = table.remove(queue), table.remove(queue)
		pqinsert(queue, { freq = left.freq + right.freq, left = left, right = right })
	end

	return queue[1]
end

return create_tree
