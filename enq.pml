bool perdeu = false;
bool rx_cnt = false;

mtype = {flag, esc, data};

chan tx = [1] of {byte};

int max_size = 32;

active proctype fram_tx() {
  int cnt;

inicio:
  tx!flag;
  cnt = 0;

  do
  :: cnt < max_size ->
     if
     :: tx!data -> cnt++;
     :: tx!esc ->
        tx!data;
        cnt++;
     fi;
  :: cnt > 0 ->
     tx!flag;
     goto inicio;
  :: else ->
     tx!flag;
     goto inicio;
  od;
}

active proctype fram_rx() {
  int cnt;
  mtype octeto;

estado_ocioso:
  rx_cnt = false;
  cnt = 0;
  perdeu = false;
  do
  :: tx?flag -> goto estado_rx;
  :: tx?data -> skip; // ignora 
  :: tx?esc -> skip; // ignora
  :: tx?octeto -> skip; // simula erro de recepção
  od;

estado_rx: 

  do 
  :: tx?data -> cnt++;
  :: tx?esc -> goto estado_esc;
  :: tx?flag -> 
     if
     :: cnt == 0 -> skip;
     :: else -> goto estado_ocioso;
     fi;
  :: cnt > max_size -> 
    rx_cnt = true;
    goto estado_ocioso;
  :: tx?octeto -> 
    // perdeu sincronismo
    perdeu = true;
    skip;
  od;

estado_esc:
  do
  :: tx?data -> 
     cnt++;
     goto estado_rx;
  :: tx?flag -> // erro ... não deveria receber flag
    goto estado_ocioso;
  :: tx?esc -> // erro ... não deveria receber esc
    goto estado_ocioso;
  :: tx?octeto -> 
    // perdeu sincronismo
    perdeu = true;
    skip;
  od;
}

// Perdas de sincronismo no enquadramento são recuperadas em algum momento futuro após erros cessarem
//ltl prop1 { (perdeu==2 -> <> perdeu == 0) }
ltl prop1 { (perdeu -> <> !perdeu)}
//

// Quadros que excedam o tamanho máximo são descartados pelo receptor
ltl prop2 { ( rx_cnt  -> !rx_cnt) }