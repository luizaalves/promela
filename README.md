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


#### Erro 

pan: ltl formula prop1
pan:1: acceptance cycle (at depth 402)
pan: wrote enq.pml.trail

(Spin Version 6.5.1 -- 20 December 2019)
Warning: Search not completed
        + Partial Order Reduction

Full statespace search for:
        never claim             + (prop1)
        assertion violations    + (if within scope of claim)
        acceptance   cycles     + (fairness disabled)
        invalid end states      - (disabled by never claim)

State-vector 48 byte, depth reached 1158, errors: 1
      604 states, stored (634 visited)
       15 states, matched
      649 transitions (= visited+matched)
        0 atomic steps
hash conflicts:         0 (resolved)

Stats on memory usage (in Megabytes):
    0.044       equivalent memory usage for states (stored*(State-vector + overhead))
    0.281       actual memory usage for states
  128.000       memory used for hash table (-w24)
    0.534       memory used for DFS stack (-m10000)
  128.730       total actual memory usage



pan: elapsed time 0 seconds


##### -t

ltl prop1: [] (<> ((rcv==1)))
ltl prop2: ([] (((tx==data)) || ((tx==esc)))) && ((fram_rx:cnt_rx==0))
Never claim moves to line 3     [(!((rcv==1)))]
Never claim moves to line 8     [(!((rcv==1)))]
  <<<<<START OF CYCLE>>>>>
spin: trail ends after 1148 steps
#processes: 2
                rcv = 0
                queue 1 (tx): 
                max_size = 32
1148:   proc  1 (fram_rx:1) enq.pml:69 (state 35)
1148:   proc  0 (fram_tx:1) enq.pml:12 (state 1)
1148:   proc  - (prop1:1) _spin_nvr.tmp:7 (state 10)
2 processes created

pan: elapsed time 0.28 seconds
pan: rate 771735.71 states/second
