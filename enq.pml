mtype = {flag, esc, data};

chan tx = [1] of {byte};

int max_size = 32;
int cnt_fram_rx;

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
  mtype octeto;

estado_ocioso:
  cnt_fram_rx = 0;
  do
  :: tx?flag -> goto estado_rx;
  :: tx?data -> skip; // ignora 
  :: tx?esc -> skip; // ignora
  :: tx?octeto -> skip; // simula erro de recepção
  od;

estado_rx: 

  do 
  :: tx?data -> cnt_fram_rx++;
  :: tx?esc -> goto estado_esc;
  :: tx?flag -> 
     if
     :: cnt_fram_rx == 0 -> skip;
     :: else -> goto estado_ocioso;
     fi;
  :: cnt_fram_rx > max_size -> 
    goto estado_ocioso;
  :: tx?octeto -> 
    // perdeu sincronismo
    skip;
  od;

estado_esc:
  do
  :: tx?data -> 
     cnt_fram_rx++;
     goto estado_rx;
  :: tx?flag -> // erro ... não deveria receber flag
    goto estado_ocioso;
  :: tx?esc -> // erro ... não deveria receber esc
    goto estado_ocioso;
  :: tx?octeto -> 
    // perdeu sincronismo
    skip;
  od;
}
// Perdas de sincronismo no enquadramento são recuperadas em algum momento futuro após erros cessarem
ltl prop1 { [](cnt_fram_rx > 0) -> <> (cnt_fram_rx == 0) }

//Quadros que excedam o tamanho máximo são descartados pelo receptor
ltl prop2 { <>((tx==data || tx==esc) -> (cnt_fram_rx <= max_size))}