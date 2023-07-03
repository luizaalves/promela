# promela

Gerar o `pan.c` do enquadramento:

> ./spin -a enq.pml

Para o arq:

> ./spin -a arq.pml


Após gerar o pan.c do pml desejado, basta compilar ele:

> gcc -o pan pan.c

Na sequênica é so rodar:

> ./pan -a -N prop1



###enq.pml prop2

pan: ltl formula prop2

(Spin Version 6.5.1 -- 20 December 2019)
        + Partial Order Reduction

Full statespace search for:
        never claim             + (prop2)
        assertion violations    + (if within scope of claim)
        acceptance   cycles     + (fairness disabled)
        invalid end states      - (disabled by never claim)

State-vector 48 byte, depth reached 3977, errors: 0
   216086 states, stored
   119927 states, matched
   336013 transitions (= stored+matched)
        0 atomic steps
hash conflicts:      1500 (resolved)

Stats on memory usage (in Megabytes):
   15.662       equivalent memory usage for states (stored*(State-vector + overhead))
   13.465       actual memory usage for states (compression: 85.97%)
                state-vector as stored = 37 byte + 28 byte overhead
  128.000       memory used for hash table (-w24)
    0.534       memory used for DFS stack (-m10000)
  141.913       total actual memory usage


unreached in proctype fram_tx
        enq.pml:27, state 15, "tx!flag"
        enq.pml:30, state 20, "-end-"
        (2 of 20 states)
unreached in proctype fram_rx
        enq.pml:88, state 56, "-end-"
        (1 of 56 states)
unreached in claim prop2
        _spin_nvr.tmp:14, state 2, "assert(!((!(((tx==data)||(tx==esc)))||!((fram_rx.cnt_rx==0)))))"
        _spin_nvr.tmp:19, state 10, "assert(!(!(((tx==data)||(tx==esc)))))"
        _spin_nvr.tmp:24, state 18, "-end-"
        (3 of 18 states)

pan: elapsed time 0.28 seconds
pan: rate 771735.71 states/second