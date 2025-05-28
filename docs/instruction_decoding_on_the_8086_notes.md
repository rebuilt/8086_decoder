# Instruction decode on the 8086
section 4-19 in reference manual (pg 258)
## Mnemonic 
Programmers use mnemonics when writting assembly.  Example instruction: mov
Copy the data from BX into the AX register

```assembly
MOV AX, BX
```

This gets encoded into two bytes.

| 8Bit       | 8Bit        |
| ----       | ----        |
| OPCODE D W | MOD REG RM  |
| 000000 0 0 | 00  000 000 |
| ----       | ---         |

| Section | Description                                         |
| ---     | ---                                                 |
| Opcode  | Operation (instruction) code                        |
| D       | Direction (to register/ from register)              |
| W       | Word/Byte operation                                 |
| MOD     | Register mode/memory mode with displacement length  |
| REG     | Register operand/Extension of opcode                |
| R/M     | Register operand/registers to use in EA calculation |

MOD  - is this a register operation or is it a memory operation?

| Code | Explanation                                          |
| ---- | ----                                                 |
| 00   | Memory Mode, no displacement follows                 |
| 01   | Memory Displacement mode, 8-bit displacement follows |
| 10   | Memory Mode, 16-bit displacement follows             |
| 11   | Register Mode no displacement                        |

| REG | W = 0 | W = 1 |
| --- | ---   | ---   |
| 000 | AL    | AX    |
| 001 | CL    | CX    |
| 010 | DL    | DX    |
| 011 | BL    | BX    |
| 100 | AH    | SP    |
| 101 | CH    | BP    |
| 110 | DH    | SI    |
| 111 | BH    | DI    |

| MOD = 11 | _   | _     | Effective Address calculation | _              | _                | _                 |
| R/M      | W=0 | W = 1 | R/M                           | MOD = 00       | MOD = 01         | MOD = 10          |
| 000      | AL  | AX    | 000                           | (BX) + (SI)    | (BX) + (SI) + D8 | (BX) + (SI) + D16 |
| 001      | CL  | CX    | 001                           | (BX) + (DI)    | (BX) + (DI) + D8 | (BX) + (DI) + D16 |
| 010      | DL  | DX    | 010                           | (BP) + (SI)    | (BP) + (SI) + D8 | (BP) + (SI) + D16 |
| 011      | BL  | BX    | 011                           | (BP) + (DI)    | (BP) + (DI) + D8 | (BP) + (DI) + D16 |
| 100      | AH  | SP    | 100                           | (SI)           | (SI) + D8        | (SI) + D16        |
| 101      | CH  | BP    | 101                           | (DI)           | (DI) + D8        | (DI) + D16        |
| 110      | DH  | SI    | 110                           | Direct Address | (BP) + D8        | (BP) + 16         |
| 111      | BH  | DI    | 111                           | (BX)           | (BX) + 8         | (BX) + 16         |
