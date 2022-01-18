_start:
        # Load some constants and do some arithmetic
        li a0, 0
        li a1, 1
        li a2, 2
        li a5, 0x74657374          # a1 = “test”
        li a6, 0x6c656574          # "LEET"

        .insn i 0x0b, 2, a4, a5, 0 # leet a4, a5
        .insn i 0x0b, 2, a5, a6, 0 # leet a5, a6


exit:
        # Similar to exit(0) in C.
        li a0, 0
        li a1, 0
        li a2, 0
        li a7, 93
        ecall


        
        
