_start:
        # Load some constants and do some arithmetic
        li a0, 0
        li a1, 1
        li a2, 2
        li a3, 3
        li a4, 4
        li a5, 5
        li a6, 6
        li a7, 7
        add t0, a1, a2
        add t1, a3, a4
        add t2, a4, a5
        add t0, t1, t2
exit:
        # Similar to exit(0) in C.
        li a0, 0
        li a1, 0
        li a2, 0
        li a7, 93
        ecall
