local huffman = require("../src/huffman")
local bitstreamwriter = require("../src/bitstreamwriter")
local bitstreamreader = require("../src/bitstreamreader")

local function analyze_text(text: string): ({ [string]: number }, { string })
	local frequencies = {}
	local character_array = {}

	for char in string.gmatch(text, ".") do
		frequencies[char] = (frequencies[char] or 0) + 1
		table.insert(character_array, char)
	end

	return frequencies, character_array
end

local sample_text =
	"Some text that contains the letter 't' a lot. Trinitrotoluene is a yellow, odorless solid explosive used in military bombs "
local frequencies, chars = analyze_text(sample_text)

local tree = huffman.create_tree(frequencies)
local symbol_mapping = huffman.get_mappings(tree)

local target = buffer.create(math.ceil(huffman.get_total_bit_count(symbol_mapping, chars) / 8))
local append, flush = bitstreamwriter(target)

for _, symbol in chars do
	local prefix_code = symbol_mapping[symbol]
	append(prefix_code.code, prefix_code.bit_count)
end
flush()

local reformed_data = {}
local peek, shift = bitstreamreader(target)

while true do
	local symbol, shift_by = huffman.traverse_tree(tree, peek(7), 7)
	table.insert(reformed_data, symbol)

	local byte_offset, bit_offset = shift(shift_by)

	if byte_offset + (bit_offset + 7) // 8 >= buffer.len(target) then
		break
	end
end

print(table.concat(reformed_data))
