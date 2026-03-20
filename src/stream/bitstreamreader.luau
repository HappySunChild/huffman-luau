local function bitstreamreader(stream: buffer)
	local read_bit_cursor = 0

	local function peek(amount_bits: number): number
		assert(amount_bits <= 32, "Can't read more than 32 bits at once.")

		local byte_use_count = 1 + (read_bit_cursor + amount_bits - 1) // 8 - read_bit_cursor // 8
		local read_value = 0

		for byte_offset = 0, byte_use_count - 1 do
			local byte_value = buffer.readu8(stream, read_bit_cursor // 8 + byte_offset)
			read_value = bit32.bor(bit32.lshift(read_value, 8), byte_value)
		end

		local field = byte_use_count * 8 - (read_bit_cursor % 8 + amount_bits)

		return bit32.extract(read_value, field, amount_bits)
	end

	local function shift(amount_bits: number): number
		read_bit_cursor += amount_bits

		return read_bit_cursor
	end

	return peek, shift
end

return bitstreamreader
