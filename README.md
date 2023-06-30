# promela

Gerar o `pan.c` do enquadramento:

> ./spin -a enq.pml

Para o arq:

> ./spin -a arq.pml


Após gerar o pan.c do pml desejado, basta compilar ele:

> gcc -o pan pan.c

Na sequênica é so rodar:

> ./pan -a -N prop1
