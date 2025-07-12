#!/bin/bash

# Default file name if none is provided
DEFAULT_FILE="single_register_mov.asm"

# Use first argument as filename or fallback to default
ASM_FILE="${1:-$DEFAULT_FILE}"

# Extract base name (remove .asm extension)
BASENAME=$(basename "$ASM_FILE" .asm)

# Output file name
OUTPUT_FILE="${BASENAME}"

# Compile using NASM
echo "Compiling '$ASM_FILE' to '$OUTPUT_FILE'..."
nasm -f bin "$ASM_FILE" -o "$(dirname "$0")/$OUTPUT_FILE"

# Check if compilation succeeded
if [ $? -eq 0 ]; then
    echo "✅ Compilation successful: $OUTPUT_FILE"
else
    echo "❌ Compilation failed."
fi


# Disasseble the output file
ndisasm -b 16 "$OUTPUT_FILE"
