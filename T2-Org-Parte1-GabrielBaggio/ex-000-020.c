#include <stdio.h>

/* Procedimento que retorna o argumento de menor valor. Os argumentos são os
 * elementos de uma lista de inteiros.
 * int a0: primeiro elemento da lista de números inteiros
 * int a1: segundo elemento da lista
 * int a2: terceiro elemento da lista
 * Retorno:
 * int   : argumento de menor valor (menor valor de uma lista de inteiros)
 */
int menorValor(int a0, int a1, int a2)
{
  int menor;
  menor = a0;
  if (a1 < menor)
    menor = a1;
  if (a2 < menor)
    menor = a2;
  return menor;
}

/* Procedimento que retorna o argumento de maior valor. Os argumentos são os
 * elementos de uma lista de inteiros.
 * int a0: primeiro elemento da lista de números inteiros
 * int a1: segundo elemento da lista
 * int a2: terceiro elemento da lista
 * Retorno:
 * int   : argumento de maior valor (maior valor de uma lista de inteiros)
 */
int maiorValor(int a0, int a1, int a2)
{
  int maior;
  maior = a0;
  if (a1 > maior)
    maior = a1;
  if (a2 > maior)
    maior = a2;
  return maior;
}

/* Procedimento que retorna o soma do argumento de maior valor com o argumento de
 * menor valor, de um conjunto de 3 argumentos. Os argumentos são os elementos de
 * uma lista de inteiros.
 * Argumentos:
 * int a0: primeiro elemento da lista de números inteiros
 * int a1: segundo elemento da lista
 * int a2: terceiro elemento da lista
 * Retorno:
 * int   : soma do maior com o menor elemento da lista
 *
 */
int soma_maior_menor(int a0, int a1, int a2)
{
  int maior;                      // O maior valor dos argumentos (lista de inteiros)
  int menor;                      // O menor valor dos arqgumentos (lista de inteiros)
  int soma;                       // Soma do maior com o menor valor dos argumentos
  maior = maiorValor(a0, a1, a2); // encontramos o maior valor da lista
  menor = menorValor(a0, a1, a2); // encontramos o menor valor da lista
  soma = maior + menor;           // somamos o maior com o menor valor da lista
  return soma;                    // retornamos com o valor da soma
}

/* Procedimento que apresenta a soma do maior valor com o menor valor de uma
 * lista de 3 valores inteiros
 */
int main(void)
{
  int k;
  k = soma_maior_menor(3, 1, 2);
  printf("A soma do maior e menor valor da lista é %d\n", k);
  return 0;
}
