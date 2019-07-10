.section ".text.boot"

.global _start

_start:
    mrc p15, #0, r1, c0, c0, #5 //read coprocessor's multiprocessor affinity register (MPIDR)
    and r1, r1, #3 //r1 = r1 & 0x11 [1:0] -> CPU ID
    cmp r1, #0 //r1 == 0
    bne halt //if cpu != 0 go halt

    mov sp, #0x8000

    // set zeros from __bss_start to __bss_end
    ldr r4, =__bss_start
    ldr r9, =__bss_end
    mov r5, #0
    mov r6, #0
    mov r7, #0
    mov r8, #0
    b       2f // go label 2 forward
1:
    stmia r4!, {r5-r8} // stm + ia(increment after)
2:
    cmp r4, r9
    blo 1b // go label 1 backword

    ldr r3, =kernel_main
    blx r3

halt:
    wfe
    b halt