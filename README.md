# fpga

// built based on
// https://github.com/secworks/blake2/blob/master/src/rtl/blake2_G.v
// https://github.com/Toms42/fpga-hash-breaker/blob/master/design%20files/hash-operation.v

blake2
======

## Introduction ##

This is a Verilog implementation of the Blake2 hash function. The specific
function implemented is BLAKE2b.


## Implementation status ##
***Unknown***
Seems to work for single block messages. But seems to not work for multi
block messages. Still needs to be investigated.


## Implementation details ##
To Be Written.

Supports multiple digest lengths: 20, 32, 48 and 64 bytes.


## Usage ##

### Quick start ###

```verilog
blake2_core #(
    .DIGEST_LENGTH(32)          // The length of the digest in bytes (20, 32, 48, 64)
) hasher (
    .clk(clk),                  // The module clock
    .reset_n(reset_n),          // Reset (active LOW)
    .init(init),                // Initialize the hasher (active HIGH)
    .next(next),                // Go to the next block (if data_length > 128 bytes)
    .final_block(final_block),  // This is the final block
    .block(block),              // The 128-byte block (padded if data_length < 128 bytes)
    .data_length(data_length),  // The byte length of the input data
    .ready(ready),              // HIGH when the core is ready to hash
    .digest(digest),            // The digest output
    .digest_valid(digest_valid) // HIGH when the digest output is valid
);
```

## FPGA-results ##

### Altera FPGAs ###

To Be Written.


### Xilinx FPGAs ###

To Be Written.


## Credits ##


## Further reading ##

- https://blake2.net/
- https://tools.ietf.org/html/draft-saarinen-blake2
- https://en.wikipedia.org/wiki/BLAKE_%28hash_function%29
