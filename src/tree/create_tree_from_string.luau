local create_tree = require("../tree/create_tree")

local function create_tree_from_string(str: string)
	local frequencies = {}

	for char in string.gmatch(str, ".") do
		frequencies[char] = (frequencies[char] or 0) + 1
	end

	return create_tree(frequencies)
end

return create_tree_from_string
