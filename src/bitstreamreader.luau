local function bitstreamreader(data: buffer)
	local read_bit_offset = 0
	local read_byte_offset = 0

	local function peek(amount_bits: number)
		assert(amount_bits <= 32, "Can't read more than 32 bits at once.")

		local total_bit_offset = read_byte_offset * 8 + read_bit_offset
		local byte_use_count = 1 + (total_bit_offset + amount_bits) // 8 - total_bit_offset // 8

		local read_value = 0

		for byte_offset = 0, byte_use_count - 1 do
			local byte_value = buffer.readu8(data, read_byte_offset + byte_offset)
			read_value = bit32.bor(bit32.lshift(read_value, 8), byte_value)
		end

		local field = byte_use_count * 8 - (read_bit_offset + amount_bits)

		return bit32.extract(read_value, field, amount_bits)
	end

	local function shift(amount_bits: number)
		read_bit_offset += amount_bits

		if read_bit_offset >= 8 then
			read_byte_offset += read_bit_offset // 8
			read_bit_offset %= 8
		end

		return read_byte_offset, read_bit_offset
	end

	return peek, shift
end

return bitstreamreader
