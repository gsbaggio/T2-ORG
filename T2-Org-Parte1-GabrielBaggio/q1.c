#include <stdio.h>

void troca(int* x, int* y)
{
    int tmp;
    
    tmp = *x;
    *x = *y;
    *y = tmp;
}

int media3x2y(int x, int y)
{
    
    int a;
    int b;

    a = 3 * x;
    b = 2 * y;
    if (x < y) {
        troca(&a, &b);
    }
    while (a > b) {
        a = a - 1;
        b = b + 1;
    }
    return a;

}

int x;

int main(void)
{
    int y;
    int z;

    x = 5;
    y = 10;

    z = media3x2y(x, y);

    printf("O resultado e %d\n", z);

    return 0;
}