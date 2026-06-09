#include <stdio.h>

/* cálculo do fatorial, usando uma função não recursiva */
/***************/
int fact2(int n)
/***************/
{
    int tmp;
    tmp = 1;
    if (n == 0)
        return 1;
    else
    {
        tmp = n;
        while (n > 1)
        {
            n = n - 1;
            tmp = tmp * n;
        }
        return tmp;
    }
}

/* calculamos o fatorial de k=5, igual a 120 */
/**************/
int main(void)
/**************/
{
    int k;
    k = 5;
    k = fact2(k);
    printf("%d\n", k);
    return 0;
}
