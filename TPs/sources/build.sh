#!/bin/bash

# ----------------------------
# Simple ASM Build Script (x86, NASM)
# Supports multiple files
# ----------------------------

# Check at least one argument is given
if [ $# -lt 1 ]; then
    echo "Usage: $0 <source1.asm> [source2.asm ...]"
    exit 1
fi

# Determine directory of this script
SCRIPT_DIR=$(dirname "$(realpath "$0")")
LIB_ASM="$SCRIPT_DIR/lib.asm"

if [ ! -f "$LIB_ASM" ]; then
    echo "Error: lib.asm not found at $LIB_ASM"
    exit 1
fi

# Loop over all .asm files passed as arguments
for SRC in "$@"; do
    # Check source file exists
    if [ ! -f "$SRC" ]; then
        echo "Error: file '$SRC' does not exist."
        continue
    fi

    # Get basename and directory of source
    BASENAME=$(basename "$SRC" .asm)
    SRC_DIR=$(dirname "$SRC")
    OUT="$BASENAME"  # output name same as basename

    echo "[*] Assembling $SRC..."
    nasm -f elf "$SRC" -o "$SRC_DIR/$BASENAME.o" || { echo "Assembly failed for $SRC"; continue; }

    echo "[*] Assembling lib.asm..."
    nasm -f elf "$LIB_ASM" -o "$SRC_DIR/lib.o" || { echo "Assembly failed for lib.asm"; continue; }

    echo "[*] Linking..."
    ld -m elf_i386 "$SRC_DIR/$BASENAME.o" "$SRC_DIR/lib.o" -o "$SRC_DIR/$OUT" || { echo "Linking failed for $SRC"; continue; }

    # Cleanup object files
    rm "$SRC_DIR/$BASENAME.o" "$SRC_DIR/lib.o"

    echo "[+] Build complete. Executable: $SRC_DIR/$OUT"

    # Ask if user wants to run this executable
    read -p "Do you want to run $SRC_DIR/$OUT now? (y/n): " RESP
    if [[ "$RESP" =~ ^[yY]$ ]]; then
        echo "----- Program output -----"
        "$SRC_DIR/$OUT"
        echo "--------------------------"
    fi

done

