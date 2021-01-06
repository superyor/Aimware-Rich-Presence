with open("easyrp.exe", "rb+") as fh:
    data = fh.read()
    offset = data.find(b"\x69\x6e\x69")
    fh.seek(offset)
    fh.write(b"\x74\x78\x74")
    print('Patched!')