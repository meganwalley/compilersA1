#include <iostream>
#include "env.h"

using namespace std;

int main() {
    int x = 0;
    printInt(x);
    x = x * ++x + x++ * x;
    {
        int y;
        if (x >= 0) {
            y = 1;
        } else {
            y = -1;
        }
        printInt(y);
    }
    return 0;
}