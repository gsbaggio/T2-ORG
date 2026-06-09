#include <stdio.h>

/* copia a string s1 para a string s2    */
/* o final das strings terminam com um 0 */
void copiaString(char *s1, char *s2)
{
	while(*s1 != '\0'){
		*s2 = *s1;
		s2++;
		s1++;
	}
	*s2 = '\0';
}

char string1[] = "teste de uma string\0xxxxxx";
char string2[] = "???????????????????????????";
    
int main(void)
{ 	
	copiaString(string1, string2);
	printf("%s\n", string2);
    return 0;
}
