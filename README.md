# promela

Gerar o `pan.c` do enquadramento:

> ./spin -a enq.pml

Para o arq:

> ./spin -a arq.pml


Após gerar o pan.c do pml desejado, basta compilar ele:

> gcc -o pan pan.c

Na sequênica é so rodar:

> ./pan -a -N prop1



###enq.pml: ltl prop2 { [](fram_rx@tx_data  -> <>(fram_rx:cnt_rx==false)) }

(Spin Version 6.5.1 -- 20 December 2019)
        + Partial Order Reduction

Full statespace search for:
        never claim             + (prop2)
        assertion violations    + (if within scope of claim)
        acceptance   cycles     + (fairness disabled)
        invalid end states      - (disabled by never claim)

State-vector 48 byte, depth reached 4523, errors: 0
   252330 states, stored (253086 visited)
   126960 states, matched
   380046 transitions (= visited+matched)
        0 atomic steps
hash conflicts:       564 (resolved)

Stats on memory usage (in Megabytes):
   18.289       equivalent memory usage for states (stored*(State-vector + overhead))
   13.764       actual memory usage for states (compression: 75.26%)
                state-vector as stored = 29 byte + 28 byte overhead
  128.000       memory used for hash table (-w24)
    0.534       memory used for DFS stack (-m10000)
  142.206       total actual memory usage


unreached in proctype fram_tx
        enq.pml:26, state 15, "tx!flag"
        enq.pml:29, state 20, "-end-"
        (2 of 20 states)
unreached in proctype fram_rx
        enq.pml:93, state 62, "-end-"
        (1 of 63 states)
unreached in claim prop2
        _spin_nvr.tmp:10, state 13, "-end-"
        (1 of 13 states)

pan: elapsed time 0.32 seconds
pan: rate 790893.75 states/second