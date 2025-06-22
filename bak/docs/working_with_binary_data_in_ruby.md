# Declare binary number
0b1010

Convert a binary string representation to binary

```
'0b1010'.to_i(2)
'1010'.to_i(2)
```

Convert a decimal to hex
```
10.to_s(16)

```

## Bitwise operations

```

    & bitwise AND
    | bitwise OR
    ^ bitwise XOR
    ~ bitwise NOT
    >> right shift
    << left shift

```

| X   | Y   | X & Y | X \| Y | X^Y |
| --- | --- | ---   | ---    | --- |
| 0   | 0   | 0     | 0      | 0   |
| 0   | 1   | 0     | 1      | 1   |
| 1   | 0   | 0     | 1      | 1   |
| 1   | 1   | 1     | 1      | 0   |


# check for even number
```
1 & 1 
=> 1

2 & 1
=> 0

odd?
```

# Dates can be packed in 16-bit integer

| Range     | Bits |
|-----------|------|
| 12 months | 4    |
| 31 days   | 5    |
| 128 year  | 7    |



| Range | Bits    | Decimal |
| ----- | ------- | ------- |
| Month | 0100    | 4       |
| Day   | 00110   | 6       |
| Year  | 1110010 | 114     |

date = 0b0100001101110010
day_mask = 0b0000111110000000
month_mask = 0b1111000000000000
year_mask = 0b0000000001111111
