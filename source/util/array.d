module util.array;

import util.bitop;
import util.endian;
import util.number;

private enum Endianness {
    BIG,
    LITTLE
}

pragma(inline, true)
private T read(T)(u8* buf, size_t address) {
    return (cast(T*) buf)[address >> get_shift!T];
}

pragma(inline, true)
private T write(T)(u8* buf, size_t address, T value) {
    (cast(T*) buf)[address >> get_shift!T] = value;
}

pragma(inline, true)
private T read_with_endianness(Endianness endianness, T)(u8* buf, size_t address) {
    static assert(is_number!T);

    T value = buf.read!T(address);

    version (BigEndian) {
        if (endianness == Endianness.LITTLE) {
            value = bswap(value);
        }
    }

    version (LittleEndian) {
        if (endianness == Endianness.BIG) {
            value = bswap(value);
        }
    }
    
    return value;
}

pragma(inline, true)
private void write_with_endianness(Endianness endianness, T)(u8* buf, size_t address, T value) {
    static assert(is_number!T);

    version (BigEndian) {
        if (endianness = Endianness.LITTLE) {
            value = bswap(value);
        }
    }

    version (LittleEndian) {
        if (endianness = Endianness.BIG) {
            value = bswap(value);
        }
    }
    
    buf.write(address, value);
}

public T read_be(T)(u8* buf, size_t address) {
    return buf.read_with_endianness!(Endianness.BIG, T)(address);
}

public T read_le(T)(u8* buf, size_t address) {
    return buf.read_with_endianness!(Endianness.LITTLE, T)(address);
}

public T write_be(T)(u8* buf, size_t address) {
    return buf.write_with_endianness!(Endianness.BIG, T)(address);
}

public T write_le(T)(u8* buf, size_t address) {
    return buf.write_with_endianness!(Endianness.LITTLE, T)(address);
}

public T read_be(T)(u8[] buf, size_t address) {
    return buf.ptr.read_with_endianness!(Endianness.BIG, T)(address);
}

public T read_le(T)(u8[] buf, size_t address) {
    return buf.ptr.read_with_endianness!(Endianness.LITTLE, T)(address);
}

public T write_be(T)(u8[] buf, size_t address) {
    return buf.ptr.write_with_endianness!(Endianness.BIG, T)(address);
}

public T write_le(T)(u8[] buf, size_t address) {
    return buf.ptr.write_with_endianness!(Endianness.LITTLE, T)(address);
}

private auto get_shift(T)() {
    assert(is_unsigned_number!T);

    static if (is(T == u64)) return 3;
    static if (is(T == u32)) return 2;
    static if (is(T == u16)) return 1;
    static if (is(T == u8))  return 0;
}