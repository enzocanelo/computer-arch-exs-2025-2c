#!/bin/bash

# ----------------------------
# Simple ASM Build Script (x86, NASM)
# ----------------------------

# Check at least one argument is given
if [ $# -lt 1 ]; then
    echo "Usage: $0 <source.asm> [output_name]"
    exit 1
fi

# Source file
SRC="$1"

# Check source file exists
if [ ! -f "$SRC" ]; then
    echo "Error: file '$SRC' does not exist."
    exit 1
fi

# Get basename for output
BASENAME=$(basename "$SRC" .asm)
OUT="${2:-$BASENAME}"  # default output name = basename

# Determine directory of this script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Path to lib.asm (always next to build.sh)
LIB_ASM="$SCRIPT_DIR/lib.asm"
if [ ! -f "$LIB_ASM" ]; then
    echo "Error: lib.asm not found at $LIB_ASM"
    exit 1
fi

# Assemble the source
echo "[*] Assembling $SRC..."
nasm -f elf "$SRC" -o "$BASENAME.o" || { echo "Assembly failed."; exit 1; }

# Assemble lib.asm
echo "[*] Assembling lib.asm..."
nasm -f elf "$LIB_ASM" -o "lib.o" || { echo "Assembly of lib.asm failed."; exit 1; }

# Link objects
echo "[*] Linking..."
ld -m elf_i386 "$BASENAME.o" "lib.o" -o "$OUT" || { echo "Linking failed."; exit 1; }

# Cleanup object files
rm "$BASENAME.o" "lib.o"

echo "[+] Build complete. Executable: $OUT"

# Ask if user wants to run the program
read -p "Do you want to run ./$OUT now? (y/n): " RESP
if [[ "$RESP" =~ ^[yY]$ ]]; then
    echo "----- Program output -----"
    ./"$OUT"
    echo "--------------------------"
fi

