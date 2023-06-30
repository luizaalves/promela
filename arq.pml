bool down = true;
bool down2 = true;
bool msg_received = true;

mtype = {ack, data};

// Canais: mensagens formadas por tipo (data ou ack) e 
// número de sequência (0 ou 1)
// Canal tx: vai do transmissor para o receptor (fluem quadros data)
// Canal rx: vai do receptor para o transmissor (fluem quadros ack)
chan tx = [1] of {mtype, bit};
chan rx = [1] of {mtype, bit};

// protocolo nunca termina !

active proctype transmissor() {
  bit seq = 0; // número de sequência atual
  bit num;

  ocioso: // estado ocioso
    if
    :: msg_received ->
       tx!data, seq; // enviou data
       printf("transmissor transmitiu msg %d\n", seq);
       msg_received = false;
       down = false;
       goto espera;
    fi;

  espera: // estado espera
  do
  :: rx?ack, num -> // simula erro
     skip;
  :: rx?ack, eval(seq) ->//se eu recebi um ack correto
      msg_received = true;
      down = true
      printf("transmissor recebeu ack %d\n", seq);
      seq = !seq;
      goto ocioso;
  :: rx?ack, eval(!seq) ->
      printf("transmissor recebeu ack incorreto: %d\n", !seq);
      skip;
  :: timeout -> 
     printf("retransmitiu data %d\n", seq);
     tx!data, seq;
  od
}

active proctype receptor() {
  bit seq = 0; // número de sequência atual
  bit num;

  do
  :: tx?data, num -> // simula erro
     skip;
  :: tx?data, eval(seq) ->
     printf("receptor recebeu data %d\n", seq);
     rx!ack, seq;
     seq = !seq;
  :: tx?data, eval(!seq) ->
     printf("receptor recebeu data duplicado %d\n", !seq);
     rx!ack, !seq;
  od
}

// Se uma mensagem for transmitida, ela será recebida em algum momento
ltl prop1 { (!down -> <> down)}
//ltl prop1 { [] (! (tx!data, seq) || <> (rx!ack, eval(seq))) }

//Uma nova mensagem é transmitida somente se a mensagem anterior for confirmada
ltl prop2 { (!msg_received -> <> msg_received)}
// ltl prop2 { [] (!((tx!data, eval(seq)) && !((tx!data, eval(seq)) U (rx!ack, eval(seq))))) }