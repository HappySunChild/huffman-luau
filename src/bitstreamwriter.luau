local function bitstreamwriter(data: buffer)
	local write_bit_offset = 0
	local write_byte_offset = 0
	local write_register = 0

	local function flush()
		if write_register == 0 then
			return
		end

		buffer.writeu8(data, write_byte_offset, write_register)

		write_register = 0
	end

	local function append(value: number, width: number)
		local shift_by = 8 - width - write_bit_offset
		local shifted_value = bit32.lshift(value, shift_by)
		write_register = bit32.bor(write_register, shifted_value)
		write_bit_offset += width

		if write_bit_offset >= 8 then
			flush()

			write_byte_offset += 1
			write_bit_offset = 0

			-- nondescript check
			-- if we've shifted right (negative) at all that means that information has been lost and needs to be appended separately
			-- otherwise we can exit early
			if shift_by >= 0 then
				return
			end

			local new_width = -shift_by
			local new_value = bit32.extract(value, 0, new_width)

			append(new_value, new_width)
		end
	end

	return append, flush
end

return bitstreamwriter
