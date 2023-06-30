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



// ---------------------------------------------------------------------------------
// Se uma mensagem for transmitida, ela será recebida em algum momento
// G (tx!data,seq -> F (rx!ack,eval(seq)))
// ---------------------------------------------------------------------------------

// A fórmula tx!data,seq representa o evento em que o transmissor envia uma mensagem data com sequência seq.
// A fórmula rx!ack,eval(seq) representa o evento em que o receptor recebe uma mensagem ack com o valor da sequência seq.
// A fórmula F (rx!ack,eval(seq)) significa "eventualmente, o receptor recebe uma mensagem ack com o valor da sequência seq".
// A fórmula G (tx!data,seq -> F (rx!ack,eval(seq))) nega a propriedade anterior e a coloca dentro de um operador "G" (global), 
// o que significa que a propriedade deve ser verdadeira em todos os estados. 

// Em outras palavras, em todos os momentos em que o transmissor envia uma mensagem data com sequência seq,
// eventualmente o receptor deve receber uma mensagem ack com o valor da sequência seq.
// Portanto, essa fórmula expressa a propriedade de garantia de que todas as mensagens data enviadas pelo transmissor
//  são confirmadas pelo receptor com a mensagem ack correspondente.

// LTL adaptado
ltl prop1 { [] (! (tx!data, seq) || <> (rx!ack, eval(seq))) }

ltl prop1 { (!down -> <> down)}


// ---------------------------------------------------------------------------------
// Uma nova mensagem é transmitida somente se a mensagem anterior for confirmada
// G (tx!data,seq -> (tx!data,eval(seq)) U (rx!ack,eval(seq)))
// ---------------------------------------------------------------------------------

// Essa propriedade afirma que, globalmente (G), para qualquer envio de mensagem (tx!data,seq), 
// a transmissão de uma nova mensagem (tx!data,eval(seq)) ocorrerá somente se a mensagem anterior 
// tiver sido confirmada (rx!ack,eval(seq)). O operador U (until) representa a condição de que a 
// nova mensagem só será enviada até que o reconhecimento correspondente à mensagem anterior seja recebido.

// LTL adaptado
//ltl prop2 { [] (!((tx!data, eval(seq)) && !((tx!data, eval(seq)) U (rx!ack, eval(seq))))) }


ltl prop2 { (!msg_received -> <> msg_received)}









