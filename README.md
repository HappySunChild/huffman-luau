# huffman-luau
An implementation of huffman coding for Luau buffers.

## Example Usage
```luau
local huffman = require("../src")

local sample_text = "Hello world!"
local tree = huffman.create_tree_from_string(sample_text)

local encoded = huffman.encode_string(tree, sample_text)

local decoded = huffman.decode_string(tree, encoded)
```