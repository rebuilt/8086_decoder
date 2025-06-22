# The Intel 8086 CPU has a set of general-purpose, segment, pointer/index, status/control, and instruction-related registers. 

## 🧮 General Purpose Registers (16-bit, can be accessed as 8-bit halves)
| 16-bit | High 8-bit | Low 8-bit | Typical Use                                          |
| ---    | ---        | ---       | ---                                                  |
| AX     | AH         | AL        | Accumulator (e.g.    arithmetic operations)          |
| BX     | BH         | BL        | Base register (e.g.  address calculations)           |
| CX     | CH         | CL        | Counter (e.g.        loops                   shifts) |
| DX     | DH         | DL        | Data register (e.g.  I/O operations)                 |

## 📦 Segment Registers (16-bit)

| Name | Purpose       |
| ---  | ---           |
| CS   | Code Segment  |
| DS   | Data Segment  |
| SS   | Stack Segment |
| ES   | Extra Segment |

These are used to access different memory segments (since 8086 uses segmented memory addressing).
## 📍 Pointer and Index Registers (16-bit)
| Name | Purpose                                    |
| ---  | ---                                        |
| SP   | Stack Pointer (offset in SS)               |
| BP   | Base Pointer (used for stack frame access) |
| SI   | Source Index (used in string ops)          |
| DI   | Destination Index (used in string ops)     |

## 🚦 Instruction Pointer and Flags
| Name  | Purpose                            |
| ---   | ---                                |
| IP    | Instruction Pointer (offset in CS) |
| FLAGS | Status and Control Flags Register  |

### Key FLAGS bits include:

   * CF: Carry Flag

   * PF: Parity Flag

   * AF: Auxiliary Carry Flag

   * ZF: Zero Flag

   * SF: Sign Flag

   * TF: Trap Flag

   * IF: Interrupt Enable Flag

   * DF: Direction Flag

   * OF: Overflow Flag
