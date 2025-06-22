## Machine Instruction Encoding and Decoding 

Writing a MOV instruction in ASM-86 in the form:
```MOV destination, source```

will cause the assembler to generate 1 of 28 possible forms of the mov machine instruction.  A programmer rarely needs to know the details of machine instruction formats or encoding.   An exception may occur during debugging when it may be necessary to monitor instructions fetched on the bus, read unformatted memory dumps, etc.  This section provides the information necessary to translate or decode an 8086 or 8088 machine instruction.   

To pack instructions into memory as densly as possible, the 8086 and 8088 CPUs utilize an efficient coding technique.  Machine instructions vary from one to six bytes in length.  One-byte instructions, which generally operate on single registers or flags are simple to identify.  The keys to decoding longer instructions are in the first two bytes.  The format of these bytes can vary, but most instructions follow the format shown in figure 4-20.

The first six bits of a multibyte instruction generally contain an opcode that identifies the basic instruction type: ADD, XOR, etc.  The following bit, called the D field, generally specifies the 'direction' of the operation:  1 = the REG field in the second byte identifies the destination operand, 0 the REG field identifies the source operand.  The W field distinguishes between byte and word operations: 0 = byte, 1 = word.  (8 bits vs 16 bits)

One of three additional single-bit fields, S, V or Z appears in some instruction formats.  S is used in conjunction with W to indicate sign extension of immediate fields in arithmetic instructions.  V distinguishes between single and variable-bit shifts and rotates.  Z is used as a compare bit with the zero flag in conditional repeat and loop instructions.  All single-bit field settings are summarized in table 4-7

The second byte of the instruction usually identifies the instruction's operands.  The MOD (mode) field indicates whether one of the operands is in memory or whether both operands are registers (see table 4-8). The REG (register) field identifies a register that is one of the instruction operands (see table 4-9). In a number of instructions, chiefly the immediate-to-memory variety, REG is used as an extension of the opcode to identify the type of operation.  The encoding of the R/M (register/memory) field(see table 4-10)  depends on how the mode field is set.  If MOD = 11 (register-to-register), then R/M identifies the second register operand.  If MOD selects memory mode, then R/M indicates how the effective address of the memory operand is to be calculated.  Effective address calculation is covered in detail in section 2.8.

Bytes 3 through 6 of an instruction are optional fields that usually contain the displacement value of a memory operand and/or the actual value of an immediate constant operand.

