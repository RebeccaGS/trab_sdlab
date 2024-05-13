# trab_sdlab

ULA com

AND [CHECK]
OR [CHECK]
NOT [CHECK]
Soma [CHECK]
Complemento de 2 [CHECK]
Subtração [CHECK]
Multiplicação [CHECK]
Deslocador [CHECK]


1) Interface com usuário:
a. Sequência das operações: (1) definir o primeiro número através das chaves (switches);
(2) pressionar um botão arbitrário; (3) definir o segundo número através das mesmas
chaves; (4) pressionar o mesmo ou outro botão; (5) definir uma operação inicial pelas
chaves; (6) pressionar o mesmo ou outro botão para dar início a sequência de
apresentação dos números inseridos, a operação corrente e o resultado, para as
diferentes operações.
b. Os quatro LEDs mais à direita da placa deverão apresentar (em sequência, com
intervalo de 2 segundos entre cada ocorrência): o primeiro e o segundo números,
seguido pela operação e resultado, indefinidamente, alternando-se as operações.
Exemplo: se o usuário selecionou nas chaves a operação 4 como inicial, o sistema
deverá mostrar nestes LEDs o número 1, o número 2, a operação e o seu resultado,
repetindo esta sequência até atingir a operação 8. Após, deverá retornar à operação 1,
seguir para a operação 2, e assim em diante.
c. Os quatro LEDs mais à esquerda deverão sinalizar em qual etapa a interface está.
Exemplo: na leitura do número A deve-se ter: ACESO-APAGADO-APAGADO-APAGADO.
Na apresentação da operação: APAGADO-APAGADO-ACESO-APAGADO. Na exibição do
resultado: APAGADO-APAGADO- APAGADO-ACESO.
d. A carga de dois novos números deverá ser feita exclusivamente por um reset do
sistema.



Máquina de estados:
Uma máquina de estados é um modelo abstrato usado para descrever o comportamento de um sistema baseado em estados discretos. Ela consiste em um conjunto finito de estados, transições entre esses estados e a lógica que controla essas transições.

No contexto de design digital, uma máquina de estados é muitas vezes implementada como parte de um circuito digital para controlar o comportamento sequencial do sistema. Cada estado representa uma configuração ou situação específica do sistema, e as transições indicam como o sistema pode mudar de um estado para outro em resposta a estímulos externos ou internos.

A máquina de estados em VHDL é frequentemente implementada usando uma estrutura de processo sensível a mudanças de clock (ou mudanças de estado), onde as condições atuais são avaliadas e as ações apropriadas são tomadas com base nessas condições.

No exemplo que forneci, a máquina de estados tem sete estados distintos:

1. DEF_NUM_1: Aguarda o usuário definir o primeiro número através das chaves (switches).
2. BTN_PRESSED_1: Aguarda o usuário pressionar um botão após definir o primeiro número.
3. DEF_NUM_2: Aguarda o usuário definir o segundo número através das mesmas chaves.
4. BTN_PRESSED_2: Aguarda o usuário pressionar um botão após definir o segundo número.
5. DEF_OPERATION: Aguarda o usuário definir uma operação inicial pelas chaves.
6. BTN_PRESSED_OP: Aguarda o usuário pressionar um botão após definir a operação.
7. DISPLAY: Exibe os números inseridos, a operação corrente e o resultado nos LEDs.

As transições entre esses estados são controladas pelas condições especificadas em cada caso. Por exemplo, a transição do estado DEF_NUM_1 para BTN_PRESSED_1 ocorre quando o botão é pressionado. Cada estado também executa as ações necessárias para o funcionamento do sistema, como armazenar os números inseridos, calcular o resultado e exibir as informações nos LEDs.

Isso é uma visão geral básica de como uma máquina de estados funciona e como ela é implementada em VHDL para controlar o comportamento de um sistema digital.