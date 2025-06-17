def custom16_to_float(bits):
    # Extract sign, exponent, and mantissa
    sign = (bits >> 15) & 0x1
    exponent = (bits >> 10) & 0x1F  # 5 bits
    mantissa = bits & 0x3FF         # 10 bits

    bias = 15
    if exponent == 0 and mantissa == 0:
        return 0.0
    elif exponent == 0:
        # Denormalized number
        e = 1 - bias
        m = mantissa / (2 ** 10)
    else:
        # Normalized number
        e = exponent - bias
        m = 1 + mantissa / (2 ** 10)

    value = m * (2 ** e)
    if sign:
        value = -value
    return value

# Example usage
hex_inputs = [0x3E00, 0x4100, 0x4000, 0x4280, 0xBE00]  # 1.0, 2.0, 0.5, 3.25, -1.5

print(f"{'Hex':>6} | {'Float':>10}")
print("-" * 20)
for h in hex_inputs:
    print(f"0x{h:04X} | {custom16_to_float(h):>10.5f}")
