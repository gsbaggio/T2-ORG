
/* retorna valor1 + 1 */
/************************/
int incrementa(int valor1)
/************************/
{
  int resultado;

  resultado = valor1 + 1;
  return resultado;
}

/* retorna (valor1+valor2)+1*/
/*****************************************/
int soma_incrementa(int valor1, int valor2)
/*****************************************/
{
  int soma;
  int resultado;

  soma = valor1 + valor2;
  resultado = incrementa(soma);
  return resultado;
}

/* calcula (var0+var1)+1 = (10+20)+1 = 31*/
/************/
int main(void)
/************/
{
  int var0, var1, var2;
  var0 = 10;
  var1 = 20;
  var2 = soma_incrementa(var0, var1);
  return 0;
}
