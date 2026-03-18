export type HuffmanTreeNode<Symbol = any> = {
	frequency: number,
	symbol: Symbol,
	left: HuffmanTreeNode<Symbol>?,
	right: HuffmanTreeNode<Symbol>?,
}
export type PrefixCode = {
	code: number,
	bit_count: number,
}

local function node_pqinsert(queue: { HuffmanTreeNode }, node: HuffmanTreeNode)
	local node_freq = node.frequency

	for index, other in queue do
		if node_freq > other.frequency then
			table.insert(queue, index, node)

			return
		end
	end

	table.insert(queue, node)
end

local function create_node<Symbol>(
	frequency: number,
	symbol: Symbol?,
	left: HuffmanTreeNode<Symbol>?,
	right: HuffmanTreeNode<Symbol>?
): HuffmanTreeNode<Symbol>
	return {
		frequency = frequency,
		symbol = symbol,
		left = left,
		right = right,
	}
end

local function create_tree<Symbol>(frequencies: { [Symbol]: number }): HuffmanTreeNode<Symbol>
	local queue: { HuffmanTreeNode<Symbol> } = {}

	for symbol, frequency in frequencies do
		node_pqinsert(queue, create_node(frequency, symbol))
	end

	assert(#queue > 0, "Not enough frequency data to construct a tree!")

	while #queue > 1 do
		local left, right = table.remove(queue), table.remove(queue)
		node_pqinsert(queue, create_node(left.frequency + right.frequency, nil, left, right))
	end

	return queue[1]
end

local function load_codes<Symbol>(
	node: HuffmanTreeNode<Symbol>,
	output_symbol_mapping: { [Symbol]: PrefixCode },
	partial: PrefixCode
)
	if node.symbol then
		output_symbol_mapping[node.symbol] = partial
	else
		local code, bit_count = partial.code, partial.bit_count
		load_codes(node.left, output_symbol_mapping, { code = code * 2, bit_count = bit_count + 1 })
		load_codes(node.right, output_symbol_mapping, { code = code * 2 + 1, bit_count = bit_count + 1 }) -- + 2 ^ bit_count
	end
end

local function get_mappings<Symbol>(tree_root: HuffmanTreeNode<Symbol>): ({ [Symbol]: PrefixCode }, { [number]: Symbol })
	local symbol_mapping = {}
	local code_mapping = {}

	load_codes(tree_root, symbol_mapping, { code = 0, bit_count = 0 })

	for symbol, code: PrefixCode in symbol_mapping do
		code_mapping[symbol] = code.code
	end

	return symbol_mapping, code_mapping
end

local function get_total_bit_count<Symbol>(symbol_mapping: { [Symbol]: PrefixCode }, data: { Symbol }): number
	local bit_count = 0

	for _, symbol in data do
		local code = symbol_mapping[symbol]

		if code == nil then
			error(`Invalid symbol for prefix code; {symbol}`)
		end

		bit_count += code.bit_count
	end

	return bit_count
end

local function traverse_tree<Symbol>(tree_root: HuffmanTreeNode<Symbol>, code: number, code_width: number): (Symbol?, number)
	local bit_count = code_width
	local current_node = tree_root

	while current_node.symbol == nil do
		bit_count -= 1
		current_node = if bit32.btest(code, bit32.lshift(1, bit_count)) then current_node.right else current_node.left
	end

	return current_node.symbol, code_width - bit_count
end

return {
	get_mappings = get_mappings,
	get_total_bit_count = get_total_bit_count,

	create_tree = create_tree,
	traverse_tree = traverse_tree,
}
